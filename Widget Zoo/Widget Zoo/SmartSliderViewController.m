//
//  SmartSliderViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/9/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "SmartSliderViewController.h"
#import "AESlider.h"

@interface SmartSliderViewController ()

@property (nonatomic, strong) AESlider *smartSlider;

@end

@implementation SmartSliderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.smartSlider = [[AESlider alloc] initWithFrame:self.sensorRect4 type:AESliderTypeCenterSprung];
    [self.smartSlider addTarget:self
                         action:@selector(smartSliderValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.smartSlider];
    
    self.portLabel4.text = @"-";
}

- (void)smartSliderValueChanged:(id)sender {
    NSData *smartValue = self.smartSlider.smartValue;
    self.portLabel4.text = [NSString stringWithFormat:@"%@", smartValue];
}

@end
