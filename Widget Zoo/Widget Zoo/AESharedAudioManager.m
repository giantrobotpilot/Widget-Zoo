//
//  AESharedAudioManager.m
//  stc.iOSWidgets
//
//  Created by Ian Morris Nieves on 7/30/13.
//  Copyright (c) 2013 Ian Morris Nieves. All rights reserved.
//

#import "AESharedAudioManager.h"
#import <AVFoundation/AVFoundation.h>
#import "AEVolumeChangeListener.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AESharedAudioManager()
// ALL AUDIO
@property (nonatomic) BOOL appAudioSessionActive;
// VOLUME
@property (nonatomic) float _appVolumePercent;
@property (nonatomic, strong) NSMutableArray *volumeChangeListeners;
// TONE UNITS
@property (nonatomic, strong) NSMutableArray *toneUnits;
// NOISE LEVEL
@property (nonatomic) BOOL _isUpdating;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@end

void AESharedAudioManagerInterruptionCallback(void *inClientData, UInt32 inInterruptionState){
	// HANDLE THE INTERRUPTION
	//AESharedAudioManager *sharedAudioManager = (__bridge AESharedAudioManager *)inClientData;
	// XXXX
}

@implementation AESharedAudioManager

// All AUDIO
@synthesize appAudioSessionActive;
// VOLUME
@synthesize musicPlayerController;
@synthesize _appVolumePercent;
@synthesize volumeChangeListeners;
// TONE UNITS
@synthesize toneUnits;
// NOISE LEVEL
@synthesize _isUpdating;
@synthesize audioRecorder;

static AESharedAudioManager *sharedInstance = nil;

+(AESharedAudioManager*) sharedInstance{
	if (sharedInstance == nil) {
		sharedInstance = [[super alloc]init];
    }
    return sharedInstance;
}

- (id)init{
    self = [super init];
    if (self) {
		// AUDIO SESSION	 
		appAudioSessionActive = NO;
		// VOLUME
		musicPlayerController = [MPMusicPlayerController iPodMusicPlayer];
		_appVolumePercent = [musicPlayerController volume];
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter addObserver:self
							   selector:@selector(handleExternalVolumeChanged:)
								   name:MPMusicPlayerControllerVolumeDidChangeNotification
								 object:musicPlayerController];
		[musicPlayerController beginGeneratingPlaybackNotifications];
        NSLog(@"musicPlayerController nowPlayingItem = %@", musicPlayerController.nowPlayingItem);
        
		volumeChangeListeners = [[NSMutableArray alloc] init];
		// TONE UNITS
		toneUnits = [[NSMutableArray alloc] init];
		// NOISE LEVEL
		NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
								  [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
								  [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
								  [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
								  [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
								  nil];
		NSError* error = nil;
		NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
		self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url
														 settings:settings
															error:&error];
    }
    return self;
}

///////////////////
// AUDIO SESSION //
///////////////////
- (void) startAppAudioSession {
	if(!appAudioSessionActive){
		OSStatus audioSessionInitializeResult = AudioSessionInitialize(NULL, NULL, AESharedAudioManagerInterruptionCallback, (__bridge void *)(self));
		if (audioSessionInitializeResult == kAudioSessionNoError){
			UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
			AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
			UInt32 allowMixing = 1;
			AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(allowMixing), &allowMixing);
			UInt32 defaultToSpeaker = 1;
			AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(defaultToSpeaker), &defaultToSpeaker);
			UInt32 allowDucking = 0;
			AudioSessionSetProperty(kAudioSessionProperty_OtherMixableAudioShouldDuck, sizeof(allowDucking), &allowDucking);
		}
		AudioSessionSetActive(true);
		appAudioSessionActive = YES;
	}
}

- (BOOL) isAppAudioSessionRunning {
	return appAudioSessionActive;
}

- (void) stopAppAudioSession {
	if(appAudioSessionActive){
		[self stopPlayingAllToneUnits];
		AudioSessionSetActive(false);
		appAudioSessionActive = NO;
	}
}

////////////
// VOLUME //
////////////
- (void)handleExternalVolumeChanged:(id)notification {
	_appVolumePercent = [musicPlayerController volume];
	// NOTIFY LISTENERS
	for(NSObject<AEVolumeChangeListener> *volumeChangeListener in volumeChangeListeners){
		[volumeChangeListener appVolumeChangedExternallyToPercent:_appVolumePercent];
	}
}

- (void) addVolumeChangeListener:(id<AEVolumeChangeListener>)volumeChangeListener{
	if(![volumeChangeListeners containsObject:volumeChangeListener]){
		[volumeChangeListeners addObject:volumeChangeListener];
	}
}

- (void) removeVolumeChangeListener:(id<AEVolumeChangeListener>)volumeChangeListener{
	if([volumeChangeListeners containsObject:volumeChangeListener]){
		[volumeChangeListeners removeObject:volumeChangeListener];
	}
}

- (void) setAppVolumePercent:(float)volumePercent{
	if(volumePercent<0){ volumePercent=0; }
	else if(volumePercent>1){ volumePercent=1; }
	_appVolumePercent = volumePercent;
	[musicPlayerController setVolume:volumePercent];
}

- (float) getAppVolumePercent{
	return _appVolumePercent;
}

////////////////
// TONE UNITS //
////////////////
- (AEToneUnit *) createNewToneUnit{
	AEToneUnit *newToneUnit = [[AEToneUnit alloc] init];
	[toneUnits addObject:newToneUnit];
	return newToneUnit;
}

- (void) destroyOldToneUnit:(AEToneUnit*)toneUnit{
	if([toneUnits containsObject:toneUnit]){
		[toneUnits removeObject:toneUnit];
		[toneUnit stopPlaying];
	}
}

- (void) startPlayingAllToneUnits{
	for(AEToneUnit *toneUnit in toneUnits){
		[toneUnit startPlaying];
	}
}

- (void) stopPlayingAllToneUnits{
	for(AEToneUnit *toneUnit in toneUnits){
		[toneUnit stopPlaying];
	}
}

/////////////////
// NOISE LEVEL //
/////////////////
-(NSNumber*) getAveragePower{
	if(self._isUpdating){
		[self.audioRecorder updateMeters];
		return [NSNumber numberWithFloat:[self.audioRecorder averagePowerForChannel:0]];
	}
	else{
		return nil;
	}
}

-(NSNumber*) getPeakPower{
	if(self._isUpdating){
		[self.audioRecorder updateMeters];
		return [NSNumber numberWithFloat:[self.audioRecorder peakPowerForChannel:0]];
	}
	else{
		return nil;
	}
}

-(void) startUpdates{
	if(!self._isUpdating){
        NSLog(@"AUDIO RECORDER: %s", __PRETTY_FUNCTION__);
		[self.audioRecorder prepareToRecord];
		[self.audioRecorder setMeteringEnabled:YES];
		[self.audioRecorder record];
		self._isUpdating = YES;
	}
}

-(BOOL) isUpdating{
	return self._isUpdating;
}

-(void) stopUpdates{
	if(self._isUpdating){
        NSLog(@"AUDIO RECORDER: %s", __PRETTY_FUNCTION__);
		[self.audioRecorder stop];
		self._isUpdating = NO;
	}
}

///////////////////
// IPOD CONTROLS //
///////////////////
- (MPMusicPlaybackState) getIPodPlaybackState{
	return [musicPlayerController playbackState];
}

- (MPMediaItem *) getIPodNowPlayingItem{
	return [musicPlayerController nowPlayingItem];
}

- (void) playIPod{
	[musicPlayerController play];
}

- (void) pauseIPod{
	[musicPlayerController pause];
}

@end
