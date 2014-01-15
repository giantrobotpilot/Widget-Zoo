//
//  ToggleSwitchViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/8/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "ToggleSwitchViewController.h"
#import "AEToggle.h"

@interface ToggleSwitchViewController ()

@property (nonatomic, strong) AEToggle *toggle;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation ToggleSwitchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *testView = [[UIView alloc] initWithFrame:self.sensorRect4];
    testView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:testView];
	
    self.toggle = [[AEToggle alloc] initWithFrame:self.sensorRect4];
    [self.toggle addTarget:self action:@selector(togglePressed:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.toggle];
    
    self.slider = [[UISlider alloc] initWithFrame:self.actionRect0];
    [self.slider setUserInteractionEnabled:NO];
    [self.view addSubview:self.slider];
    
    [self.portLabel4 setText:@"0"];
}

- (void)togglePressed:(id)sender {
    UInt16 atomValue = self.toggle.atomValue;
    [self.slider setValue:(float)atomValue/UINT16_MAX animated:NO];
    [self.portLabel4 setText:[NSString stringWithFormat:@"%d", atomValue]];
}

@end
