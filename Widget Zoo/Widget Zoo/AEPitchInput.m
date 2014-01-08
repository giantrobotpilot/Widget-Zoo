//
//  AEPitchInput.m
//  Custom Controls
//
//  Created by Drew on 10/9/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEPitchInput.h"
#import "AEAppDelegate.h"
#import "AESharedAudioManager.h"
#import "AEToneUnit.h"

CGFloat pitch_needleOriginX = 94;
CGFloat pitch_needleOriginY = 37;
CGFloat pitch_needleWidth = 13;
CGFloat pitch_needleHeight = 292;
CGFloat pitch_baseWidth = 200;
CGFloat pitch_baseHeight = 117;

@interface AEPitchInput ()

@property (nonatomic, strong) CALayer *needle;
@property (nonatomic, strong) AEToneUnit *toneUnit;

@end


@implementation AEPitchInput

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, kSingleWidgetWidth, kSingleInputHeight)];
    if (self) {
        self.controlType = AEControlTypeInput;
        self.controlID = AEControlIDPitchShiftInput;
        self.clipsToBounds = YES;
        
        self.toneUnit = [[AESharedAudioManager sharedInstance] createNewToneUnit];
        [self setAmplitudePercent:1];
        [self.toneUnit startPlaying];
        
        UIView *background = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width * .02, self.bounds.size.height * .1, self.bounds.size.width * .98, self.bounds.size.height * .8)];
        background.backgroundColor = [UIColor whiteColor];
        [self addSubview:background];
        
        CGRect needleFrame = CGRectMake(0.471 * CGRectGetWidth(self.bounds),
                                        0.316 * CGRectGetHeight(self.bounds),
                                        0.065 * CGRectGetWidth(self.bounds),
                                        2.5 * CGRectGetHeight(self.bounds));
        self.needle = [CALayer layer];
        self.needle.frame = needleFrame;
        self.needle.anchorPoint = CGPointMake(0.5, 0.5);
        self.needle.contents = (id)[[[AEControlTheme currentTheme] pitchNeedle] CGImage];
        [self.layer addSublayer:self.needle];
        
        UIImageView *base = [[UIImageView alloc] initWithFrame:self.bounds];
        base.image = [[AEControlTheme currentTheme] pitchOverlay];
        [self addSubview:base];
    }
    return self;
}

- (void)setAtomValue:(UInt16)atomValue {
    CGFloat minAngle = -0.48;
    CGFloat maxAngle = 0.466;
    CGFloat angle = (maxAngle - minAngle) * (CGFloat)atomValue / UINT16_MAX + minAngle;
    [self.needle setTransform:CATransform3DMakeRotation(angle, 0, 0, 1)];
    [self setFrequencyATOMTwoByteValue:atomValue];
}

- (void)setEnabled:(BOOL)enabled
{
    if (enabled) {
        [self.toneUnit startPlaying];
    }
    else {
        [self.toneUnit stopPlaying];
    }
}

- (void)dealloc {
    [self.toneUnit stopPlaying];
}

- (void)removeFromSuperview {
    [self.toneUnit stopPlaying];
    [super removeFromSuperview];
}

#pragma mark - Tone

- (void) setFrequencyATOMTwoByteValue:(UInt16)value{
	if(value > UINT16_MAX){
        value = UINT16_MAX;
    }
	[self setFrequencyPercent:((CGFloat)value)/UINT16_MAX];
}

- (void) setAmplitudeATOMTwoByteValue:(UInt16)value{
	if(value > 32767.0){ value = 32767.0; }
	[self setAmplitudePercent:((float)value)/32767.0];
}

- (void) setFrequencyPercent:(float)inFrequencyPercent{
	if(inFrequencyPercent > 1) {
        inFrequencyPercent = 1;
    }
	else if (inFrequencyPercent < 0) {
        inFrequencyPercent = 0;
    }
	[self.toneUnit setFrequencyPercent:inFrequencyPercent];
}

- (float) amplitudeAbsolute{
	return [self.toneUnit amplitudeAbsolute];
}

- (float) amplitudePercent{
	return [self.toneUnit amplitudePercent];
}

- (void) setAmplitudePercent:(float)inAmplitudePercent{
	if (inAmplitudePercent > 1) {
        inAmplitudePercent = 1;
    }
	else if (inAmplitudePercent < 0) {
        inAmplitudePercent = 0;
    }
	[self.toneUnit setAmplitudePercent:inAmplitudePercent];
}

@end
