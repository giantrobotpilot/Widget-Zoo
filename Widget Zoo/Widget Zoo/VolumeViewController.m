//
//  VolumeViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/8/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "VolumeViewController.h"
#import "AEVolumeInput.h"

@interface VolumeViewController ()

@property (nonatomic, strong) AEVolumeInput *volumeInput;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation VolumeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.volumeInput = [[AEVolumeInput alloc] initWithFrame:self.actionRect0];
    [self.volumeInput setFrame:self.actionRect0];
    [self.view addSubview:self.volumeInput];
    
    self.slider = [[UISlider alloc] initWithFrame:self.sensorRect4];
    [self.slider addTarget:self
                    action:@selector(sliderValueChanged:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    [self.portLabel0 setText:@"0"];
}

- (void)sliderValueChanged:(id)sender {
    UInt16 atomValue = self.slider.value * UINT16_MAX;
    [self.volumeInput setAtomValue:atomValue];
    [self.portLabel0 setText:[NSString stringWithFormat:@"%d", atomValue]];
}

@end
