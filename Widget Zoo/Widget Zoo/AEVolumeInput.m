//
//  AEVolumeInput.m
//  Custom Controls
//
//  Created by Drew on 10/11/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEVolumeInput.h"
#import "AESharedAudioManager.h"
#import "AEVolumeChangeListener.h"

@interface AEVolumeInput () <AEVolumeChangeListener>

@property (nonatomic, strong) UIView *maskView;

@end

@implementation AEVolumeInput

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.controlID = AEControlIDVolumeInput;
        self.controlType = AEControlTypeInput;
        self.clipsToBounds = YES;
        UIImageView *meter = [[UIImageView alloc] initWithFrame:self.bounds];
        meter.image = [[AEControlTheme currentTheme] volumeMeter];
        [self addSubview:meter];
        
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0.09 * CGRectGetWidth(self.bounds), 0.10 * CGRectGetHeight(self.bounds), 0.81 * CGRectGetWidth(self.bounds), 0.41 * CGRectGetHeight(self.bounds))];
        self.maskView.backgroundColor = [[AEControlTheme currentTheme] volumeMaskColor];
        [self addSubview:self.maskView];
        
        UIImageView *overlay = [[UIImageView alloc] initWithFrame:self.bounds];
        overlay.image = [[AEControlTheme currentTheme] volumeOverlay];
        [self addSubview:overlay];
        
        [self updateAppVolumeWithPercent:[[AESharedAudioManager sharedInstance] getAppVolumePercent] andSetAppVolume:NO];
    }
    return self;
}

- (void) updateAppVolumeWithPercent:(float)inPercent andSetAppVolume:(BOOL)setAppVolume {
	if(inPercent > 1) {
        inPercent = 1;
    }
	else if (inPercent < 0) {
        inPercent = 0;
    }
    
    if(setAppVolume){
        [[AESharedAudioManager sharedInstance] setAppVolumePercent:inPercent];
    }
}

- (void)updateView {
    CGFloat value = (CGFloat)self.atomValue / UINT16_MAX * self.maskView.bounds.size.width + 0.09 * CGRectGetWidth(self.bounds);
    CGRect maskRect = self.maskView.frame;
    [self.maskView setFrame:CGRectMake(value, maskRect.origin.y, maskRect.size.width, maskRect.size.height)];
}

- (void) appVolumeChangedExternallyToPercent:(float)volumePercent {
	//[self updateAppVolumeWithPercent:volumePercent andSetAppVolume:NO];
}

- (void)setAtomValue:(UInt16)atomValue {
    super.atomValue = atomValue;
    CGFloat value = (CGFloat)atomValue / UINT16_MAX;
    if (abs(atomValue - self.lastAtomValue) > self.differenceThreshold) {
        [self updateAppVolumeWithPercent:value andSetAppVolume:YES];
        MPVolumeSettingsAlertHide();
        self.lastAtomValue = atomValue;
    }
    [self updateView];
}

@end
