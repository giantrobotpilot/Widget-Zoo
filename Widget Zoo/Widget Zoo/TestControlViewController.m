//
//  TestControlViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/10/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "TestControlViewController.h"
#import "TestActionWidget.h"
#import "TestControlWidget.h"

@interface TestControlViewController () <AEEditableControlDelegate>

@property (nonatomic, strong) UIView *smokeyView;

@end

@implementation TestControlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *testView1 = [[UIView alloc] initWithFrame:self.actionRect0];
    [testView1 setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:testView1];
    
    UIView *testView2 = [[UIView alloc] initWithFrame:self.actionRect1];
    [testView2 setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:testView2];
    
    UIView *testView4 = [[UIView alloc] initWithFrame:self.sensorRect4];
    [testView4 setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:testView4];
    
    UIView *testView5 = [[UIView alloc] initWithFrame:self.sensorRect5];
    [testView5 setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:testView5];
    
    UIView *testView6 = [[UIView alloc] initWithFrame:self.sensorRect6];
    [testView6 setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:testView6];
    
    UIView *testView7 = [[UIView alloc] initWithFrame:self.sensorRect7];
    [testView7 setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:testView7];
    
    self.smokeyView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.smokeyView.backgroundColor = [UIColor blackColor];
    self.smokeyView.alpha = 0.7;
    
    TestControlWidget *control1 = [[TestControlWidget alloc] initWithFrame:self.sensorRect4];
    [control1 setExpansionDirection:AEControlExpandDirectionRight];
    [control1 setDelegate:self];
    [self.view addSubview:control1];
    
    TestControlWidget *control2 = [[TestControlWidget alloc] initWithFrame:self.sensorRect5];
    [control2 setExpansionDirection:AEControlExpandDirectionRight];
    [control2 setDelegate:self];
    [self.view addSubview:control2];
    
    TestControlWidget *control3 = [[TestControlWidget alloc] initWithFrame:self.sensorRect6];
    [control3 setExpansionDirection:AEControlExpandDirectionLeft];
    [control3 setDelegate:self];
    [self.view addSubview:control3];
    
    TestControlWidget *control4 = [[TestControlWidget alloc] initWithFrame:self.sensorRect7];
    [control4 setExpansionDirection:AEControlExpandDirectionLeft];
    [control4 setDelegate:self];
    [self.view addSubview:control4];
    
    TestActionWidget *action1 = [[TestActionWidget alloc] initWithFrame:self.actionRect0];
    [action1 setExpansionDirection:AEControlExpandDirectionRight];
    [action1 setDelegate:self];
    [self.view addSubview:action1];
    
    TestActionWidget *action2 = [[TestActionWidget alloc] initWithFrame:self.actionRect1];
    [action2 setExpansionDirection:AEControlExpandDirectionRight];
    [action2 setDelegate:self];
    [self.view addSubview:action2];
    
    [self.controlSet addObject:control1];
    [self.controlSet addObject:control2];
    [self.controlSet addObject:control3];
    [self.controlSet addObject:control4];
    [self.controlSet addObject:action1];
    [self.controlSet addObject:action2];
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.smokeyView.frame = self.view.bounds;
    [self.configButton setHidden:NO];
}



@end
