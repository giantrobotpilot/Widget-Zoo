//
//  AEVerticalLeveler.m
//  Custom Controls
//
//  Created by Drew on 9/30/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEVerticalLeveler.h"
#import <CoreMotion/CoreMotion.h>

static const CGFloat kMinYRatio = 0.0625; //20
static const CGFloat kMaxYRatio = 0.915; //293

@interface AEVerticalLeveler ()

@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat maxY;

@end

@implementation AEVerticalLeveler

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, kSingleWidgetWidth, kDoubleWidgetHeight)];
    if (self) {
        self.controlID = AEControlIDVerticalLeveler;
        self.restPoint = CGPointMake( CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) );
        
        // Background image
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [[AEControlTheme currentTheme] verticalLevelBackground];
        [self addSubview:imageView];
        
        // Bubble Layer
        CGFloat bubbleSize = CGRectGetWidth(self.bounds) * 0.3;
        self.bubbleLayer = [CALayer layer];
        self.bubbleLayer.frame = CGRectMake(0, 0, bubbleSize, bubbleSize);
        self.bubbleLayer.contents = (id)[[[AEControlTheme currentTheme] levelBubble] CGImage];
        self.bubbleLayer.anchorPoint = CGPointMake(.5, .5);
        [self.layer addSublayer:self.bubbleLayer];
        self.bubbleLayer.position = self.restPoint;
        
        self.minY = CGRectGetHeight(self.bounds) * kMinYRatio + 0.5 * bubbleSize;
        self.maxY = CGRectGetHeight(self.bounds) * kMaxYRatio - 0.5 * bubbleSize;
        
        // Guide Lines
        CGRect guideFrame = CGRectMake( CGRectGetWidth(self.bounds) * 0.35,
                                        CGRectGetHeight(self.bounds) * 0.353,
                                        CGRectGetWidth(self.bounds) * 0.30,
                                       CGRectGetHeight(self.bounds) * 0.29);
        UIImageView *guideView = [[UIImageView alloc] initWithFrame:guideFrame];
        guideView.image = [[AEControlTheme currentTheme] verticalLevelGuide];
        [self addSubview:guideView];
        
        // Animation
        self.bubbleAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        self.bubbleAnimation.duration = kBubbleAnimationDuration;
        
        // Accelerometer tracking
        self.motionManager = [[CMMotionManager alloc] init];
        [self.motionManager startAccelerometerUpdates];
        self.motionUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:kAccelerometerUpdateInterval
                                                                  target:self
                                                                selector:@selector(accelerometerUpdate:)
                                                                userInfo:nil
                                                                 repeats:YES];
    }
    return self;
}

- (void)setBubbleUnit:(CGFloat)value {
    CGFloat span = self.maxY - self.minY;
    CGFloat halfSpan = span / 2;
    CGFloat y = halfSpan - (halfSpan * value) + self.minY;
    
    // CAAnimation
    CGPoint fromPoint = [[self.bubbleLayer presentationLayer] position];
    CGPoint toPoint = CGPointMake( self.restPoint.x, y);
    self.bubbleAnimation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    self.bubbleAnimation.toValue = [NSValue valueWithCGPoint:toPoint];
    [self.bubbleLayer addAnimation:self.bubbleAnimation forKey:@"position"];
    self.bubbleLayer.position = toPoint;
}

- (void)accelerometerUpdate:(NSTimer *)timer {
    CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration;
    CGFloat value = acceleration.x * 2;
    self.currentAccelValue = value;
    if (value < -1) {
        value = -1;
    } else if (value > 1) {
        value = 1;
    }
    [self setBubbleUnit:value];
    
    UInt16 forward = 0;
    UInt16 backward = 0;
    CGFloat threshold = 0.08;
    if (value > 0 + threshold) {
        backward = value * UINT16_MAX;
    }
    else if (value < 0 - threshold) {
        forward = fabs(value) * UINT16_MAX;
    }
    NSMutableData *smartData = [[NSMutableData alloc] initWithCapacity:4];

    [smartData appendBytes:&forward length:2];
    [smartData appendBytes:&backward length:2];
    self.smartValue = smartData;
    if (self.enabled) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
