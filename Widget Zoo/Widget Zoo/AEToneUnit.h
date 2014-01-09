//
//  AEToneUnit.h
//  stc.iOSWidgets
//
//  Created by Ian Morris Nieves on 8/5/13.
//  Copyright (c) 2013 Ian Morris Nieves. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <AudioUnit/AudioUnit.h>
//#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>

#define SINE_WAVE_TONE_GENERATOR_SAMPLE_RATE_DEFAULT 44100.0f

#define SINE_WAVE_TONE_GENERATOR_FREQUENCY_HZ_LOW 440.0f
#define SINE_WAVE_TONE_GENERATOR_FREQUENCY_HZ_HIGH 880.0f
#define SINE_WAVE_TONE_GENERATOR_FREQUENCY_PERCENT_DEFAULT 0

#define SINE_WAVE_TONE_GENERATOR_AMPLITUDE_LOW 0.0000f
#define SINE_WAVE_TONE_GENERATOR_AMPLITUDE_HIGH 0.25f
#define SINE_WAVE_TONE_GENERATOR_AMPLITUDE_PERCENT_DEFAULT 0

@interface AEToneUnit : NSObject
{
    AudioComponentInstance audioComponentInstance;
    
@public
    double frequencyHz;
	double frequencyPercent;
	double amplitudeAbsolute;
    double amplitudePercent;
    double theta;
}

- (void) startPlaying;
- (BOOL) isPlaying;
- (void) stopPlaying;

- (float) frequencyHz;
- (float) frequencyPercent;
- (void) setFrequencyPercent:(float)inFrequencyPercent;
- (float) amplitudeAbsolute;
- (float) amplitudePercent;
- (void) setAmplitudePercent:(float)inAmplitudePercent;

- (void) cleanup;

@end
