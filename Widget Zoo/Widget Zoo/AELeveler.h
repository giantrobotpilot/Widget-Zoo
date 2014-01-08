//
//  AELeveler.h
//  Atoms User App
//
//  Created by Drew on 10/2/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEControl.h"
#import <CoreMotion/CMMotionManager.h>

static const CGFloat kBubbleSize = 30;
static const NSTimeInterval kAccelerometerUpdateInterval = 0.2;
static const NSTimeInterval kBubbleAnimationDuration = 0.1;

@interface AELeveler : AEControl

@property (nonatomic, assign) BOOL sprung;
@property (nonatomic, assign) CGPoint restPoint;
@property (nonatomic, strong) UIImageView *bubbleView;
@property (nonatomic, strong) CALayer *bubbleLayer;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) NSTimer *motionUpdateTimer;
@property (nonatomic, strong) CABasicAnimation *bubbleAnimation;

@property (nonatomic, assign) CGFloat lastSentAccelValue;
@property (nonatomic, assign) CGFloat currentAccelValue;
@property (nonatomic, assign) CGFloat accelDifferenceThreshold;

- (void)outputControlValue:(NSTimer *)timer;

@end
