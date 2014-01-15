//
//  AEMusicInput.m
//  Custom Controls
//
//  Created by Drew on 10/11/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEMusicInput.h"
#import "AESharedAudioManager.h"
#import <MediaPlayer/MediaPlayer.h>

static const CGFloat kAEMusicPlayerPlayThreshold = 51.0f;

@interface AEMusicInput ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *buttonView;
@property (nonatomic, strong) UIImage *pauseImage;
@property (nonatomic, strong) UIImage *playImage;
@property (nonatomic, weak) MPMusicPlayerController *musicPlayerController;
@property (nonatomic, assign) CGFloat threshold;

@property (nonatomic, assign) BOOL playing;

@end

@implementation AEMusicInput

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.controlType = AEControlTypeInput;
        self.controlID = AEControlIDMusicInput;
        self.clipsToBounds = YES;
        self.pauseImage = [[AEControlTheme currentTheme] musicPause];
        self.playImage = [[AEControlTheme currentTheme] musicPlay];
        
        _musicPlayerController = [[AESharedAudioManager sharedInstance] musicPlayerController];
        
        UIImageView *meterView = [[UIImageView alloc] initWithFrame:self.bounds];
        meterView.image = [[AEControlTheme currentTheme] musicMeter];
        [self addSubview:meterView];
        
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0.095 * CGRectGetWidth(self.bounds),
                                                                 0.16 * CGRectGetHeight(self.bounds),
                                                                 0.805 * CGRectGetWidth(self.bounds),
                                                                 0.248 * CGRectGetHeight(self.bounds))];
        self.maskView.backgroundColor = [UIColor colorWithRed:186.0f/255 green:202.0f/255 blue:207.0f/255 alpha:1];
        [self addSubview:self.maskView];
        
        UIImageView *overlay = [[UIImageView alloc] initWithFrame:self.bounds];
        overlay.image = [[AEControlTheme currentTheme] musicOverlay];
        [self addSubview:overlay];
        
        self.buttonView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.buttonView.image = self.pauseImage;
        [self addSubview:self.buttonView];
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    if (enabled) {
        CGFloat value = (CGFloat)self.atomValue / UINT16_MAX * self.maskView.bounds.size.width + 0.095 * CGRectGetWidth(self.bounds);
        NSLog(@"value: %f, threshold: %f", value, kAEMusicPlayerPlayThreshold);
        
        if (value >= kAEMusicPlayerPlayThreshold) {
            [self.musicPlayerController play];
        }
    }
    else {
        [self.musicPlayerController pause];
    }
}

- (void)setAtomValue:(UInt16)atomValue {
    [super setAtomValue:atomValue];
    if ( (CGFloat)atomValue / UINT16_MAX > .5) {
        self.buttonView.image = self.playImage;
    } else {
        self.buttonView.image = self.pauseImage;
    }
    CGFloat value = (CGFloat)atomValue / UINT16_MAX * self.maskView.bounds.size.width + 0.095 * CGRectGetWidth(self.bounds);
    CGRect maskRect = self.maskView.frame;
    [self.maskView setFrame:CGRectMake(value, maskRect.origin.y, maskRect.size.width, maskRect.size.height)];
    
    if (value >= kAEMusicPlayerPlayThreshold) {
        if (!self.playing) {
            [self.musicPlayerController play];
            self.playing = YES;
        }
    }
    else {
        if (self.playing) {
            [self.musicPlayerController pause];
            self.playing = NO;
        }
    }
}

@end
