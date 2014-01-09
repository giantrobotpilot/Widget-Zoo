//
//  LevelerViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/9/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "LevelerViewController.h"
#import "AEHorizontalLeveler.h"
#import "AEVerticalLeveler.h"

@interface LevelerViewController ()

@property (nonatomic, strong) AEHorizontalLeveler *horizontalLeveler;
@property (nonatomic, strong) AEVerticalLeveler *verticalLeveler;

@end


@implementation LevelerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.verticalLeveler = [[AEVerticalLeveler alloc] init];
    [self.verticalLeveler setFrame:self.sensorRect4];
    [self.verticalLeveler addTarget:self
                             action:@selector(verticalLevelerValueChanged:)
                   forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.verticalLeveler];
    
    self.horizontalLeveler = [[AEHorizontalLeveler alloc] init];
    [self.horizontalLeveler setFrame:self.sensorRect6];
    [self.horizontalLeveler addTarget:self
                               action:@selector(horizontalLevelerValueChanged:)
                     forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.horizontalLeveler];
    
    self.portLabel4.text = @"0";
    self.portLabel6.text = @"0";
}

- (void)verticalLevelerValueChanged:(id)sender {
    self.portLabel4.text = [NSString stringWithFormat:@"%@", self.verticalLeveler.smartValue];
}

- (void)horizontalLevelerValueChanged:(id)sender {
    self.portLabel6.text = [NSString stringWithFormat:@"%@", self.horizontalLeveler.smartValue];
}

@end
