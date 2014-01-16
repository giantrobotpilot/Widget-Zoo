//
//  AEMusicInput.m
//  Custom Controls
//
//  Created by Drew on 10/11/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEMusicInput.h"

static const CGFloat kAEMusicPlayerPlayThreshold = 51.0f;

@interface AEMusicInput ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *buttonView;
@property (nonatomic, strong) UIImage *pauseImage;
@property (nonatomic, strong) UIImage *playImage;
@property (nonatomic, weak) MPMusicPlayerController *musicPlayerController;
@property (nonatomic, assign) CGFloat threshold;
@property (nonatomic, strong) UIButton *chooseSongButton;

@property (nonatomic, assign) BOOL playing;

@end

@implementation AEMusicInput

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.controlType = AEControlTypeInput;
        self.controlID = AEControlIDMusicInput;
        //self.clipsToBounds = YES;
        self.pauseImage = [[AEControlTheme currentTheme] musicPause];
        self.playImage = [[AEControlTheme currentTheme] musicPlay];
        
        _chooseSongButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_chooseSongButton setTitle:@"Choose\nSong" forState:UIControlStateNormal];
        [_chooseSongButton addTarget:self
                              action:@selector(chooseSongPressed:)
                    forControlEvents:UIControlEventTouchUpInside];
        [_chooseSongButton setBackgroundColor:[UIColor whiteColor]];
        
        _musicPlayerController = [MPMusicPlayerController applicationMusicPlayer];
        NSLog(@"now playing: %@", [[_musicPlayerController nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle]);
        
        UIImageView *meterView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.bounds.size.width - 10, self.bounds.size.height - 10)];
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
        
        self.editable = YES;
        [self bringSubviewToFront:self.editButton];
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
            NSLog(@"now playing: %@", [[self.musicPlayerController nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle]);
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

- (void)chooseSongPressed:(id)sender {
    [self.musicInputDelegate musicInputShouldShowMusicPicker];
}

- (void)expandControlWithCompletion:(void (^)(void))completion {
    [super expandControlWithCompletion:^{
        self.configView.frame = CGRectMake(0, 0, self.configView.frame.size.width, self.configView.frame.size.height);
        [self.chooseSongButton setFrame:CGRectMake(10, 120, 60, 60)];
        [self.configView addSubview:self.chooseSongButton];
    }];
}

- (void)shrinkControlWithCompletion:(void (^)(void))completion {
    [super shrinkControlWithCompletion:^{
        
    }];
}

- (void)setMedia:(MPMediaItemCollection *)mediaCollection {
    [self.musicPlayerController setQueueWithItemCollection:mediaCollection];
    NSLog(@"now playing: %@", [[self.musicPlayerController nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle]);
}

@end
