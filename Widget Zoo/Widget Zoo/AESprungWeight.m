//
//  AESprungWeight.m
//  Atoms User App
//
//  Created by Drew on 10/15/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AESprungWeight.h"

@implementation AESprungWeight

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _springColor = [[AEControlTheme currentTheme] springColor];
    }
    return self;
}

- (void)outputControlValue:(NSTimer *)timer {
    if (self.enabled) {
        if ( abs(self.atomValue - self.lastAtomValue) > self.differenceThreshold) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            self.lastAtomValue = self.atomValue;
        }
    }
}

- (void)teardown {
    [self.motionUpdateTimer invalidate];
    [self.motionManager stopAccelerometerUpdates];
    [self.throttledOutputTimer invalidate];
    self.throttledOutputTimer = nil;
    self.motionManager = nil;
}

- (void)removeFromSuperview {
    [self teardown];
    [super removeFromSuperview];
}

- (void)dealloc {
    [self teardown];
}

@end
