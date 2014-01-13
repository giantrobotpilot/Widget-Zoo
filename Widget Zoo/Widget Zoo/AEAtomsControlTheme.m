//
//  AEAtomsControlTheme.m
//  Atoms User App
//
//  Created by Drew Christensen on 11/4/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEAtomsControlTheme.h"

@implementation AEAtomsControlTheme

- (UIColor *)actionAtomColor {
    return [UIColor colorWithRed:0 green:158.0f/255.0f blue:212.0f/255.0f alpha:1];
}

- (UIColor *)sensorAtomColor {
    return [UIColor colorWithRed:1.0f green:215.0f/255.0f blue:30.0f/255.0f alpha:1];
}

- (UIColor *)logicAtomColor {
    return [UIColor colorWithRed:95.0f/255.0f green:195.0f/255.0f blue:59.0f/255.0f alpha:1];
}

- (UIImage *)expandButtonImage {
    return [UIImage imageNamed:@"window_fullscreen_2-512"];
}

- (UIImage *)contractButtonImage {
    return [UIImage imageNamed:@"collapse_toggle_alt_basic-512"];
}

#pragma mark - Button

- (UIImage *)buttonBackground {
    return [UIImage imageNamed:@"Button Momentary Background"];
}

- (UIImage *)buttonUp {
    return [UIImage imageNamed:@"Button Up"];
}

- (UIImage *)buttonDown {
    return [UIImage imageNamed:@"Button Depressed"];
}

#pragma mark - Gamepad

- (UIImage *)dPadUp {
    return [UIImage imageNamed:@"Up-D-Pad"];
}

- (UIImage *)dPadUpRight {
    return [UIImage imageNamed:@"UpRight-D-Pad"];
}

- (UIImage *)dPadUpLeft {
    return [UIImage imageNamed:@"UpLeft-D-Pad"];
}

- (UIImage *)dPadDown {
    return [UIImage imageNamed:@"Down-D-Pad"];
}

- (UIImage *)dPadDownRight {
    return [UIImage imageNamed:@"DownRight-D-Pad"];
}

- (UIImage *)dPadDownLeft {
    return [UIImage imageNamed:@"DownLeft-D-Pad"];
}

- (UIImage *)dPadLeft {
    return [UIImage imageNamed:@"Left-D-Pad"];
}

- (UIImage *)dPadRight {
    return [UIImage imageNamed:@"Right-D-Pad"];
}

- (UIImage *)dPadNeutral {
    return [UIImage imageNamed:@"Normal-D-Pad"];
}

#pragma mark - Levelers

- (UIImage *)horizontalLevelBackground {
    return [UIImage imageNamed:@"Level Horizontal Background"];
}

- (UIImage *)horizontalLevelGuide {
    return [UIImage imageNamed:@"Level Horizontal Guide"];
}

- (UIImage *)levelBubble {
    return [UIImage imageNamed:@"Level Bubble"];
}

- (UIImage *)verticalLevelBackground {
    return [UIImage imageNamed:@"Level Vertical Background"];;
}

- (UIImage *)verticalLevelGuide {
    return [UIImage imageNamed:@"Level Vertical Guide"];
}

- (UIImage *)twoDLevelBase {
    return [UIImage imageNamed:@"Leveler-Base"];
}

- (UIImage *)twoDLevelGuide {
    return [UIImage imageNamed:@"Leveler-Marks"];
}

#pragma mark - Noise Meter

- (UIImage *)noiseMeterBars {
    return [UIImage imageNamed:@"Noise_Meter_Level"];
}

- (UIImage *)noiseMeterOverlay {
    return [UIImage imageNamed:@"noise_meter_overlay"];
}

- (UIColor *)noiseMeterMaskColor {
    return [UIColor colorWithRed:186.0f/255 green:202.0f/255 blue:207.0f/255 alpha:1];
}

#pragma mark - Slider

- (UIImage *)sliderBackgroundBottomSprung {
    return [UIImage imageNamed:@"Slider Bottom Sprung Background"];
}

- (UIImage *)sliderBackgroundCenterSprung {
    return [UIImage imageNamed:@"Slider Center Sprung Background"];
}

- (UIImage *)sliderBackgroundUnsprung {
    return [UIImage imageNamed:@"Slider Unsprung Background"];
}

- (UIImage *)sliderThumb {
    return [UIImage imageNamed:@"Slider Thumb"];
}

#pragma mark - Sprung Weight

- (UIColor *)springColor {
    return [UIColor colorWithRed:174.0f/255 green:182.0f/255 blue:184.0f/255 alpha:1];
}

- (UIImage *)sprungWeightBaseLeft {
    return [UIImage imageNamed:@"Left-MoS-Base"];
}

- (UIImage *)sprungWeightMassLeft {
    return [UIImage imageNamed:@"Mass-Left"];
}

- (UIImage *)sprungWeightBaseRight {
    return [UIImage imageNamed:@"Right-MoS-Base"];
}

- (UIImage *)sprungWeightMassRight {
    return [UIImage imageNamed:@"Mass-Right"];
}

- (UIImage *)sprungWeightBaseTop {
    return [UIImage imageNamed:@"Top-MoS-Base"];
}

- (UIImage *)sprungWeightMassTop {
    return [UIImage imageNamed:@"Mass-Top"];
}

- (UIImage *)sprungWeightBaseBottom {
    return [UIImage imageNamed:@"Bottom-MoS-Base"];
}

- (UIImage *)sprungWeightMassBottom {
    return [UIImage imageNamed:@"Mass-Bottom"];
}

#pragma mark - Toggle

- (UIImage *)toggleBase {
    return [UIImage imageNamed:@"Toggle-Base"];
}

- (UIImage *)toggleThumb {
    return [UIImage imageNamed:@"Toggle-Thumb"];
}

#pragma mark - Bar Meter

- (UIImage *)barMeterBars {
    return [UIImage imageNamed:@"bar_meter"];
}

- (UIColor *)barMeterMaskColor {
    return [UIColor colorWithRed:(CGFloat)186/255 green:(CGFloat)202/255 blue:(CGFloat)207/255 alpha:1];
}

- (UIImage *)barMeterOverlay {
    return [UIImage imageNamed:@"bar_meter_overlay"];
}

#pragma mark - Camera Input

- (UIImage *)cameraBase {
    return nil;
}

- (UIImage *)cameraFrontActive {
    return nil;
}

- (UIImage *)cameraFrontInactive {
    return nil;
}

- (UIImage *)cameraRearActive {
    return nil;
}

- (UIImage *)cameraRearInactive {
    return nil;
}

#pragma mark - Music Input

- (UIImage *)musicPause {
    return [UIImage imageNamed:@"pause_resized"];
}

- (UIImage *)musicPlay {
    return [UIImage imageNamed:@"play_resized"];
}

- (UIImage *)musicMeter {
    return [UIImage imageNamed:@"play-pause-meter-resized"];
}

- (UIImage *)musicOverlay {
    return [UIImage imageNamed:@"Play-pause-base"];
}

#pragma mark - Pitch Input

- (UIImage *)pitchNeedle {
    return [UIImage imageNamed:@"pitch_needle"];
}

- (UIImage *)pitchOverlay {
    return [UIImage imageNamed:@"pitch_overlay"];
}

#pragma mark - Dial Input

- (UIImage *)dialNeedle {
    return [UIImage imageNamed:@"dial_needle"];
}

- (UIImage *)dialOverlay {
    return [UIImage imageNamed:@"dial_overlay"];
}

#pragma mark - Volume Input

- (UIImage *)volumeMeter {
    return [UIImage imageNamed:@"Volume_meter_resize"];
}

- (UIColor *)volumeMaskColor {
    return [UIColor colorWithRed:186.0f/255 green:202.0f/255 blue:207.0f/255 alpha:1];
}

- (UIImage *)volumeOverlay {
    return [UIImage imageNamed:@"Volume_Base"];
}

@end
