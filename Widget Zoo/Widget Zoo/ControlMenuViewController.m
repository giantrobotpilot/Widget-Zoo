//
//  ControlMenuViewController.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/8/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "ControlMenuViewController.h"

#import "BarMeterViewController.h"
#import "ButtonViewController.h"
#import "CameraViewController.h"
#import "DialViewController.h"
#import "GamepadViewController.h"
#import "HorizontalWeightViewController.h"
#import "LevelerViewController.h"
#import "NoiseMeterViewController.h"
#import "NumberOutputViewController.h"
#import "PitchControlViewController.h"
#import "PlayPauseViewController.h"
#import "SliderViewController.h"
#import "SmartSliderViewController.h"
#import "TestControlViewController.h"
#import "TimeDelayViewController.h"
#import "ToggleSwitchViewController.h"
#import "TwoDLevelerViewController.h"
#import "VerticalWeightViewController.h"
#import "VolumeViewController.h"

#define SMART_SECTION   0
#define SENSOR_SECTION  1
#define ACTION_SECTION  2

@interface ControlMenuViewController ()

@property (nonatomic, copy) NSArray *action;
@property (nonatomic, copy) NSArray *control;
@property (nonatomic, copy) NSArray *smart;

@end


@implementation ControlMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController pushViewController:[[CameraViewController alloc] init] animated:YES];

    NSArray *array = @[@"Bar Meter", @"Camera", @"Music", @"Pitch Shift", @"Dial", @"Volume", @"Number Display"];
    _action = [array sortedArrayUsingSelector:@selector(compare:)];
    
    array = @[@"Button", @"Noise Meter", @"Sliders", @"H. Sprung Weights", @"V. Sprung Weights", @"Toggle", @"Time Delay"];
    _control = [array sortedArrayUsingSelector:@selector(compare:)];
    
    array = @[@"2D Leveler", @"Gamepad", @"Levelers", @"Smart Slider", @"Edit Control Test"];
    _smart = [array sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case SMART_SECTION:
            return @"Smart Control Widgets";
            break;
        case SENSOR_SECTION:
            return @"Control Widgets";
            break;
        case ACTION_SECTION:
            return @"Action Widgets";
            break;
        default:
            return 0;
            break;
    }

}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSArray *)arrayForSection:(NSInteger)section {
    NSArray *array;
    switch (section) {
        case SMART_SECTION:
            array = self.smart;
            break;
        case SENSOR_SECTION:
            array = self.control;
            break;
        case ACTION_SECTION:
            array = self.action;
            break;
        default:
            array = nil;
            break;
    }
    return array;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self arrayForSection:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *array = [self arrayForSection:indexPath.section];
    
    NSString *widget = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = widget;
    if ([widget isEqual:@"Time Delay"] || [widget isEqual:@"Edit Control Test"] || [widget isEqual:@"Number Display"] || [widget isEqual:@"Music"]) {
        cell.detailTextLabel.text = @"NEW!";
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    else {
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *widgetName = [[self arrayForSection:indexPath.section] objectAtIndex:indexPath.row];
    if ([widgetName isEqual:@"Dial"]) {
        [self.navigationController pushViewController:[[DialViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"Bar Meter"]) {
        [self.navigationController pushViewController:[[BarMeterViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"Toggle"]) {
        [self.navigationController pushViewController:[[ToggleSwitchViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"Sliders"]) {
        [self.navigationController pushViewController:[[SliderViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"Button"]) {
        [self.navigationController pushViewController:[[ButtonViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"Volume"]) {
        [self.navigationController pushViewController:[[VolumeViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"Pitch Shift"]) {
        [self.navigationController pushViewController:[[PitchControlViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"Music"]) {
        [self.navigationController pushViewController:[[PlayPauseViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"Camera"]) {
        [self.navigationController pushViewController:[[CameraViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"Noise Meter"]) {
        [self.navigationController pushViewController:[[NoiseMeterViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"H. Sprung Weights"]) {
        [self.navigationController pushViewController:[[HorizontalWeightViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"V. Sprung Weights"]) {
        [self.navigationController pushViewController:[[VerticalWeightViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"Smart Slider"]) {
        [self.navigationController pushViewController:[[SmartSliderViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"Levelers"]) {
        [self.navigationController pushViewController:[[LevelerViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"Gamepad"]) {
        [self.navigationController pushViewController:[[GamepadViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"2D Leveler"]) {
        [self.navigationController pushViewController:[[TwoDLevelerViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"Number Display"]) {
        [self.navigationController pushViewController:[[NumberOutputViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"Edit Control Test"]) {
        [self.navigationController pushViewController:[[TestControlViewController alloc] init] animated:YES];
    }
    else if ([widgetName isEqual:@"Time Delay"]) {
        [self.navigationController pushViewController:[[TimeDelayViewController alloc] init] animated:YES];
    }
}


@end
