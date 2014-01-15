//
//  AEHorizontalSprungWeight.m
//  Atoms User App
//
//  Created by Drew on 10/15/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEHorizontalSprungWeight.h"

CGFloat yRatio = 0.48f;
CGFloat lLeftXRatio = 0.33f;
CGFloat lCenterXRatio = 0.535;
CGFloat lRightXRatio = 0.785;

CGFloat rLeftXRatio = 0.21f;
CGFloat rCenterXRatio = 0.44f;
CGFloat rRightXRatio = 0.665f;

CGFloat kHorizontalZigWidth = 6;
NSInteger kNumZigs = 8;

@interface AEHorizontalSprungWeight ()

@property (nonatomic, assign) CGPoint leftPoint;
@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGPoint rightPoint;
@property (nonatomic, assign) AEHorizontalWeightType type;

@end

@implementation AEHorizontalSprungWeight

- (id)initWithFrame:(CGRect)frame type:(AEHorizontalWeightType)type
{
    CGFloat height = .625 * frame.size.height;
    CGFloat yOffset = (frame.size.height - height) / 2;
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + yOffset, frame.size.width, height)];
    if (self) {
        self.controlType = AEControlTypeOutput;
        self.throttleOutput = YES;
        
        UIImage *backgroundImage;
        UIImage *weightImage;
        CGFloat centerY = yRatio * CGRectGetHeight(self.bounds);
        CGFloat width = CGRectGetWidth(self.bounds);
        _type = type;
        if (type == AEHorizontalWeightTypeSprungLeft) {
            self.controlID = AEControlIDHorizontalLeftSprungWeight;
            backgroundImage = [[AEControlTheme currentTheme] sprungWeightBaseLeft];
            weightImage = [[AEControlTheme currentTheme] sprungWeightMassLeft];
            self.leftPoint = CGPointMake(lLeftXRatio * width, centerY);
            self.centerPoint = CGPointMake(lCenterXRatio * width, centerY);
            self.rightPoint = CGPointMake(lRightXRatio * width, centerY);
            self.springAnchorPoint = CGPointMake(8, self.bounds.size.height * 0.5);
        }
        else {
            self.controlID = AEControlIDHorizontalRightSprungWeight;
            backgroundImage = [[AEControlTheme currentTheme] sprungWeightBaseRight];
            weightImage = [[AEControlTheme currentTheme] sprungWeightMassRight];
            self.leftPoint = CGPointMake(rLeftXRatio * width, centerY);
            self.centerPoint = CGPointMake(rCenterXRatio * width, centerY);
            self.rightPoint = CGPointMake(rRightXRatio * width, centerY);
            self.springAnchorPoint = CGPointMake(self.bounds.size.width - 8, self.bounds.size.height * 0.5);
        }
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundImageView.image = backgroundImage;
        [self addSubview:backgroundImageView];
        
        // Spring
        self.spring = [[CAShapeLayer alloc] init];
        self.spring.frame = self.bounds;
        self.spring.strokeColor = [self.springColor CGColor];
        self.spring.fillColor = nil;
        self.spring.lineWidth = kSpringLineWidth;
        self.spring.lineCap = kCALineCapSquare;
        [self.layer addSublayer:self.spring];
        
        // Weight
        self.weightLayer = [CALayer layer];
        self.weightLayer.frame = CGRectMake(0, 0, 0.33 * width, 0.31 * CGRectGetHeight(self.bounds));
        self.weightLayer.anchorPoint = CGPointMake(0.5, 0.5);
        self.weightLayer.contents = (id)[weightImage CGImage];
        [self.layer addSublayer:self.weightLayer];
        
        self.weightLayer.position = self.rightPoint;
        
        // Animation
        self.weightAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        self.weightAnimation.duration = kWeightAnimationDuration;
        
        // Accelerometer tracking
        self.motionManager = [[CMMotionManager alloc] init];
        [self.motionManager startAccelerometerUpdates];
        self.motionUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:kWeightAccelerometerUpdateInterval
                                                                  target:self
                                                                selector:@selector(accelerometerUpdate:)
                                                                userInfo:nil
                                                                 repeats:YES];
    }
    return self;
}

- (CGFloat)springAnchorForPoint:(CGPoint)weightPosition {
    if (self.type == AEHorizontalWeightTypeSprungLeft) {
        return weightPosition.x - kWeightAnchorOffset;
    }
    else {
        return weightPosition.x + kWeightAnchorOffset;
    }
}

- (void)drawSpringToNewPoint:(CGPoint)newPoint
{
    CGFloat springSpan = [self springAnchorForPoint:[self.weightLayer.presentationLayer position]] - self.springAnchorPoint.x;
    CGFloat stepHeight = springSpan / kNumZigs;
    
    UIBezierPath *oldPath = [UIBezierPath bezierPath];
    [oldPath moveToPoint:self.springAnchorPoint];
    [oldPath addLineToPoint:CGPointMake(self.springAnchorPoint.x + self.straightSpringLength,  self.springAnchorPoint.y)];
    for (int i=1; i < kNumZigs; i++) {
        CGFloat y;
        if (i % 2 == 1) {
            y = self.springAnchorPoint.y + kHorizontalZigWidth;
        } else {
            y = self.springAnchorPoint.y - kHorizontalZigWidth;
        }
        CGFloat x = i * stepHeight + self.springAnchorPoint.x;
        [oldPath addLineToPoint:CGPointMake(x, y)];
    }
    [oldPath addLineToPoint:CGPointMake(stepHeight * kNumZigs + self.springAnchorPoint.x, self.springAnchorPoint.y)];
    [oldPath addLineToPoint:[self.weightLayer.presentationLayer position]];
    
    springSpan = [self springAnchorForPoint:newPoint] - self.springAnchorPoint.x;
    stepHeight = springSpan / kNumZigs;
    UIBezierPath *newPath = [UIBezierPath bezierPath];
    [newPath moveToPoint:self.springAnchorPoint];
    [newPath addLineToPoint:CGPointMake(self.springAnchorPoint.x  + self.straightSpringLength, self.springAnchorPoint.y)];
    for (int i=1; i < kNumZigs; i++) {
        CGFloat y;
        if (i % 2 == 1) {
            y = self.springAnchorPoint.y + kHorizontalZigWidth;
        } else {
            y = self.springAnchorPoint.y - kHorizontalZigWidth;
        }
        CGFloat x = i * stepHeight + self.springAnchorPoint.x;
        [newPath addLineToPoint:CGPointMake(x, y)];
    }

    [newPath addLineToPoint:CGPointMake(stepHeight * kNumZigs + self.springAnchorPoint.x, self.springAnchorPoint.y)];
    [newPath addLineToPoint:self.weightLayer.position];
    
    CABasicAnimation *springAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    springAnimation.fromValue =(__bridge id)(oldPath.CGPath);
    springAnimation.toValue = (__bridge id)(newPath.CGPath);
    [self.spring addAnimation:springAnimation forKey:@"path"];
}

- (void)setWeightUnit:(CGFloat)value
{
    CGFloat span = self.rightPoint.x - self.leftPoint.x;
    CGFloat toX;
    if (self.type == AEHorizontalWeightTypeSprungLeft) {
        CGFloat percent = fmaxf(0, value);
        self.atomValue = fabsf(percent * UINT16_MAX);
        toX = percent * span + self.leftPoint.x;
    }
    else {
        CGFloat percent = fminf(0, value);
        self.atomValue = fabsf(percent * UINT16_MAX);
        toX = self.rightPoint.x + percent * span;
    }
    
    // CAAnimation
    CGPoint fromPoint = [[self.weightLayer presentationLayer] position];
    CGPoint toPoint = CGPointMake( toX, self.centerPoint.y);
    self.weightAnimation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    self.weightAnimation.toValue = [NSValue valueWithCGPoint:toPoint];
    [self.weightLayer addAnimation:self.weightAnimation forKey:@"position"];
    self.weightLayer.position = toPoint;
    
    [self drawSpringToNewPoint:toPoint];
}

- (void)accelerometerUpdate:(NSTimer *)timer
{
    CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration;
    CGFloat value = acceleration.y;
    if (value < -1) {
        value = -1;
    } else if (value > 1) {
        value = 1;
    }
    [self setWeightUnit:value];
    if (self.enabled) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
