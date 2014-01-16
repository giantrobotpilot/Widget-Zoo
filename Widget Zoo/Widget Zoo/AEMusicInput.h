//
//  AEMusicInput.h
//  Custom Controls
//
//  Created by Drew on 10/11/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEControl.h"
#import <MediaPlayer/MediaPlayer.h>

@protocol MusicInputDelegate <NSObject>

- (void)musicInputShouldShowMusicPicker;

@end

@interface AEMusicInput : AEControl

@property (nonatomic, weak) id<MusicInputDelegate> musicInputDelegate;

- (void)setMedia:(MPMediaItemCollection *)mediaCollection;

@end
