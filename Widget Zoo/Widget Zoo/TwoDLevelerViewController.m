//
//  TwoDLevelerViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/9/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "TwoDLevelerViewController.h"
#import "AE2DLeveler.h"

@interface TwoDLevelerViewController ()

@property (nonatomic, strong) AE2DLeveler *leveler;

@end

@implementation TwoDLevelerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CGRect dPadFrame = CGRectMake(self.sensorRect4.origin.x, self.sensorRect4.origin.y, 210, 160);
    self.leveler = [[AE2DLeveler alloc] initWithFrame:dPadFrame];
    [self.leveler addTarget:self
                     action:@selector(levelerValueChanged:)
           forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.leveler];
    
    self.portLabel0.font = [UIFont systemFontOfSize:14];
    self.portLabel2.font = [UIFont systemFontOfSize:14];
    self.portLabel4.font = [UIFont systemFontOfSize:14];
}

- (void)levelerValueChanged:(id)sender {
    CGPoint smartPoint = self.leveler.smartPoint;
    CGFloat smartAngle = self.leveler.smartAngle;
    CGFloat distanceFromCenter = self.leveler.distanceFromCenter;
    
    self.portLabel4.text = [NSString stringWithFormat:@"x:%.2f y:%.2f", smartPoint.x, smartPoint.y];
    
    UInt16 leftForward = 0;
    UInt16 leftBackward = 0;
    UInt16 rightForward = 0;
    UInt16 rightBackward = 0;
    
    CGFloat threshold = 0.2;
    if (fabs(smartPoint.x) > threshold || fabs(smartPoint.y) > threshold) {
        
        if (smartAngle >= 180 && smartAngle < 270) {
            // left F full, right throttled
            leftForward = 0xffff;
            leftBackward = 0x0000;
            
            if (smartAngle > 225) {
                rightForward = fabs(225 - smartAngle)/45 * 0xffff;
                rightBackward = 0x0000;
            }
            else {
                rightForward = 0x0000;
                rightBackward = fabs(225 - smartAngle)/45 * 0xffff;
            }
        }
        else if (smartAngle >= 270 && smartAngle < 360) {
            // left throttled, right F full
            rightForward = 0xffff;
            rightBackward = 0x0000;
            
            if (smartAngle < 315) {
                leftForward = fabs(315 - smartAngle)/45 * 0xffff;
                leftBackward = 0x0000;
            }
            else {
                leftForward = 0x0000;
                leftBackward = fabs(315 - smartAngle)/45 * 0xffff;
            }
        }
        else if (smartAngle >= 0 && smartAngle < 90) {
            // left R full, right throttled
            leftForward = 0x0000;
            leftBackward = 0xffff;
            
            if (smartAngle < 45) {
                rightForward = fabs(45 - smartAngle)/45 * 0xffff;
                rightBackward = 0x0000;
            }
            else {
                rightForward = 0x0000;
                rightBackward = fabs(45 - smartAngle)/45 * 0xffff;
            }
        }
        else if (smartAngle >=90 && smartAngle < 180) {
            // left throttled, right R full
            rightForward = 0x0000;
            rightBackward = 0xffff;
            
            if (smartAngle < 135) {
                leftForward = 0x0000;
                leftBackward = fabs(135 - smartAngle)/45 * 0xffff;
            }
            else {
                leftForward = fabs(135 - smartAngle)/45 * 0xffff;
                leftBackward = 0x0000;
            }
        }
        else {
            NSLog(@"ERROR - unexpected angle %f in %s", smartAngle, __PRETTY_FUNCTION__);
        }
    }
    
    leftForward *= distanceFromCenter;
    leftBackward *= distanceFromCenter;
    rightForward *= distanceFromCenter;
    rightBackward *= distanceFromCenter;
    
    NSMutableData *leftData = [[NSMutableData alloc] init];
    [leftData appendBytes:&leftForward length:2];
    [leftData appendBytes:&leftBackward length:2];
    
    NSMutableData *rightData = [[NSMutableData alloc] init];
    [rightData appendBytes:&rightForward length:2];
    [rightData appendBytes:&rightBackward length:2];

    self.portLabel0.text = [NSString stringWithFormat:@"L:%@", leftData];
    self.portLabel2.text =[NSString stringWithFormat:@"R:%@", rightData];
}

@end
