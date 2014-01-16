//
//  AETimeDelayControl.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/16/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "AETimeDelayControl.h"
#import "AEControlTheme.h"

@interface AETimeDelayControl ()

@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) UILabel *buttonLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSDate *fireDate;

@end

@implementation AETimeDelayControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.controlType = AEControlTypeOutput;
        self.editable = YES;
        CALayer *backgroundLayer = [CALayer layer];
        [backgroundLayer setFrame:self.bounds];
        [backgroundLayer setCornerRadius:8];
        [backgroundLayer setBackgroundColor:[[[AEControlTheme currentTheme] controlAtomColor] CGColor]];
        [self.layer addSublayer:backgroundLayer];
        
        _timeInterval = 12.0;
        _controlState = AETimeDelayControlStateStopped;
        
        // Button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat buttonSize = CGRectGetWidth(self.bounds) * 0.67;
        CGFloat x = self.bounds.size.width / 2 - buttonSize / 2;
        CGFloat y = self.bounds.size.height / 1.4 - buttonSize / 2;
        button.frame = CGRectMake(x, y, buttonSize, buttonSize);
        [button setImage:[[AEControlTheme currentTheme] buttonUp] forState:UIControlStateNormal];
        [button setImage:[[AEControlTheme currentTheme] buttonDown] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.button = button;
        
        // Button Label
        CGFloat labelY = self.bounds.size.height / 2.6;
        CGFloat labelHeight = self.bounds.size.height / 8;
        _buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, self.bounds.size.width, labelHeight)];
        [_buttonLabel setFont:[UIFont fontWithName:@"National-Book" size:15]];
        [_buttonLabel setText:@"Start"];
        [_buttonLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_buttonLabel];
        
        // Timer Label
        labelY = self.bounds.size.height / 18;
        labelHeight = self.bounds.size.height / 3;
        _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, self.frame.size.width, labelHeight)];
        [_timerLabel setFont:[UIFont fontWithName:@"CourierNewPS-BoldMT" size:30]];
        [_timerLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_timerLabel];
        
        [self configureTimeLabelWithInterval:_timeInterval];
        [self bringSubviewToFront:self.editButton];
    }
    return self;
}

- (void)configureTimeLabelWithInterval:(NSTimeInterval)timeInterval {
    NSInteger minutes = timeInterval / 60;
    NSInteger seconds = timeInterval - (minutes * 60);
    NSString *minuteString;
    NSString *secondString;
    if (minutes < 10) {
        minuteString = [NSString stringWithFormat:@"0%d", minutes];
    } else {
        minuteString = [NSString stringWithFormat:@"%d", minutes];
    }
    if (seconds < 10) {
        secondString = [NSString stringWithFormat:@"0%d", seconds];
    } else {
        secondString = [NSString stringWithFormat:@"%d", seconds];
    }

    [self.timerLabel setText:[NSString stringWithFormat:@"%@:%@", minuteString, secondString]];
}

- (NSString *)stateDetail {
    switch (self.controlState) {
        case AETimeDelayControlStateStopped:
            return @"AETimeDelayControlStateStopped";
        case AETimeDelayControlStateFiring:
            return @"AETimeDelayControlStateFiring";
        case AETimeDelayControlStateTiming:
            return @"AETimeDelayControlStateTiming";
        default:
            break;
    }
}

- (void)setControlState:(AETimeDelayControlState)controlState {
    _controlState = controlState;
    NSLog(@"%@", [self stateDetail]);
    switch (controlState) {
        case AETimeDelayControlStateStopped:
            [self.buttonLabel setText:@"Start"];
            break;
        case AETimeDelayControlStateTiming:
            [self.buttonLabel setText:@"Stop"];
            break;
            
        case AETimeDelayControlStateFiring:
            [self.buttonLabel setText:@"Reset"];
            break;
        default:
            break;
    }
}

- (void)buttonPressed:(id)sender {
    switch (self.controlState) {
        case AETimeDelayControlStateStopped:
            [self setControlState:AETimeDelayControlStateTiming];
            self.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.timeInterval];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                          target:self
                                                        selector:@selector(updateTimer:)
                                                        userInfo:nil
                                                         repeats:YES];
            
            break;
        case AETimeDelayControlStateTiming:
            [self.timer invalidate];
            [self setControlState:AETimeDelayControlStateStopped];
            [self configureTimeLabelWithInterval:self.timeInterval];
            break;
            
        case AETimeDelayControlStateFiring:
            [self setControlState:AETimeDelayControlStateStopped];
            [self configureTimeLabelWithInterval:self.timeInterval];
            self.atomValue = 0;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            break;
        default:
            break;
    }
}

- (void)updateTimer:(NSTimer *)timer {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.fireDate];
    if (timeInterval > -0.5) {
        [self fireTimer];
        [self.timer invalidate];
        [self setControlState:AETimeDelayControlStateFiring];
        
    }
    [self configureTimeLabelWithInterval:fabs(timeInterval)];
}

- (void)fireTimer {
    self.atomValue = UINT16_MAX;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
