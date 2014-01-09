//
//  AESharedAudioManager.h
//  stc.iOSWidgets
//
//  Created by Ian Morris Nieves on 7/30/13.
//  Copyright (c) 2013 Ian Morris Nieves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AEToneUnit.h"
#import "AEVolumeChangeListener.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AESharedAudioManager : NSObject

@property (nonatomic, strong) MPMusicPlayerController *musicPlayerController;

+ (AESharedAudioManager*) sharedInstance;

// AUDIO SESSION
- (void) startAppAudioSession;
- (BOOL) isAppAudioSessionRunning;
- (void) stopAppAudioSession;

// VOLUME
- (void) handleExternalVolumeChanged:(id)notification;
- (void) addVolumeChangeListener:(id<AEVolumeChangeListener>)volumeChangeListener;
- (void) removeVolumeChangeListener:(id<AEVolumeChangeListener>)volumeChangeListener;
- (void) setAppVolumePercent:(float)volumePercent;
- (float) getAppVolumePercent;

// TONE UNITS
- (AEToneUnit *) createNewToneUnit;
- (void) destroyOldToneUnit:(AEToneUnit*)toneUnit;

// NOISE LEVEL
- (NSNumber *) getAveragePower;
- (NSNumber *) getPeakPower;
- (void) startUpdates;
- (BOOL) isUpdating;
- (void) stopUpdates;

// IPOD CONTROLS
- (MPMusicPlaybackState) getIPodPlaybackState;
- (MPMediaItem *) getIPodNowPlayingItem;
- (void) playIPod;
- (void) pauseIPod;

@end
