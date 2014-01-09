//
//  AEToneUnit.m
//  stc.iOSWidgets
//
//  Created by Ian Morris Nieves on 8/5/13.
//  Copyright (c) 2013 Ian Morris Nieves. All rights reserved.
//

#import "AEToneUnit.h"

OSStatus RenderTone( void *inRefCon,
					AudioUnitRenderActionFlags   *ioActionFlags,
					const AudioTimeStamp 		*inTimeStamp,
					UInt32 						inBusNumber,
					UInt32 						inNumberFrames,
					AudioBufferList 			*ioData){
	// Get the tone parameters out of the object
	AEToneUnit *toneUnit = (__bridge AEToneUnit *)inRefCon;
	double theta = toneUnit->theta;
    double amplitude = toneUnit->amplitudeAbsolute;
	double theta_increment = 2.0 * M_PI * toneUnit->frequencyHz / SINE_WAVE_TONE_GENERATOR_SAMPLE_RATE_DEFAULT;
	// This is a mono tone generator so we only need the first buffer
	const int channel = 0;
	Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
	// Generate the samples
	for (UInt32 frame = 0; frame < inNumberFrames; frame++)	{
		buffer[frame] = sin(theta) * amplitude;
		theta += theta_increment;
		if (theta > 2.0 * M_PI){
			theta -= 2.0 * M_PI;
		}
	}
	// Store the theta back in the view controller
	toneUnit->theta = theta;
	return noErr;
}

@interface AEToneUnit()
@property (nonatomic) BOOL isAudioUnitRunning;
@end


@implementation AEToneUnit

@synthesize isAudioUnitRunning;

- (id)init{
    if (self = [super init]) {
		[self setFrequencyPercent:SINE_WAVE_TONE_GENERATOR_FREQUENCY_PERCENT_DEFAULT];
		[self setAmplitudePercent:SINE_WAVE_TONE_GENERATOR_AMPLITUDE_PERCENT_DEFAULT];
		theta = 0;
		[self createAudioComponentInstance];
		isAudioUnitRunning = NO;
    }
    return self;
}

- (void)createAudioComponentInstance{
	// GET DEFAULT OUTPUT
	AudioComponentDescription defaultOutputDescription;
	defaultOutputDescription.componentType = kAudioUnitType_Output;
	defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	defaultOutputDescription.componentFlags = 0;
	defaultOutputDescription.componentFlagsMask = 0;
	AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
	NSAssert(defaultOutput, @"Can't find default output");
	// CREATE NEW UNIT BASED ON THIS OUTPUT
	OSErr err = AudioComponentInstanceNew(defaultOutput, &audioComponentInstance);
	NSAssert1(audioComponentInstance, @"Error creating unit: %hd", err);
	// SET TONE RENDERING FUNCTION TO THAT UNIT
	AURenderCallbackStruct input;
	input.inputProc = RenderTone;
	input.inputProcRefCon = (__bridge void *)(self);
	err = AudioUnitSetProperty(audioComponentInstance,
                               kAudioUnitProperty_SetRenderCallback,
                               kAudioUnitScope_Input,
                               0,
                               &input,
                               sizeof(input));
	NSAssert1(err == noErr, @"Error setting callback: %hd", err);
	// SET FORMAT TO 32BIT, SINGLE CHENNEL, FP, LINEAR PCM
	const int four_bytes_per_float = 4;
	const int eight_bits_per_byte = 8;
	AudioStreamBasicDescription streamFormat;
	streamFormat.mSampleRate = SINE_WAVE_TONE_GENERATOR_SAMPLE_RATE_DEFAULT;
	streamFormat.mFormatID = kAudioFormatLinearPCM;
	streamFormat.mFormatFlags = kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
	streamFormat.mBytesPerPacket = four_bytes_per_float;
	streamFormat.mFramesPerPacket = 1;
	streamFormat.mBytesPerFrame = four_bytes_per_float;
	streamFormat.mChannelsPerFrame = 1;
	streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
	err = AudioUnitSetProperty (audioComponentInstance,
                                kAudioUnitProperty_StreamFormat,
                                kAudioUnitScope_Input,
                                0,
                                &streamFormat,
                                sizeof(AudioStreamBasicDescription));
	NSAssert1(err == noErr, @"Error setting stream format: %hd", err);
	// Stop changing parameters on the unit
	err = AudioUnitInitialize(audioComponentInstance);
	NSAssert1(err == noErr, @"Error initializing unit: %hd", err);
}

- (void) startPlaying{
	if(!isAudioUnitRunning){
		// Start playback
		OSErr err = AudioOutputUnitStart(audioComponentInstance);
		NSAssert1(err == noErr, @"Error starting unit: %hd", err);
		isAudioUnitRunning = YES;
	}
}

- (BOOL) isPlaying{
	return isAudioUnitRunning;
}

- (void) stopPlaying{
	if(isAudioUnitRunning){
		AudioOutputUnitStop(audioComponentInstance);
		isAudioUnitRunning = NO;
	}
}

- (float) frequencyHz{
	return frequencyHz;
}

- (float) frequencyPercent{
	return frequencyPercent;
}

- (void) setFrequencyPercent:(float)inFrequencyPercent{
	if(inFrequencyPercent<0){ inFrequencyPercent = 0; }
	else if(inFrequencyPercent>1){ inFrequencyPercent = 1; }
	frequencyPercent = inFrequencyPercent;
	frequencyHz = SINE_WAVE_TONE_GENERATOR_FREQUENCY_HZ_LOW
		+ inFrequencyPercent*(SINE_WAVE_TONE_GENERATOR_FREQUENCY_HZ_HIGH-SINE_WAVE_TONE_GENERATOR_FREQUENCY_HZ_LOW);
	//NSLog(@"setting freq: %f%% (%fHz)", frequencyPercent, frequencyHz);
}

- (float) amplitudeAbsolute{
	return amplitudeAbsolute;
}

- (float) amplitudePercent{
	return amplitudePercent;
}

- (void) setAmplitudePercent:(float)inAmplitudePercent{
	if(inAmplitudePercent<0){ inAmplitudePercent = 0; }
	else if(inAmplitudePercent>1){ inAmplitudePercent = 1; }
	amplitudePercent = inAmplitudePercent;
	amplitudeAbsolute = SINE_WAVE_TONE_GENERATOR_AMPLITUDE_LOW
	+ inAmplitudePercent*(SINE_WAVE_TONE_GENERATOR_AMPLITUDE_HIGH-SINE_WAVE_TONE_GENERATOR_AMPLITUDE_LOW);
	//NSLog(@"setting amp: %f%% (%f)", amplitudePercent, amplitudeAbsolute);
}

- (void) cleanup{
	if(nil!=audioComponentInstance){
		AudioUnitUninitialize(audioComponentInstance);
		AudioComponentInstanceDispose(audioComponentInstance);
		audioComponentInstance = nil;
	}
}

@end


