//
//  PitchControlViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/8/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "PitchControlViewController.h"
#import "AEPitchInput.h"

@interface PitchControlViewController ()

@property (nonatomic, strong) AEPitchInput *pitchInput;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation PitchControlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.pitchInput = [[AEPitchInput alloc] initWithFrame:self.actionRect0];
    [self.pitchInput setFrame:self.actionRect0];
    [self.view addSubview:self.pitchInput];
    
    self.slider = [[UISlider alloc] initWithFrame:self.sensorRect4];
    [self.slider addTarget:self
                    action:@selector(sliderValueChagned:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    self.portLabel0.text = @"0";
}

- (void)sliderValueChagned:(id)sender {
    UInt16 atomValue = self.slider.value * UINT16_MAX;
    [self.pitchInput setAtomValue:atomValue];
    self.portLabel0.text = [NSString stringWithFormat:@"%d", atomValue];
}

@end
