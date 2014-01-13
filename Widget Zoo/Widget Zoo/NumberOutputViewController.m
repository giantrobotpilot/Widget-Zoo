//
//  NumberOutputViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/9/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "NumberOutputViewController.h"
#import "AENumericalDisplay.h"

@interface NumberOutputViewController ()

@property (nonatomic, strong) AENumericalDisplay *numberDisplay;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation NumberOutputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.numberDisplay = [[AENumericalDisplay alloc] initWithFrame:self.actionRect0];
    [self.view addSubview:self.numberDisplay];
    
    self.slider = [[UISlider alloc] initWithFrame:self.sensorRect4];
    [self.slider addTarget:self
                    action:@selector(sliderValueChanged:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    self.portLabel0.text = @"0";
}

- (void)sliderValueChanged:(id)sender {
    UInt16 atomValue = self.slider.value * UINT16_MAX;
    [self.numberDisplay setAtomValue:atomValue];
    self.portLabel0.text = [NSString stringWithFormat:@"%d", atomValue];
}

- (void)configPressed:(id)sender {
    [super configPressed:sender];
    [self.numberDisplay setControlEditMode:self.dashboardEditMode];
}

@end
