//
//  GamepadViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/9/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "GamepadViewController.h"
#import "AEGamepad.h"

@interface GamepadViewController ()

@property (nonatomic, strong) AEGamepad *gamepad;

@end

@implementation GamepadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CGRect dPadFrame = CGRectMake(self.sensorRect4.origin.x, self.sensorRect4.origin.y, 179, 179);
    self.gamepad = [[AEGamepad alloc] initWithFrame:dPadFrame];
    [self.gamepad addTarget:self
                     action:@selector(gamepadValueChanged:)
           forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.gamepad];
}

- (void)gamepadValueChanged:(id)sender {
    NSString *text;
    switch (self.gamepad.dirValue) {
        case kNeutralSmartValue:
            text = @"neutral";
            break;
        case kUpSmartValue:
            // forwards
            text = @"up";
            break;
        case kDownSmartValue:
            //backwards
            text = @"down";
            break;
        case kLeftSmartValue:
            // left
            text = @"left";
            break;
        case kRightSmartValue:
            text = @"right";
            break;
        case kUpLeftSmartValue:
            text = @"up-left";
            break;
        case kUpRightSmartValue:
            text = @"up-right";
            break;
        case kDownLeftSmartValue:
            text = @"down-left";
            break;
        case kDownRightSmartValue:
            text = @"down-right";
            break;
        default:
            text = @"UNKNOWN";
            break;
    }
    self.portLabel4.text = text;
}

@end
