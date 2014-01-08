//
//  AE2DLeveler.m
//  Atoms User App
//
//  Created by Drew on 10/2/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AE2DLeveler.h"
#import <CoreMotion/CoreMotion.h>

static const CGFloat kMinX = 100.0f / 419;
static const CGFloat kMaxX = 319.0f / 419;
static const CGFloat kMinY = 50.0f / 320;
static const CGFloat kMaxY = 269.0f / 320;

@interface AE2DLeveler ()

@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat minX;

@end

@implementation AE2DLeveler

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.minY = kMinY * CGRectGetHeight(self.bounds);
        self.maxY = kMaxY * CGRectGetHeight(self.bounds);
        self.minX = kMinX * CGRectGetWidth(self.bounds);
        self.maxX = kMaxX * CGRectGetWidth(self.bounds);
        
        self.controlID = AEControlID2DLeveler;
        self.portsRequired = 2;
        UIImage *backgroundImage = [[AEControlTheme currentTheme] twoDLevelBase];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [imageView setImage:backgroundImage];
        [self addSubview:imageView];
        
        // Bubble Layer
        self.restPoint = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
        CGFloat bubbleSize = CGRectGetWidth(self.bounds) * 0.143;
        self.bubbleLayer = [CALayer layer];
        self.bubbleLayer.frame = CGRectMake(0, 0, bubbleSize, bubbleSize);
        self.bubbleLayer.contents = (id)[[[AEControlTheme currentTheme] levelBubble] CGImage];
        self.bubbleLayer.anchorPoint = CGPointMake(.5, .5);
        [self.layer addSublayer:self.bubbleLayer];
        self.bubbleLayer.position = self.restPoint;
        
        
        // Guidelines
        UIImageView *guideView = [[UIImageView alloc] initWithFrame:self.bounds];
        guideView.image = [[AEControlTheme currentTheme] twoDLevelGuide];
        [self addSubview:guideView];

        // Acceleromter
        self.motionManager = [[CMMotionManager alloc] init];
        [self.motionManager startAccelerometerUpdates];
        self.motionUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                                  target:self
                                                                selector:@selector(accelerometerUpdate:)
                                                                userInfo:nil
                                                                 repeats:YES];
        
        // Animation
        self.bubbleAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        self.bubbleAnimation.duration = kBubbleAnimationDuration;
    }
    return self;
}

- (CGFloat)distanceFromPoint:(CGPoint)point
{
    CGFloat x = fabs(self.restPoint.x - point.x);
    CGFloat y = fabs(self.restPoint.y - point.y);
    CGFloat bubbleDist = [self pythagX:x y:y];
    
    CGFloat offset = self.bubbleLayer.frame.size.width / 2;
    x = self.maxX - offset - self.restPoint.x;
    y = self.maxY - offset - self.restPoint.y;
    CGFloat levelDist = [self pythagX:x y:y];
    
    return bubbleDist / levelDist;
}

- (CGFloat)pythagX:(CGFloat)x y:(CGFloat)y
{
    return sqrtf((x*x)+(y*y));
}

- (void)setBubbleUnit:(CGPoint)value {
    CGFloat halfVertSpan = (self.maxY - self.minY)  / 2;
    CGFloat halfHorizSpan = (self.maxX - self.minX) / 2;
    
    CGFloat y = self.restPoint.y - (halfVertSpan * value.y);
    CGFloat x = self.restPoint.x - (halfHorizSpan * value.x);

    CGPoint newPoint = CGPointMake(x, y);
    self.smartAngle = [self angleFromPoint:newPoint];
    self.distanceFromCenter = [self distanceFromPoint:newPoint];
    if (self.distanceFromCenter > 1) {
        self.distanceFromCenter = 1;
    }
    
    // CAAnimation
    CGPoint fromPoint = [[self.bubbleLayer presentationLayer] position];
    self.bubbleAnimation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    self.bubbleAnimation.toValue = [NSValue valueWithCGPoint:newPoint];
    [self.bubbleLayer addAnimation:self.bubbleAnimation forKey:@"position"];
    self.bubbleLayer.position = newPoint;
}

- (void)outputControlValue:(NSTimer *)timer
{
    if (self.enabled) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)accelerometerUpdate:(NSTimer *)timer {
    CGFloat x = self.motionManager.accelerometerData.acceleration.x;
    x *= 2;
    CGFloat y = self.motionManager.accelerometerData.acceleration.y;
    y *= 2;
    if (x < -1) {
        x = -1;
    } else if (x > 1) {
        x = 1;
    }
    if (y < -1) {
        y = -1;
    } else if (y > 1) {
        y = 1;
    }
    
    [self setBubbleUnit:CGPointMake(y, x)];
    self.smartPoint = CGPointMake(y, x);
    if (self.enabled) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (CGFloat)angleFromPoint:(CGPoint)touchPoint {
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat x = touchPoint.x - centerPoint.x;
    CGFloat y = touchPoint.y - centerPoint.y;
    
    CGFloat rad = atan2f(y, x);
    CGFloat angle = 180 / M_PI * rad;
    if ( angle < 0) {
        angle += 360;
    }
    return angle;
}

@end
