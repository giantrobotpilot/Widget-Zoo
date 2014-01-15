//
//  VerticalWeightViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/9/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "VerticalWeightViewController.h"
#import "AEVerticalSprungWeight.h"

@interface VerticalWeightViewController ()

@property (nonatomic, strong) AEVerticalSprungWeight *topSprungWeight;
@property (nonatomic, strong) UISlider *topSprungSlider;

@property (nonatomic, strong) AEVerticalSprungWeight *bottomSprungWeight;
@property (nonatomic, strong) UISlider *bottomSprungSlider;

@end

@implementation VerticalWeightViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.topSprungWeight = [[AEVerticalSprungWeight alloc] initWithFrame:self.sensorRect4 type:AEVerticalWeightSprungTop];
    [self.topSprungWeight setFrame:self.sensorRect4];
    [self.topSprungWeight addTarget:self
                             action:@selector(topSprungWeightValueChanged:)
                   forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.topSprungWeight];
    
    self.topSprungSlider = [[UISlider alloc] initWithFrame:self.actionRect0];
    [self.topSprungSlider setUserInteractionEnabled:NO];
    [self.view addSubview:self.topSprungSlider];
	
    self.bottomSprungWeight = [[AEVerticalSprungWeight alloc] initWithFrame:self.sensorRect6 type:AEVerticalWeightSprungBottom];
    [self.bottomSprungWeight setFrame:self.sensorRect6];
    [self.bottomSprungWeight addTarget:self
                                action:@selector(bottomSprungWeightValueChanged:)
                      forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.bottomSprungWeight];
    
    self.bottomSprungSlider = [[UISlider alloc] initWithFrame:self.actionRect2];
    [self.bottomSprungSlider setUserInteractionEnabled:NO];
    [self.view addSubview:self.bottomSprungSlider];
    
    self.portLabel4.text = @"0";
    self.portLabel6.text = @"0";
}

- (void)topSprungWeightValueChanged:(id)sender {
    UInt16 atomValue = self.topSprungWeight.atomValue;
    [self.topSprungSlider setValue:(float)atomValue/UINT16_MAX animated:NO];
    self.portLabel4.text = [NSString stringWithFormat:@"%d", atomValue];
}

- (void)bottomSprungWeightValueChanged:(id)sender {
    UInt16 atomValue = self.bottomSprungWeight.atomValue;
    [self.bottomSprungSlider setValue:(float)atomValue/UINT16_MAX animated:NO];
    self.portLabel6.text = [NSString stringWithFormat:@"%d", atomValue];
}

@end
