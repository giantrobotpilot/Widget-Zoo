//
//  DialViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/8/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "DialViewController.h"
#import "AEDialInput.h"

@interface DialViewController ()

@property (nonatomic, strong) AEDialInput *dial;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation DialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.dial = [[AEDialInput alloc] initWithFrame:self.actionRect0];
    [self.dial setAtomValue:0];
    [self.dial setFrame:self.actionRect0];
    [self.view addSubview:self.dial];
    
    self.slider = [[UISlider alloc] initWithFrame:self.sensorRect4];
    [self.view addSubview:self.slider];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.portLabel0.text = @"0";
}

- (void)sliderValueChanged:(id)sender {
    UInt16 atomValue = self.slider.value * UINT16_MAX;
    [self.dial setAtomValue:atomValue];
    self.portLabel0.text = [NSString stringWithFormat:@"%d", atomValue];
}

@end
