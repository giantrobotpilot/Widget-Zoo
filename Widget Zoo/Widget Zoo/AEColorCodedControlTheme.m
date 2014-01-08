//
//  AEColorCodedControlTheme.m
//  Atoms User App
//
//  Created by Drew Christensen on 11/4/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEColorCodedControlTheme.h"

@implementation AEColorCodedControlTheme

#pragma mark - Button

- (UIImage *)buttonBackground {
    return [UIImage imageNamed:@"Button_Base_yellow"];
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
    return [UIImage imageNamed:@"level_horizontal_base_yellow"];
}

- (UIImage *)horizontalLevelGuide {
    return [UIImage imageNamed:@"Level Horizontal Guide"];
}

- (UIImage *)levelBubble {
    return [UIImage imageNamed:@"level_bubble_yellow"];
}

- (UIImage *)verticalLevelBackground {
    return [UIImage imageNamed:@"level_vertical_base_yellow"];
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
    return [UIImage imageNamed:@"NL_Meter__yellow"];
}

- (UIImage *)noiseMeterOverlay {
    return [UIImage imageNamed:@"NL_Base_yellow"];
}

- (UIColor *)noiseMeterMaskColor {
    return [UIColor colorWithRed:186.0f/255 green:202.0f/255 blue:207.0f/255 alpha:1];
}

#pragma mark - Slider

- (UIImage *)sliderBackgroundBottomSprung {
    return [UIImage imageNamed:@"slider_bottom_base_yellow"];
}

- (UIImage *)sliderBackgroundCenterSprung {
    return [UIImage imageNamed:@"slider_center_base_yellow"];
}

- (UIImage *)sliderBackgroundUnsprung {
    return [UIImage imageNamed:@"slider_unsprung_base_yellow"];
}

- (UIImage *)sliderThumb {
    return [UIImage imageNamed:@"Slider Thumb"];
}

#pragma mark - Sprung Weight

- (UIColor *)springColor {
    return [UIColor colorWithRed:174.0f/255 green:182.0f/255 blue:184.0f/255 alpha:1];
}

- (UIImage *)sprungWeightBaseLeft {
    return [UIImage imageNamed:@"mos_base_left_yellow"];
}

- (UIImage *)sprungWeightMassLeft {
    return [UIImage imageNamed:@"mas_left_yellow"];
}

- (UIImage *)sprungWeightBaseRight {
    return [UIImage imageNamed:@"mos_base_right_yellow"];
}

- (UIImage *)sprungWeightMassRight {
    return [UIImage imageNamed:@"mass_right_yellow"];
}

- (UIImage *)sprungWeightBaseTop {
    return [UIImage imageNamed:@"mos_base_top_yellow"];
}

- (UIImage *)sprungWeightMassTop {
    return [UIImage imageNamed:@"mass_top_yellow"];
}

- (UIImage *)sprungWeightBaseBottom {
    return [UIImage imageNamed:@"mos_base_bottom_yellow"];
}

- (UIImage *)sprungWeightMassBottom {
    return [UIImage imageNamed:@"mass_bottom_yellow"];
}

#pragma mark - Toggle

- (UIImage *)toggleBase {
    return [UIImage imageNamed:@"toggle_base_yellow"];
}

- (UIImage *)toggleThumb {
    return [UIImage imageNamed:@"toggle_thumb_yellow"];
}

#pragma mark - Bar Meter

- (UIImage *)barMeterBars {
    return [UIImage imageNamed:@"bar_meter_blue"];
}

- (UIColor *)barMeterMaskColor {
    return [UIColor colorWithRed:(CGFloat)186/255 green:(CGFloat)202/255 blue:(CGFloat)207/255 alpha:1];
}

- (UIImage *)barMeterOverlay {
    return [UIImage imageNamed:@"bar_meter_overlay_blue"];
}

#pragma mark - Camera Input

- (UIImage *)cameraBase {
    return [UIImage imageNamed:@"camera_base"];
}

- (UIImage *)cameraFrontActive {
    return [UIImage imageNamed:@"camera_front_active_sized"];
}

- (UIImage *)cameraFrontInactive {
    return [UIImage imageNamed:@"camera_front_inactive_sized"];
}

- (UIImage *)cameraRearActive {
    return [UIImage imageNamed:@"camera_rear_active_sized"];
}

- (UIImage *)cameraRearInactive {
    return [UIImage imageNamed:@"camera_rear_inactive_sized"];
}

#pragma mark - Music Input

- (UIImage *)musicPause {
    return [UIImage imageNamed:@"pause_resized"];
}

- (UIImage *)musicPlay {
    return [UIImage imageNamed:@"play_resized"];
}

- (UIImage *)musicMeter {
    return [UIImage imageNamed:@"music_meter_blue"];
}

- (UIImage *)musicOverlay {
    return [UIImage imageNamed:@"music_overlay_blue"];
}

#pragma mark - Pitch Input

- (UIImage *)pitchNeedle {
    return [UIImage imageNamed:@"pitch_needle_blue"];
}

- (UIImage *)pitchOverlay {
    return [UIImage imageNamed:@"pitch_overlay_blue"];
}

#pragma mark - Dial Input

- (UIImage *)dialNeedle {
    return [UIImage imageNamed:@"dial_needle_blue"];
}

- (UIImage *)dialOverlay {
    return [UIImage imageNamed:@"dial_overlay_blue"];
}

#pragma mark - Volume Input

- (UIImage *)volumeMeter {
    return [UIImage imageNamed:@"Volume_Fill_blue"];
}

- (UIColor *)volumeMaskColor {
    return [UIColor colorWithRed:186.0f/255 green:202.0f/255 blue:207.0f/255 alpha:1];
}

- (UIImage *)volumeOverlay {
    return [UIImage imageNamed:@"Volume_Base_blue"];
}

@end
