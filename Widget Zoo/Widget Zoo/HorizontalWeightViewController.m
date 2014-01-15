//
//  SprungWeightViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/9/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "HorizontalWeightViewController.h"
#import "AEHorizontalSprungWeight.h"

@interface HorizontalWeightViewController ()

@property (nonatomic, strong) AEHorizontalSprungWeight *leftSprungWeight;
@property (nonatomic, strong) UISlider *leftSprungSlider;

@property (nonatomic, strong) AEHorizontalSprungWeight *rightSprungWeight;
@property (nonatomic, strong) UISlider *rightSprungSlider;

@end

@implementation HorizontalWeightViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.leftSprungWeight = [[AEHorizontalSprungWeight alloc] initWithFrame:self.sensorRect4 type:AEHorizontalWeightTypeSprungLeft];
    [self.leftSprungWeight setFrame:self.sensorRect4];
    [self.leftSprungWeight addTarget:self
                              action:@selector(leftSprungWeightValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.leftSprungWeight];
    
    self.leftSprungSlider = [[UISlider alloc] initWithFrame:self.actionRect0];
    [self.leftSprungSlider setUserInteractionEnabled:NO];
    [self.view addSubview:self.leftSprungSlider];
        
    self.rightSprungWeight = [[AEHorizontalSprungWeight alloc] initWithFrame:self.sensorRect6 type:AEHorizontalWeightTypeSprungRight];
    [self.rightSprungWeight addTarget:self
                               action:@selector(rightSprungWeightValueChanged:)
                     forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.rightSprungWeight];
    
    
    self.rightSprungSlider = [[UISlider alloc] initWithFrame:self.actionRect2];
    [self.rightSprungSlider setUserInteractionEnabled:NO];
    [self.view addSubview:self.rightSprungSlider];

    self.portLabel4.text = @"0";
    self.portLabel6.text = @"0";
}



- (void)leftSprungWeightValueChanged:(id)sender {
    UInt16 atomValue = self.leftSprungWeight.atomValue;
    [self.leftSprungSlider setValue:(float)atomValue/UINT16_MAX animated:NO];
    self.portLabel4.text = [NSString stringWithFormat:@"%d", atomValue];
}

- (void)rightSprungWeightValueChanged:(id)sender {
    UInt16 atomValue = self.rightSprungWeight.atomValue;
    [self.rightSprungSlider setValue:(float)atomValue/UINT16_MAX animated:NO];
    self.portLabel6.text = [NSString stringWithFormat:@"%d", atomValue];
}

@end
