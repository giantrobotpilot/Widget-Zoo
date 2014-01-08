//
//  AELeveler.m
//  Atoms User App
//
//  Created by Drew on 10/2/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AELeveler.h"

@interface AELeveler ()


@end

@implementation AELeveler

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.controlType = AEControlTypeSmartOutput;
        _accelDifferenceThreshold = 0.03;
    }
    return self;
}

- (void)outputControlValue:(NSTimer *)timer {
    if (self.enabled) {
        CGFloat difference = fabs(self.currentAccelValue - self.lastSentAccelValue);
        if (difference  > self.accelDifferenceThreshold) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            self.lastSentAccelValue = self.currentAccelValue;
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
