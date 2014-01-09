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
#import "HorizontalWeightViewController.h"
#import "NoiseMeterViewController.h"
#import "PitchControlViewController.h"
#import "PlayPauseViewController.h"
#import "SliderViewController.h"
#import "ToggleSwitchViewController.h"
#import "VerticalWeightViewController.h"
#import "VolumeViewController.h"

#define SMART_SECTION   0
#define SENSOR_SECTION  1
#define ACTION_SECTION  2

@interface ControlMenuViewController ()

@property (nonatomic, copy) NSArray *action;
@property (nonatomic, copy) NSArray *sensor;
@property (nonatomic, copy) NSArray *smart;

@end


@implementation ControlMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *array = @[@"Bar Meter", @"Camera", @"Music", @"Pitch Shift", @"Dial", @"Volume"];
    _action = [array sortedArrayUsingSelector:@selector(compare:)];
    
    array = @[@"Button", @"Noise Meter", @"Sliders", @"H. Sprung Weights", @"V. Sprung Weights", @"Toggle", ];
    _sensor = [array sortedArrayUsingSelector:@selector(compare:)];
    
    array = @[@"2D Leveler", @"Gamepad", @"Levelers", @"Smart Slider"];
    _smart = [array sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case SMART_SECTION:
            return @"Smart Widgets";
            break;
        case SENSOR_SECTION:
            return @"Sensor Widgets";
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
            array = self.sensor;
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
    
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
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
}


@end
