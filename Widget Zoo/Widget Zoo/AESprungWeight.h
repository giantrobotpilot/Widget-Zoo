//
//  AESprungWeight.h
//  Atoms User App
//
//  Created by Drew on 10/15/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEControl.h"
#import <CoreMotion/CMMotionManager.h>

static const NSTimeInterval kWeightAccelerometerUpdateInterval = 0.1;
static const NSTimeInterval kWeightAnimationDuration = 0.1;

static const CGFloat kSpringLineWidth = 2.0f;
static const CGFloat kWeightAnchorOffset = 20.0f;

@interface AESprungWeight : AEControl

// Weight
@property (nonatomic, strong) CALayer *weightLayer;
@property (nonatomic, strong) CABasicAnimation *weightAnimation;
@property (nonatomic, assign) CGPoint restPoint;

// Animation
@property (nonatomic, strong) CABasicAnimation *springAnimation;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) NSTimer *motionUpdateTimer;

// Spring
@property (nonatomic, assign) CGPoint springAnchorPoint;
@property (nonatomic, strong) UIColor *springColor;
@property (nonatomic, strong) CAShapeLayer *spring;
@property (nonatomic, assign) CGFloat straightSpringLength;

- (void)outputControlValue:(NSTimer *)timer;

@end

