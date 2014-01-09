//
//  SliderViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/8/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "SliderViewController.h"
#import "AESlider.h"

@interface SliderViewController ()

@property (nonatomic, strong) AESlider *sprungSlider;
@property (nonatomic, strong) AESlider *unsprungSlider;
@property (nonatomic, strong) UISlider *sprungValueSlider;
@property (nonatomic, strong) UISlider *unsprungValueSlider;

@end

@implementation SliderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.sprungSlider = [[AESlider alloc] initWithType:AESliderTypeBottomSprung];
    [self.sprungSlider setFrame:self.sensorRect4];
    [self.sprungSlider addTarget:self
                          action:@selector(sprungSliderChanged:)
                forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.sprungSlider];
    
    self.unsprungSlider = [[AESlider alloc] initWithType:AESliderTypeNormal];
    [self.unsprungSlider setFrame:self.sensorRect5];
    [self.unsprungSlider addTarget:self
                            action:@selector(unsprungSliderChanged:)
                  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.unsprungSlider];
    
    self.sprungValueSlider = [[UISlider alloc] initWithFrame:self.actionRect0];
    [self.sprungValueSlider setUserInteractionEnabled:NO];
    [self.view addSubview:self.sprungValueSlider];
    
    self.unsprungValueSlider = [[UISlider alloc] initWithFrame:self.actionRect1];
    [self.unsprungValueSlider setUserInteractionEnabled:NO];
    [self.view addSubview:self.unsprungValueSlider];
    
    [self.portLabel4 setText:@"0"];
    [self.portLabel5 setText:@"0"];
}

- (void)sprungSliderChanged:(id)sender {
    UInt16 atomValue = self.sprungSlider.atomValue;
    [self.sprungValueSlider setValue:(float)atomValue/UINT16_MAX animated:NO];
    [self.portLabel4 setText:[NSString stringWithFormat:@"%d", atomValue]];
}

- (void)unsprungSliderChanged:(id)sender {
    UInt16 atomValue = self.unsprungSlider.atomValue;
    [self.unsprungValueSlider setValue:(float)atomValue/UINT16_MAX animated:NO];
    [self.portLabel5 setText:[NSString stringWithFormat:@"%d", atomValue]];
}

@end
