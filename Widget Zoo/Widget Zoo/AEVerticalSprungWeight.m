//
//  AEVerticalSprungWeight.m
//  Atoms User App
//
//  Created by Drew on 10/15/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEVerticalSprungWeight.h"
#import <CoreMotion/CoreMotion.h>

CGFloat xRatio = 0.5f;
CGFloat topTopYRatio = 0.288f;
CGFloat topCenterYRatio = 0.55f;
CGFloat topBottomYRatio = 0.819f;

CGFloat bottomTopYRatio = 0.163f;
CGFloat bottomCenterYRatio = 0.428f;
CGFloat bottomBottomYRatio = 0.69f;

CGFloat kSpringBoundLeft = 40.0f;
CGFloat kSpringBoundRight = 60.0f;
NSInteger kNumVerticalZigs = 11;
CGFloat kVerticalZigWidth = 10;

@interface AEVerticalSprungWeight ()

@property (nonatomic, assign) CGPoint topPoint;
@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGPoint bottomPoint;
@property (nonatomic, assign) AEVerticalWeightType type;

@end

@implementation AEVerticalSprungWeight

- (id)initWithType:(AEVerticalWeightType)type
{
    self = [super initWithFrame:CGRectMake(0, 0, kSingleWidgetWidth, kDoubleWidgetHeight)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.controlType = AEControlTypeOutput;
        self.throttleOutput = YES;
        
        CGFloat weightX = xRatio * CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        
        UIImage *backgroundImage;
        UIImage *weightImage;
        _type = type;
        if (type == AEVerticalWeightSprungTop) {
            self.controlID = AEControlIDVerticalTopSprungWeight;
            backgroundImage = [[AEControlTheme currentTheme] sprungWeightBaseTop];
            weightImage = [[AEControlTheme currentTheme] sprungWeightMassTop];
            self.topPoint = CGPointMake(weightX, topTopYRatio * height);
            self.centerPoint = CGPointMake(weightX, topCenterYRatio * height);
            self.bottomPoint = CGPointMake(weightX, topBottomYRatio * height);
            self.straightSpringLength = 3;
            self.springAnchorPoint = CGPointMake(0.5 * CGRectGetWidth(self.bounds), .056 * CGRectGetHeight(self.bounds));
        }
        else {
            self.controlID = AEControlIDVerticalBottomSprungWeight;
            backgroundImage = [[AEControlTheme currentTheme] sprungWeightBaseBottom];
            weightImage = [[AEControlTheme currentTheme] sprungWeightMassBottom];
            self.topPoint = CGPointMake(weightX, bottomTopYRatio * height);
            self.centerPoint = CGPointMake(weightX, bottomCenterYRatio * height);
            self.bottomPoint = CGPointMake(weightX, bottomBottomYRatio * height);
            self.straightSpringLength = -3;
            self.springAnchorPoint = CGPointMake(0.5 * CGRectGetWidth(self.bounds), 0.928 * CGRectGetHeight(self.bounds));
        }
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundImageView.image = backgroundImage;
        [self addSubview:backgroundImageView];
        
        self.spring = [[CAShapeLayer alloc] init];
        self.spring.frame = CGRectMake(0, 0, 100, 80);
        self.spring.strokeColor = [self.springColor CGColor];
        self.spring.fillColor = nil;
        self.spring.lineWidth = kSpringLineWidth;
        self.spring.lineCap = kCALineCapSquare;
        [self.layer addSublayer:self.spring];
        
        self.weightLayer = [CALayer layer];
        self.weightLayer.frame = CGRectMake(0, 0, 82.0f/200 * CGRectGetWidth(self.bounds),
                                            86.0f/320 * CGRectGetHeight(self.bounds));
        self.weightLayer.contents = (id)[weightImage CGImage];
        self.weightLayer.anchorPoint = CGPointMake(0.5, 0.5);
        self.weightLayer.position = self.centerPoint;
        [self.layer addSublayer:self.weightLayer];
        
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

//- (void)outputControlValue:(NSTimer *)timer {
//    //[self sendActionsForControlEvents:UIControlEventValueChanged];
//}

CGPoint anchorPointFromWeightPosition(CGPoint weightPosition) {
    return CGPointMake(weightPosition.x, weightPosition.y - kWeightAnchorOffset);
}

- (CGFloat)springAnchorForPoint:(CGPoint)weightPosition {
    if (self.type == AEVerticalWeightSprungTop) {
        return weightPosition.y - kWeightAnchorOffset;
    }
    else {
        return weightPosition.y + kWeightAnchorOffset;
    }
}

- (void)drawSpringToNewPoint:(CGPoint)newPoint
{
    CGFloat springSpan = [self springAnchorForPoint:[self.weightLayer.presentationLayer position]] - self.springAnchorPoint.y;
    CGFloat stepHeight = springSpan / kNumVerticalZigs;
    
    UIBezierPath *oldPath = [UIBezierPath bezierPath];
    [oldPath moveToPoint:self.springAnchorPoint];
    [oldPath addLineToPoint:CGPointMake(self.springAnchorPoint.x,  self.springAnchorPoint.y + self.straightSpringLength)];
    for (int i=1; i < kNumVerticalZigs; i++) {
        CGFloat x;
        if (i % 2 == 1) {
            x = self.springAnchorPoint.x - kVerticalZigWidth;
        } else {
            x = self.springAnchorPoint.x + kVerticalZigWidth;
        }
        CGFloat y = i * stepHeight + self.springAnchorPoint.y;
        [oldPath addLineToPoint:CGPointMake(x, y)];
    }
    [oldPath addLineToPoint:CGPointMake(self.springAnchorPoint.x, stepHeight * kNumVerticalZigs + self.springAnchorPoint.y)];
    [oldPath addLineToPoint:[self.weightLayer.presentationLayer position]];
    
    springSpan = [self springAnchorForPoint:newPoint] - self.springAnchorPoint.y;
    stepHeight = springSpan / kNumVerticalZigs;
    UIBezierPath *newPath = [UIBezierPath bezierPath];
    [newPath moveToPoint:self.springAnchorPoint];
    [newPath addLineToPoint:CGPointMake(self.springAnchorPoint.x,  self.springAnchorPoint.y + self.straightSpringLength)];
    for (int i=1; i < kNumVerticalZigs; i++) {
        CGFloat x;
        if (i % 2 == 1) {
            x = kSpringBoundLeft;
        } else {
            x = kSpringBoundRight;
        }
        CGFloat y = i * stepHeight + self.springAnchorPoint.y;
        [newPath addLineToPoint:CGPointMake(x, y)];
    }
    [newPath addLineToPoint:CGPointMake(self.springAnchorPoint.x, stepHeight * kNumVerticalZigs + self.springAnchorPoint.y)];
    [newPath addLineToPoint:self.weightLayer.position];
    
    CABasicAnimation *springAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    springAnimation.fromValue =(__bridge id)(oldPath.CGPath);
    springAnimation.toValue = (__bridge id)(newPath.CGPath);
    [self.spring addAnimation:springAnimation forKey:@"path"];
}

- (void)setWeightUnit:(CGFloat)value
{
    CGFloat span = self.bottomPoint.y - self.topPoint.y;
    CGFloat toY;
    if (self.type == AEVerticalWeightSprungTop) {
        CGFloat percent = fmaxf(0, value);
        self.atomValue = fabsf(percent * UINT16_MAX);
        toY = percent * span + self.topPoint.y;
    }
    else {
        CGFloat percent = fminf(0, value);
        self.atomValue = fabsf(percent * UINT16_MAX);
        toY = self.bottomPoint.y + percent * span;
    }
    
    // CAAnimation
    CGPoint fromPoint = [[self.weightLayer presentationLayer] position];
    CGPoint toPoint = CGPointMake( self.centerPoint.x, toY);
    self.weightAnimation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    self.weightAnimation.toValue = [NSValue valueWithCGPoint:toPoint];
    [self.weightLayer addAnimation:self.weightAnimation forKey:@"position"];
    self.weightLayer.position = toPoint;
    
    [self drawSpringToNewPoint:toPoint];
}

- (void)accelerometerUpdate:(NSTimer *)timer
{
    CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration;
    CGFloat value = acceleration.x;
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
