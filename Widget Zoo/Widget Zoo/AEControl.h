//
//  AEControl.h
//  Custom Controls
//
//  Created by Drew on 9/30/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AEControlTheme.h"

static const CGFloat kSingleWidgetWidth = 100;
static const CGFloat kSingleWidgetHeight = 102;
static const CGFloat kSingleInputHeight = 59;
static const CGFloat kDoubleWidgetWidth = 200;
static const CGFloat kDoubleWidgetHeight = 160;

typedef enum {
    AEControlIDSliderUnsprung = 1,
    AEControlIDSliderCenterSprung,
    AEControlIDSliderTopSprung,
    AEControlIDSliderBottomSprung,
    AEControlIDButton,
    AEControlIDGamepad,
    AEControlIDVerticalLeveler,
    AControlIDEHorizontalLeveler,
    AEControlID2DLeveler,
    AEControlIDNoiseMeter,
    AEControlIDPitchShiftInput,
    AEControlIDDialInput,
    AEControlIDBarMeterInput,
    AEControlIDMusicInput,
    AEControlIDCameraInput,
    AEControlIDVolumeInput,
    AEControlIDToggleSwitch,
    AEControlIDVerticalTopSprungWeight,
    AEControlIDVerticalBottomSprungWeight,
    AEControlIDHorizontalLeftSprungWeight,
    AEControlIDHorizontalRightSprungWeight,
    AEControlIDInverter,
    AEControlIDFlipFlop,
    AEControlIDThreshold,
    AEControlIDSplitter,
    AEControlIDPassthrough,
    AEControlIDPassthroughFlipFlop,
    AEControlIDPassthroughInverter,
    AEControlIDPassthroughThreshold
} AEControlID;

typedef enum {
    AEControlTypeOutput,
    AEControlTypeSmartOutput,
    AEControlTypeInput,
    AEControlTypeLogic
} AEControlType;

@interface AEControl : UIControl

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *behavior;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, assign) NSInteger portsRequired;

// Control Values
@property (nonatomic, assign) UInt16 atomValue;
@property (nonatomic, assign) UInt16 lastAtomValue;
@property (nonatomic, assign) NSInteger differenceThreshold;
@property (nonatomic, strong) NSData *smartValue;

@property (nonatomic, assign) NSInteger portIndex;
@property (nonatomic, assign) AEControlID controlID;
@property (nonatomic, assign) AEControlType controlType;

// Output rate
@property (nonatomic, assign) BOOL throttleOutput;
@property (nonatomic, strong) NSTimer *throttledOutputTimer;

+ (NSString *)stringForControlID:(AEControlID)controlID;

@end