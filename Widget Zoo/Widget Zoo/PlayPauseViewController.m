//
//  PlayPauseViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/8/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "PlayPauseViewController.h"
#import "AEMusicInput.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PlayPauseViewController () <MPMediaPickerControllerDelegate, MusicInputDelegate>

@property (nonatomic, strong) AEMusicInput *playPauseInput;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation PlayPauseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.playPauseInput = [[AEMusicInput alloc] initWithFrame:self.actionRect0];
    self.playPauseInput.frame = self.actionRect0;
    self.playPauseInput.delegate = self;
    self.playPauseInput.musicInputDelegate = self;
    [self.playPauseInput setDelegate:self];
    [self.playPauseInput setExpansionDirection:AEControlExpandDirectionRight];
    [self.view addSubview:self.playPauseInput];
    [self.controlSet addObject:self.playPauseInput];
    
    self.slider = [[UISlider alloc] initWithFrame:self.sensorRect4];
    [self.slider addTarget:self
                    action:@selector(sliderValueChanged:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    self.portLabel0.text = @"0";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.configButton setHidden:NO];
}

- (void)sliderValueChanged:(id)sender {
    UInt16 atomValue = self.slider.value * UINT16_MAX;
    [self.playPauseInput setAtomValue:atomValue];
    self.portLabel0.text = [NSString stringWithFormat:@"%d", atomValue];
}

- (void)musicInputShouldShowMusicPicker {
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
    [picker setDelegate:self];
    picker.prompt = NSLocalizedString (@"Add songs to play", "Prompt in media item picker");
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    NSLog(@"media chosen: %@", [[mediaItemCollection.items objectAtIndex:0] valueForProperty:MPMediaItemPropertyTitle]);
    [self.playPauseInput setMedia:mediaItemCollection];
    [mediaPicker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:NULL];
}

@end
