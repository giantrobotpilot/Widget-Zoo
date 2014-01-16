//
//  AETimeDelayControl.h
//  Widget Zoo
//
//  Created by Drew Christensen on 1/16/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "AEControl.h"

typedef enum {
    AETimeDelayControlStateStopped,
    AETimeDelayControlStateTiming,
    AETimeDelayControlStateFiring
} AETimeDelayControlState;

@interface AETimeDelayControl : AEControl

@property (nonatomic, assign) AETimeDelayControlState controlState;

@end
