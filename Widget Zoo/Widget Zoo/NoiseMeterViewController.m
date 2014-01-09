//
//  NoiseMeterViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/9/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "NoiseMeterViewController.h"
#import "AENoiseMeter.h"
#import "AESharedAudioManager.h"

@interface NoiseMeterViewController ()

@property (nonatomic, strong) AENoiseMeter *noiseMeter;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) AESharedAudioManager *audioManager;

@end

@implementation NoiseMeterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.audioManager = [AESharedAudioManager sharedInstance];
    [self.audioManager startAppAudioSession];
	
    self.noiseMeter = [[AENoiseMeter alloc] init];
    [self.noiseMeter setFrame:self.sensorRect4];
    [self.noiseMeter addTarget:self
                        action:@selector(noiseMeterValueChanged:)
              forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.noiseMeter];
    
    self.slider = [[UISlider alloc] initWithFrame:self.actionRect0];
    [self.slider setUserInteractionEnabled:NO];
    [self.view addSubview:self.slider];
    
    [self.portLabel4 setText:@"0"];
}

- (void)noiseMeterValueChanged:(id)sender {
    UInt16 atomValue = self.noiseMeter.atomValue;
    [self.slider setValue:(float)atomValue/UINT16_MAX animated:NO];
    [self.portLabel4 setText:[NSString stringWithFormat:@"%d", atomValue]];
}

@end