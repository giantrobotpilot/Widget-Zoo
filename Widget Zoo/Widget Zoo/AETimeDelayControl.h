//
//  AETimeDelayControl.h
//  Widget Zoo
//
//  Created by Drew Christensen on 1/16/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "AEControl.h"
@class AETimeDelayControl;

typedef enum {
    AETimeDelayControlStateStopped,
    AETimeDelayControlStateTiming,
    AETimeDelayControlStateFiring
} AETimeDelayControlState;

@protocol TimeDelayDelegate <NSObject>

- (void)timeDelaySetPressed:(AETimeDelayControl *)control;

@end


@interface AETimeDelayControl : AEControl

@property (nonatomic, assign) AETimeDelayControlState controlState;
@property (nonatomic, weak) id<TimeDelayDelegate> timeDelayDelegate;

- (void)setTimeInterval:(NSTimeInterval)timeInterval;

@end
