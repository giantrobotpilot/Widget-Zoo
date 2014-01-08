//
//  AEControl.m
//  Custom Controls
//
//  Created by Drew on 9/30/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEControl.h"
#import "Flurry.h"

@implementation AEControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _portsRequired = 1;
        _differenceThreshold = 1;
        UInt32 zero = 0x00000000;
        _smartValue = [NSData dataWithBytes:&zero length:4];
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
            [Flurry logError:@"Unknown controlID in [AEControlLibrary -stringForControlID:]" message:@"" error:nil];
            return [NSString stringWithFormat:@"UNKNOWN CONTROL ID: %d", controlID];
            break;
    }
}

@end
