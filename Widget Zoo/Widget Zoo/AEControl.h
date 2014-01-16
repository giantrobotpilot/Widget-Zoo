//
//  AEControl.h
//  Custom Controls
//
//  Created by Drew on 9/30/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AEControlTheme.h"

@protocol AEEditableControlDelegate <NSObject>

- (void)controlExpanded:(id)control;
- (void)controlContracted:(id)control;

@end

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

typedef enum {
    AEControlExpandDirectionLeft,
    AEControlExpandDirectionRight
} AEControlExpandDirection;

@interface AEControl : UIControl

@property (nonatomic, weak) id<AEEditableControlDelegate> delegate;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *behavior;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, assign) NSInteger portsRequired;

@property (nonatomic, assign) BOOL editable;
@property (nonatomic, strong) UIView *configView;
@property (nonatomic, assign) BOOL controlEditMode;
@property (nonatomic, assign) BOOL expanded;
@property (nonatomic, strong) UIButton *editButton;

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
- (void)editPressed:(id)sender;
- (void)expandControlWithCompletion:(void (^)(void))completion;
- (void)shrinkControlWithCompletion:(void (^)(void))completion;
- (void)setExpansionDirection:(AEControlExpandDirection)direction;

@end