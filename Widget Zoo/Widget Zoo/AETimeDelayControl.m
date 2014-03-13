//
//  AETimeDelayControl.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/16/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "AETimeDelayControl.h"
#import "AEControlTheme.h"

@interface AETimeDelayControl () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) UILabel *buttonLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSDate *fireDate;
@property (nonatomic, strong) UIPickerView *timePicker;

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
        
        _timeInterval = 5.0;
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
        [_buttonLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_buttonLabel];
        
        // Timer Label
        labelY = self.bounds.size.height / 12;
        labelHeight = self.bounds.size.height / 3;
        _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, self.frame.size.width, labelHeight)];
        [_timerLabel setFont:[UIFont fontWithName:@"CourierNewPS-BoldMT" size:30]];
        [_timerLabel setTextAlignment:NSTextAlignmentCenter];
        [_timerLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_timerLabel];
        
        [self configureTimeLabelWithInterval:_timeInterval];
        [self bringSubviewToFront:self.editButton];
    }
    return self;
}

- (void)setTimePressed:(id)sender {
    [self.timeDelayDelegate timeDelaySetPressed:self];
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
    if (self.controlEditMode) {
        [self setControlEditMode:NO];
    }
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

- (void)timerSetPressed:(id)sender {
    NSInteger sec = [self.timePicker selectedRowInComponent:1];
    NSInteger min = [self.timePicker selectedRowInComponent:0];
    self.timeInterval = (NSTimeInterval)min * 60 + sec;
    [self configureTimeLabelWithInterval:self.timeInterval];
    [self shrinkControlWithCompletion:NULL];
}

#pragma mark - EditMode

- (void)expandControlWithCompletion:(void (^)(void))completion {
    [super expandControlWithCompletion:^{
        [self.timerLabel setHidden:YES];
        
        [self.configView.layer setCornerRadius:8];
        [self.configView.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
        [self.configView setAlpha:0.90];
        
        // Time Picker
        CGRect bounds = self.configView.bounds;
        CGFloat width = bounds.size.width * 0.8;
        self.timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 20, width, bounds.size.height / 8)];
        [self.timePicker selectRow:6 inComponent:0 animated:YES];
        [self.timePicker setDelegate:self];
        [self.timePicker setDataSource:self];
        [self.configView addSubview:self.timePicker];
        
        UILabel *min = [[UILabel alloc] initWithFrame:CGRectMake(47, 67, 30, 30)];
        [min setText:@"min"];
        [self.timePicker addSubview:min];
        
        UILabel *sec = [[UILabel alloc] initWithFrame:CGRectMake(110, 67, 30, 30)];
        [sec setText:@"sec"];
        [self.timePicker addSubview:sec];
        
        // Set Button
        UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [timeButton setFrame:CGRectMake(0, bounds.size.height / 1.3, bounds.size.width, 44)];
        [timeButton setTitle:@"Set" forState:UIControlStateNormal];
        [self.configView addSubview:timeButton];
        [timeButton addTarget:self
                       action:@selector(timerSetPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)shrinkControlWithCompletion:(void (^)(void))completion {
    [super shrinkControlWithCompletion:^{
        [self.timePicker removeFromSuperview];
        [self.timerLabel setHidden:NO];
    }];
}

#pragma mark - Picker View data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 100;
    } else {
        return 60;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [NSString stringWithFormat:@"%d", row];
    } else {
        return [NSString stringWithFormat:@"%d   ", row];
    }
}

@end
