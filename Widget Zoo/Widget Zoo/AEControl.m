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

@property (nonatomic, assign) CGFloat expandScale;

@end

@implementation AEControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _expandScale = 2;
        _portsRequired = 1;
        _differenceThreshold = 1;
        UInt32 zero = 0x00000000;
        _smartValue = [NSData dataWithBytes:&zero length:4];
        
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.editButton setImage:[[AEControlTheme currentTheme] expandButtonImage] forState:UIControlStateNormal];
        [self.editButton addTarget:self
                            action:@selector(editPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.editButton];
        [self.editButton setHidden:YES];
    }
    return self;
}

- (void)setExpansionDirection:(AEControlExpandDirection)direction {
    if (self.controlType == AEControlTypeInput) {
        [self.editButton setFrame:CGRectMake(self.bounds.size.width - 35, -5, 40, 40)];
    } else {
        [self.editButton setFrame:CGRectMake(self.bounds.size.width - 35, -5, 40, 40)];
        NSLog(@"editbutton frame: %@", [NSValue valueWithCGRect:self.editButton.frame]);
    }
    
    CGFloat xAnchorPoint = 0;
    CGFloat yAnchorPoint = 0;
    if (self.controlType == AEControlTypeInput) {
        self.expandScale = 3.3;
        yAnchorPoint = 1;
    } else {
        self.expandScale = 1.5;
    }
    if (direction == AEControlExpandDirectionLeft) {
        xAnchorPoint = 1;
    }
    self.layer.anchorPoint = CGPointMake(xAnchorPoint, yAnchorPoint);
    
    CGPoint position = self.layer.position;
    CGFloat xPosition;
    CGFloat yPosition;
    
    if (self.layer.anchorPoint.x == 0) {
        xPosition = position.x - self.bounds.size.width / 2;
    } else {
        xPosition = position.x + self.bounds.size.width / 2;
    }
    
    if (self.layer.anchorPoint.y == 0) {
        yPosition = position.y - self.bounds.size.height / 2;
    } else {
        yPosition = position.y + self.bounds.size.height / 2;
    }
    self.layer.position = CGPointMake(xPosition, yPosition);
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
    [self.delegate controlExpanded:self];
    [self.editButton setSelected:YES];
    [UIView animateWithDuration:0.25 animations:^{
        // Main View
        self.transform = CGAffineTransformMakeScale(self.expandScale, self.expandScale);
        
        // Edit button
        CGRect bFrame = self.editButton.frame;
        self.editButton.frame = CGRectMake(75, -15, bFrame.size.width, bFrame.size.height);
        [self.editButton setImage:[[AEControlTheme currentTheme] contractButtonImage] forState:UIControlStateNormal];
        self.editButton.transform = CGAffineTransformMakeScale(1.0f/self.expandScale, 1.0f/self.expandScale);
    } completion:^(BOOL finished) {
        self.configView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width * self.expandScale, self.bounds.size.height * self.expandScale)];
        self.configView.transform = CGAffineTransformMakeScale(1.0f/self.expandScale, 1.0f/self.expandScale);
        self.configView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.configView];
        [self bringSubviewToFront:self.editButton];
        if (completion != NULL) {
            completion();
        }
    }];
}

- (void)shrinkControlWithCompletion:(void (^)(void))completion {
    [self.delegate controlContracted:self];
    [self.configView removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        // Main View
        self.transform = CGAffineTransformMakeScale(1, 1);
        
        // Edit button
        self.editButton.transform = CGAffineTransformMakeScale(1, 1);
        self.editButton.frame = CGRectMake(self.bounds.size.width - 35, -5, 40, 40);
        [self.editButton setImage:[[AEControlTheme currentTheme] expandButtonImage] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        if (completion != NULL) {
            completion();
        }
    }];
}

@end
