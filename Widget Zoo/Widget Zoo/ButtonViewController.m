//
//  ButtonViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/8/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "ButtonViewController.h"
#import "AEButton.h"

@interface ButtonViewController ()

@property (nonatomic, strong) AEButton *button;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation ButtonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.button = [[AEButton alloc] init];
    [self.button setFrame:self.sensorRect4];
    [self.button addTarget:self
                    action:@selector(buttonPressed:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.button];
    NSLog(@"button frame = %@", [NSValue valueWithCGRect:self.button.frame]);
    
    self.slider = [[UISlider alloc] initWithFrame:self.actionRect0];
    [self.slider setUserInteractionEnabled:NO];
    [self.view addSubview:self.slider];
    
    [self.portLabel4 setText:@"0"];
}

- (void)buttonPressed:(id)sender {
    UInt16 atomValue = self.button.atomValue;
    [self.slider setValue:(float)atomValue / UINT16_MAX animated:NO];
    [self.portLabel4 setText:[NSString stringWithFormat:@"%d", atomValue]];
}

@end
