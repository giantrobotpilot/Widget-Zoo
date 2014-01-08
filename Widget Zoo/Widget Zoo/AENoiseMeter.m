//
//  AENoiseMeter.m
//  Atoms User App
//
//  Created by Drew on 10/6/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AENoiseMeter.h"
#import "AESharedAudioManager.h"

@interface AENoiseMeter ()

@property (nonatomic, strong) UIImageView *levelMask;

@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, strong) CABasicAnimation *maskAnimation;
@property (nonatomic, strong) NSTimer *noiseLevelSampleTimer;

@end

const CGFloat AE_NOISE_OUTPUT_METER_SOUND_LEVEL_SAMPLE_PERIOD_SECONDS = 0.05;

@implementation AENoiseMeter

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, kSingleWidgetWidth, kDoubleWidgetHeight)];
    if (self) {
        self.clipsToBounds = YES;
        self.controlType = AEControlTypeOutput;
        self.controlID = AEControlIDNoiseMeter;
        self.minY = CGRectGetHeight(self.bounds) * 0.0625;
        self.maxY = CGRectGetHeight(self.bounds) * 0.925;
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.bounds.origin.y, self.bounds.size.width - 20, self.bounds.size.height)];
        background.image = [[AEControlTheme currentTheme] noiseMeterBars];
        [self addSubview:background];
        
        self.maskLayer = [CALayer layer];
        self.maskLayer.frame = CGRectMake(0, self.minY, self.bounds.size.width, self.maxY - self.minY);
        self.maskLayer.backgroundColor = [[[AEControlTheme currentTheme] noiseMeterMaskColor] CGColor];
        self.maskLayer.anchorPoint = CGPointMake(0, 1);
        self.maskLayer.position = CGPointMake(0, self.maxY);
        [self.layer addSublayer:self.maskLayer];
        
        UIImageView *meter = [[UIImageView alloc] initWithFrame:self.bounds];
        meter.image = [[AEControlTheme currentTheme] noiseMeterOverlay];
        [self addSubview:meter];
        
        [self setNoiseLevelSampleTimer:[NSTimer scheduledTimerWithTimeInterval:AE_NOISE_OUTPUT_METER_SOUND_LEVEL_SAMPLE_PERIOD_SECONDS
                                                                        target:self
                                                                      selector:@selector(periodicNoiseLevelUpdate)
                                                                      userInfo:nil
                                                                       repeats:YES]];
        self.differenceThreshold = 400;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    AESharedAudioManager *audioManager = [AESharedAudioManager sharedInstance];
    [audioManager startUpdates];
}

- (void)sendAtomValue:(NSTimer *)timer {
    if ( abs(self.atomValue - self.lastAtomValue) > self.differenceThreshold) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        self.lastAtomValue = self.atomValue;
    }
}

- (void)cleanup {
    [self.noiseLevelSampleTimer invalidate];
    [self.throttledOutputTimer invalidate];
    [[AESharedAudioManager sharedInstance] stopUpdates];
}

//- (void)dealloc {
//    [self cleanup];
//}

- (void)removeFromSuperview {
    [self cleanup];
    [super removeFromSuperview];
}

- (void) periodicNoiseLevelUpdate{
    if (self.enabled) {
        // GET LATEST SOUND LEVEL FROM HARDWARE
        AESharedAudioManager *audioManager = [AESharedAudioManager sharedInstance];
        if (audioManager) {
            CGFloat currentSoundLevel = [[audioManager getAveragePower] floatValue];
            
            if (currentSoundLevel < -30.0) {
                currentSoundLevel = -80.0f;
            }
            float newPercent = pow(10, (0.05 * currentSoundLevel));
            self.atomValue = newPercent * UINT16_MAX;
            CGFloat span = self.maxY - self.minY;
            self.maskLayer.position = CGPointMake(0, self.maxY - (newPercent * span));
        }
        else {
            NSLog(@"ERROR -  audio manager is nil");
        }
        if (self.enabled) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

@end
