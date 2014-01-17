//
//  CameraViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/8/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "CameraViewController.h"
#import "AECameraInput.h"

@interface CameraViewController ()

@property (nonatomic, strong) AECameraInput *camera;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation CameraViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.camera = [[AECameraInput alloc] initWithFrame:self.actionRect0];
    [self.camera setFrame:self.actionRect0];
    [self.camera setDelegate:self];
    [self.view addSubview:self.camera];
    [self.controlSet addObject:self.camera];
    [self.camera setExpansionDirection:AEControlExpandDirectionRight];
    
    self.slider = [[UISlider alloc] initWithFrame:self.sensorRect4];
    [self.slider addTarget:self
                    action:@selector(sliderValueChanged:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    self.portLabel0.text = @"0";
}

- (void)sliderValueChanged:(id)sender {
    UInt16 atomValue = self.slider.value * UINT16_MAX;
    [self.camera setAtomValue:atomValue];
    self.portLabel0.text = [NSString stringWithFormat:@"%d", atomValue];
}

@end
