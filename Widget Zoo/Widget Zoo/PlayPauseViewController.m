//
//  PlayPauseViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/8/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "PlayPauseViewController.h"
#import "AEMusicInput.h"

@interface PlayPauseViewController ()

@property (nonatomic, strong) AEMusicInput *playPauseInput;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation PlayPauseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.playPauseInput = [[AEMusicInput alloc] initWithFrame:self.actionRect0];
    self.playPauseInput.frame = self.actionRect0;
    [self.view addSubview:self.playPauseInput];
    
    self.slider = [[UISlider alloc] initWithFrame:self.sensorRect4];
    [self.slider addTarget:self
                    action:@selector(sliderValueChanged:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    self.portLabel0.text = @"0";
}

- (void)sliderValueChanged:(id)sender {
    UInt16 atomValue = self.slider.value * UINT16_MAX;
    [self.playPauseInput setAtomValue:atomValue];
    self.portLabel0.text = [NSString stringWithFormat:@"%d", atomValue];
}

@end