//
//  BarMeterViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/8/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "BarMeterViewController.h"
#import "AEBarMeterInput.h"

@interface BarMeterViewController ()

@property (nonatomic, strong) AEBarMeterInput *barMeter;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation BarMeterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.barMeter = [[AEBarMeterInput alloc] initWithFrame:self.actionRect0];
    [self.barMeter setAtomValue:0];
    [self.barMeter setFrame:self.actionRect0];
    [self.view addSubview:self.barMeter];
    
    self.slider = [[UISlider alloc] initWithFrame:self.sensorRect4];
    [self.view addSubview:self.slider];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.portLabel0.text = @"0";
}

- (void)sliderValueChanged:(id)sender {
    UInt16 atomValue = self.slider.value * UINT16_MAX;
    [self.barMeter setAtomValue:atomValue];
    self.portLabel0.text = [NSString stringWithFormat:@"%d", atomValue];
}


@end
