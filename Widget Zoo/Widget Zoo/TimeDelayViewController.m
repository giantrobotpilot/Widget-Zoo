//
//  TimeDelayViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/16/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "TimeDelayViewController.h"
#import "AETimeDelayControl.h"

@interface TimeDelayViewController () <TimeDelayDelegate>

@property (nonatomic, strong) AETimeDelayControl *timeDelayControl;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation TimeDelayViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	_timeDelayControl = [[AETimeDelayControl alloc] initWithFrame:self.sensorRect4];
    [_timeDelayControl setEditable:YES];
    [_timeDelayControl setDelegate:self];
    [_timeDelayControl setTimeDelayDelegate:self];
    [_timeDelayControl setExpansionDirection:AEControlExpandDirectionRight];
    [_timeDelayControl addTarget:self
                          action:@selector(timeDelayValueChanged:)
                forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_timeDelayControl];
    [self.controlSet addObject:_timeDelayControl];
    
    _slider = [[UISlider alloc] initWithFrame:self.actionRect0];
    [_slider setUserInteractionEnabled:NO];
    [self.view addSubview:_slider];
    
    [self.portLabel4 setText:@"0"];
}

- (void)timeDelayValueChanged:(id)sender {
    UInt16 atomValue = self.timeDelayControl.atomValue;
    [self.slider setValue:(float)atomValue/UINT16_MAX animated:NO];
    [self.portLabel4 setText:[NSString stringWithFormat:@"%d", atomValue]];
}

- (void)timeDelaySetPressed:(AETimeDelayControl *)control {
    
}

@end
