//
//  ControlDetailViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/8/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "ControlDetailViewController.h"


static const CGFloat kAEDashboardPortIconHeight = 45;
static const CGFloat kAEDashboardPortIconWidth = 100;
static const CGFloat kAEDashboardLowerPortTop = 274;

@interface ControlDetailViewController ()

@end

@implementation ControlDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(CGFloat)229/255
                                                  green:(CGFloat)245/255
                                                   blue:(CGFloat)2250/255
                                                  alpha:1]];

    self.actionRect0 = (CGRect){  87, 215, 100, 59 };
    self.actionRect1 = (CGRect){ 197, 215, 100, 59 };
    self.actionRect2 = (CGRect){ 306, 215, 100, 59 };
    self.actionRect3 = (CGRect){ 416, 215, 100, 59 };
    
    self.sensorRect4 = (CGRect){   87, 45, 100, 160 };
    self.sensorRect5 = (CGRect){  197, 45, 100, 160 };
    self.sensorRect6 = (CGRect){  306, 45, 100, 160 };
    self.sensorRect7 = (CGRect){  416, 45, 100, 160 };
    
    self.portLabel0 = [[UILabel alloc] initWithFrame:CGRectMake( 87, kAEDashboardLowerPortTop, kAEDashboardPortIconWidth, kAEDashboardPortIconHeight)];
    self.portLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(197, kAEDashboardLowerPortTop, kAEDashboardPortIconWidth, kAEDashboardPortIconHeight)];
    self.portLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(306, kAEDashboardLowerPortTop, kAEDashboardPortIconWidth, kAEDashboardPortIconHeight)];
    self.portLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(416, kAEDashboardLowerPortTop, kAEDashboardPortIconWidth, kAEDashboardPortIconHeight)];
    self.portLabel4 = [[UILabel alloc] initWithFrame:CGRectMake( 87, 0, kAEDashboardPortIconWidth, kAEDashboardPortIconHeight)];
    self.portLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(197, 0, kAEDashboardPortIconWidth, kAEDashboardPortIconHeight)];
    self.portLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(306, 0, kAEDashboardPortIconWidth, kAEDashboardPortIconHeight)];
    self.portLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(416, 0, kAEDashboardPortIconWidth, kAEDashboardPortIconHeight)];
    
    [self.view addSubview:self.portLabel0];
    [self.view addSubview:self.portLabel1];
    [self.view addSubview:self.portLabel2];
    [self.view addSubview:self.portLabel3];
    [self.view addSubview:self.portLabel4];
    [self.view addSubview:self.portLabel5];
    [self.view addSubview:self.portLabel6];
    [self.view addSubview:self.portLabel7];
                       
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Back.png"] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(10, 10, 35, 35)];
    [backButton addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end