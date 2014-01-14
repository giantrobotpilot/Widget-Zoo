//
//  TestControlViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/10/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "TestControlViewController.h"
#import "TestControl.h"
#import "OverlayDial.h"

@interface TestControlViewController () <TestControlDelegate>

@property (nonatomic, strong) TestControl *testControl;
@property (nonatomic, strong) OverlayDial *overlayControl;
@property (nonatomic, strong) UIView *smokeyView;

@end

@implementation TestControlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.smokeyView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.smokeyView.backgroundColor = [UIColor blackColor];
    self.smokeyView.alpha = 0.7;
	
    self.testControl = [[TestControl alloc] initWithFrame:self.actionRect0];
    self.testControl.delegate = self;
    [self.view addSubview:self.testControl];
    
    self.overlayControl = [[OverlayDial alloc] initWithFrame:self.actionRect1];
    self.overlayControl.delegate = self;
    [self.view addSubview:self.overlayControl];
    [self.overlayControl setAtomValue:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.smokeyView.frame = self.view.bounds;
    [self.configButton setHidden:NO];
}

- (void)testControlExpanded:(TestControl *)control {
    [self.view bringSubviewToFront:control];
    self.smokeyView.alpha = 0.0;
    [self.view insertSubview:self.smokeyView belowSubview:control];
    [UIView animateWithDuration:0.25 animations:^{
        self.smokeyView.alpha = 0.7;
    }];
}

- (void)testControlContracted:(TestControl *)control {
    [UIView animateWithDuration:0.25 animations:^{
        self.smokeyView.alpha = 0.0;
    }completion:^(BOOL finished) {
        [self.smokeyView removeFromSuperview];
    }];
}

- (void)configPressed:(id)sender {
    [super configPressed:sender];
    if (self.dashboardEditMode) {
        [self.testControl setEditMode:YES];
        [self.overlayControl setEditMode:YES];
    }
    else {
        [self.testControl setEditMode:NO];
        [self.overlayControl setEditMode:NO];
    }
}

@end
