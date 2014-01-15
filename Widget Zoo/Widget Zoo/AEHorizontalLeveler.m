//
//  AEHorizontalLeveler.m
//  Custom Controls
//
//  Created by Drew on 9/30/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEHorizontalLeveler.h"

static const CGFloat kMinX = 0.05;
static const CGFloat kMaxX = 0.94;

@interface AEHorizontalLeveler ()

@property (nonatomic, assign) AEHorizontalLevelType type;

@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat minX;

@end

@implementation AEHorizontalLeveler

- (id)initWithFrame:(CGRect)frame {
    CGFloat height = .625 * frame.size.height;
    CGFloat yOffset = (frame.size.height - height) / 2;
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + yOffset, frame.size.width, height)];
    if (self) {
        self.throttleOutput = YES;
        self.controlID = AControlIDEHorizontalLeveler;
        self.restPoint = CGPointMake( CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) -1);

        // Background
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundImageView.image = [[AEControlTheme currentTheme] horizontalLevelBackground];
        [self addSubview:backgroundImageView];
        
        // Bubble Layer
        CGFloat bubbleSize = CGRectGetWidth(self.bounds) * 0.3;
        self.bubbleLayer = [CALayer layer];
        self.bubbleLayer.frame = CGRectMake(0, 0, bubbleSize, bubbleSize);
        self.bubbleLayer.contents = (id)[[[AEControlTheme currentTheme] levelBubble] CGImage];
        self.bubbleLayer.anchorPoint = CGPointMake(.5, .5);
        [self.layer addSublayer:self.bubbleLayer];
        self.bubbleLayer.position = self.restPoint;

        self.minX = CGRectGetWidth(self.bounds) * kMinX + 0.5 * bubbleSize;
        self.maxX = CGRectGetWidth(self.bounds) * kMaxX - 0.5 * bubbleSize;
        
        // Guide Lines
        CGRect guideFrame = CGRectMake( CGRectGetWidth(self.bounds) * 0.35, CGRectGetHeight(self.bounds) * 0.343, CGRectGetWidth(self.bounds) * 0.30, CGRectGetHeight(self.bounds) * 0.294 );
        UIImageView *guideView = [[UIImageView alloc] initWithFrame:guideFrame];
        guideView.image = [[AEControlTheme currentTheme] horizontalLevelGuide];
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
    CGFloat span = self.maxX - self.minX;
    CGFloat halfSpan = span / 2;
    CGFloat x = halfSpan - (halfSpan * value) + self.minX;
    
    // CAAnimation
    CGPoint fromPoint = [[self.bubbleLayer presentationLayer] position];
    CGPoint toPoint = CGPointMake( x, self.restPoint.y);
    self.bubbleAnimation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    self.bubbleAnimation.toValue = [NSValue valueWithCGPoint:toPoint];
    [self.bubbleLayer addAnimation:self.bubbleAnimation forKey:@"position"];
    self.bubbleLayer.position = toPoint;
    
    self.atomValue = value;
}

- (void)accelerometerUpdate:(NSTimer *)timer {
    CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration;
    //NSLog(@"x:%f", acceleration.x);
    CGFloat value = acceleration.y * 2;
    self.currentAccelValue = value;
    if (value > 1) {
        value = 1;
    } else if (value < -1) {
        value = -1;
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
