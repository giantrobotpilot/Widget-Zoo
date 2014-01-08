//
//  AEControlTheme.h
//  Atoms User App
//
//  Created by Drew on 10/5/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AEAtomsControlTheme;
@class AEColorCodedControlTheme;

@protocol AEControlThemeDelegate <NSObject>

// Button
- (UIImage *)buttonBackground;
- (UIImage *)buttonUp;
- (UIImage *)buttonDown;

// Gamepad
- (UIImage *)dPadUp;
- (UIImage *)dPadUpRight;
- (UIImage *)dPadUpLeft;
- (UIImage *)dPadDown;
- (UIImage *)dPadDownRight;
- (UIImage *)dPadDownLeft;
- (UIImage *)dPadLeft;
- (UIImage *)dPadRight;
- (UIImage *)dPadNeutral;

// Levelers
- (UIImage *)horizontalLevelBackground;
- (UIImage *)horizontalLevelGuide;
- (UIImage *)levelBubble;
- (UIImage *)verticalLevelBackground;
- (UIImage *)verticalLevelGuide;
- (UIImage *)twoDLevelBase;
- (UIImage *)twoDLevelGuide;

// Noise Meter
- (UIImage *)noiseMeterBars;
- (UIImage *)noiseMeterOverlay;
- (UIColor *)noiseMeterMaskColor;

// Slider
- (UIImage *)sliderBackgroundBottomSprung;
- (UIImage *)sliderBackgroundCenterSprung;
- (UIImage *)sliderBackgroundUnsprung;
- (UIImage *)sliderThumb;

// Sprung Weight
- (UIColor *)springColor;
- (UIImage *)sprungWeightBaseLeft;
- (UIImage *)sprungWeightMassLeft;
- (UIImage *)sprungWeightBaseRight;
- (UIImage *)sprungWeightMassRight;
- (UIImage *)sprungWeightBaseTop;
- (UIImage *)sprungWeightMassTop;
- (UIImage *)sprungWeightBaseBottom;
- (UIImage *)sprungWeightMassBottom;

// Toggle
- (UIImage *)toggleBase;
- (UIImage *)toggleThumb;

// Bar Meter Input
- (UIImage *)barMeterBars;
- (UIColor *)barMeterMaskColor;
- (UIImage *)barMeterOverlay;

// Camera Input
- (UIImage *)cameraBase;
- (UIImage *)cameraFrontActive;
- (UIImage *)cameraFrontInactive;
- (UIImage *)cameraRearActive;
- (UIImage *)cameraRearInactive;

// Music Input
- (UIImage *)musicPause;
- (UIImage *)musicPlay;
- (UIImage *)musicMeter;
- (UIImage *)musicOverlay;

// Pitch Input
- (UIImage *)pitchNeedle;
- (UIImage *)pitchOverlay;

// Dial Input
- (UIImage *)dialNeedle;
- (UIImage *)dialOverlay;

// Volume Input
- (UIImage *)volumeMeter;
- (UIColor *)volumeMaskColor;
- (UIImage *)volumeOverlay;

@end

@interface AEControlTheme : NSObject

+ (id <AEControlThemeDelegate>)currentTheme;
+ (id <AEControlThemeDelegate>)atomsTheme;
+ (AEColorCodedControlTheme *)colorCodedTheme;

@end
