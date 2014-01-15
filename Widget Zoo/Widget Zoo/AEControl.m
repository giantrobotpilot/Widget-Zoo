//
//  AEControl.m
//  Custom Controls
//
//  Created by Drew on 9/30/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEControl.h"
#import "AEControlTheme.h"

@interface AEControl ()



@end


@implementation AEControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _portsRequired = 1;
        _differenceThreshold = 1;
        UInt32 zero = 0x00000000;
        _smartValue = [NSData dataWithBytes:&zero length:4];
        
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.editButton setFrame:CGRectMake(self.bounds.size.width - 20, 0, 20, 20)];
        [self.editButton setImage:[[AEControlTheme currentTheme] expandButtonImage] forState:UIControlStateNormal];
        [self.editButton addTarget:self
                            action:@selector(editPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.editButton];
        [self.editButton setHidden:YES];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %d", [AEControl stringForControlID:self.controlID], self.atomValue];
}

+ (NSString *)stringForControlID:(AEControlID)controlID
{
    switch (controlID) {
        case AEControlIDNoiseMeter:
            return @"AENoiseMeterID";
        case AEControlIDSliderUnsprung:
            return @"AESliderUnsprungID";
            break;
        case AEControlIDSliderCenterSprung:
            return @"AESliderCenterSprungID";
            break;
        case AEControlIDSliderBottomSprung:
            return @"AESliderBottomSprungID";
            break;
        case AEControlIDButton:
            return @"AEButtonMomentaryID";
            break;
        case AEControlIDGamepad:
            return @"AEGamepadID";
            break;
        case AEControlID2DLeveler:
            return @"AE2DLevelerID";
            break;
        case AEControlIDVerticalLeveler:
            return @"AEVerticalLevelerID";
            break;
        case AControlIDEHorizontalLeveler:
            return @"AEHorizontalLevelerID";
            break;
        case AEControlIDPitchShiftInput:
            return @"AEPitchShiftInputID";
            break;
        case AEControlIDDialInput:
            return @"AEDialInputID";
            break;
        case AEControlIDBarMeterInput:
            return @"AEBarMeterInputID";
            break;
        case AEControlIDMusicInput:
            return @"AEMusicInputID";
            break;
        case AEControlIDVolumeInput:
            return @"AEVolumeInputID";
            break;
        case AEControlIDCameraInput:
            return @"AECameraInputID";
            break;
        case AEControlIDToggleSwitch:
            return @"AEToggleSwitchID";
            break;
        case AEControlIDVerticalBottomSprungWeight:
            return @"AEVerticalBottomSprungWeightID";
            break;
        case AEControlIDVerticalTopSprungWeight:
            return @"AEVerticalTopSprungWeightID";
            break;
        case AEControlIDHorizontalLeftSprungWeight:
            return @"AEHorizontalLeftSprungWeightID";
            break;
        case AEControlIDHorizontalRightSprungWeight:
            return @"AEHorizontalRightSprungWeightID";
            break;
        default:
            return [NSString stringWithFormat:@"UNKNOWN CONTROL ID: %d", controlID];
            break;
    }
}

- (void)setControlEditMode:(BOOL)editing {
    if (self.editable) {
        if (editing) {
            [self.editButton setHidden:NO];
        }
        else {
            [self.editButton setHidden:YES];
        }
        _controlEditMode = editing;
    }
}

- (void)editPressed:(id)sender {
    if (self.expanded) {
        [self shrinkControlWithCompletion:NULL];
    }
    else {
        [self expandControlWithCompletion:NULL];
    }
    self.expanded = !self.expanded;
}

- (void)expandControlWithCompletion:(void (^)(void))completion {
    [self.editButton setSelected:YES];
    [UIView animateWithDuration:0.25 animations:^{
        // Main View
        self.transform = CGAffineTransformMakeScale(self.expandScale, self.expandScale);
        [self.editButton setImage:[[AEControlTheme currentTheme] contractButtonImage] forState:UIControlStateNormal];
        
        // config view
    } completion:^(BOOL finished) {
        self.configView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width * self.expandScale, self.bounds.size.height * self.expandScale)];
        self.configView.transform = CGAffineTransformMakeScale(1.0f/self.expandScale, 1.0f/self.expandScale);
        self.configView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.configView];
        [self bringSubviewToFront:self.editButton];
        completion();
    }];
}

- (void)shrinkControlWithCompletion:(void (^)(void))completion {
    [self.configView removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        // Main View
        self.transform = CGAffineTransformMakeScale(1, 1);
        [self.editButton setImage:[[AEControlTheme currentTheme] expandButtonImage] forState:UIControlStateNormal];
        completion();
    }];
}

@end
