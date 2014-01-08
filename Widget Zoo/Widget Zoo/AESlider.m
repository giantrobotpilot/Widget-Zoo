//
//  AESlider.m
//  Custom Controls
//
//  Created by Drew on 9/27/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AESlider.h"

static const CGFloat kMinThumbY = 0.172;
static const CGFloat kMaxThumbY = 0.806; //223
static const CGFloat kStandardThumbWidth = 0.535;
static const CGFloat kStandardThumbHeight = 0.2187;
static const CGFloat kAnimationDuration = 0.25;

@interface AESlider ()

@property (nonatomic, strong) CALayer *thumbLayer;
@property (nonatomic, assign) CGFloat yBuffer;
@property (nonatomic, strong) CABasicAnimation *springAnimation;
@property (nonatomic, strong) UIView *thumbView;
@property (nonatomic, assign) BOOL sprung;
@property (nonatomic, assign) CGPoint restPoint;

@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat maxY;

@end

@implementation AESlider

- (id)initWithType:(AESliderType)type {
    self = [super initWithFrame:CGRectMake(0, 0, kSingleWidgetWidth, kDoubleWidgetHeight)];
    if (self) {
        self.throttleOutput = YES;
        
        if (type != AESliderTypeNormal) {
            self.sprung = YES;
        }
        
        self.minY = CGRectGetHeight(self.bounds) * kMinThumbY;
        self.maxY = CGRectGetHeight(self.bounds) * kMaxThumbY;
        
        // Background image & restPoint
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *backgroundImage;
        switch (type) {
            case AESliderTypeBottomSprung:
                backgroundImage = [[AEControlTheme currentTheme] sliderBackgroundBottomSprung];
                self.restPoint = CGPointMake( CGRectGetMidX(self.bounds), self.maxY);
                self.controlID = AEControlIDSliderBottomSprung;
                self.controlType = AEControlTypeOutput;
                break;
            case AESliderTypeCenterSprung:
                backgroundImage = [[AEControlTheme currentTheme] sliderBackgroundCenterSprung];
                self.restPoint = CGPointMake( CGRectGetMidX(self.bounds), (self.maxY - self.minY) / 2 + self.minY);
                self.controlID = AEControlIDSliderCenterSprung;
                self.controlType = AEControlTypeSmartOutput;
                break;
            case AESliderTypeNormal:
                backgroundImage = [[AEControlTheme currentTheme] sliderBackgroundUnsprung];
                self.restPoint = CGPointMake( CGRectGetMidX(self.bounds), self.maxY);
                self.controlID = AEControlIDSliderUnsprung;
                self.controlType = AEControlTypeOutput;
            default:
                break;
        }
        backgroundImageView.image = backgroundImage;
        [self addSubview:backgroundImageView];
        
        // Thumb slider
        CGRect thumbRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) * kStandardThumbHeight);
        self.thumbView = [[UIView alloc] initWithFrame:thumbRect];
        self.thumbView.userInteractionEnabled = NO;
        
        CGRect imageRect = CGRectMake(CGRectGetWidth(thumbRect) * 0.225, 0, CGRectGetWidth(thumbRect) * kStandardThumbWidth, CGRectGetHeight(thumbRect));
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageRect];
        imageView.image = [[AEControlTheme currentTheme] sliderThumb];
        [self.thumbView addSubview:imageView];
        
        self.thumbLayer = self.thumbView.layer;
        self.thumbLayer.anchorPoint = CGPointMake(0.5, 0.5);
        [self addSubview:self.thumbView];
        self.thumbLayer.position = self.restPoint;
        
        // Animation
        self.springAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        self.springAnimation.duration = kAnimationDuration;
    }
    return self;
}

- (void)setThumbFrame:(CGRect)newRect {
    if ((int)newRect.origin.y < self.maxY - CGRectGetHeight(self.thumbView.bounds) / 2
        && (int)newRect.origin.y > self.minY - CGRectGetHeight(self.thumbView.bounds) / 2)
    {
        [self.thumbView setFrame:newRect];
    }
}

- (void)outputControlValue:(NSTimer *)timer {
    if ( abs(self.atomValue - self.lastAtomValue) > self.differenceThreshold) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        self.lastAtomValue = self.atomValue;
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGRect presentationRect = [[self.thumbLayer presentationLayer] frame];
    if (self.enabled && CGRectContainsPoint(presentationRect, [touch locationInView:self])) {
        [self.thumbLayer.presentationLayer removeAllAnimations];
        self.yBuffer = [touch locationInView:self].y - CGRectGetMinY(presentationRect);
        [self setThumbFrame:presentationRect];
        if (self.enabled) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        
    
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.enabled) {
        CGRect frame = self.thumbView.frame;
        CGPoint location = [touch locationInView:self];
        [self setThumbFrame:CGRectMake(CGRectGetMinX(frame), location.y - self.yBuffer, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self setAtomValueByY:location.y];
        if (self.enabled) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        return YES;
    }
    else {
        return NO;
    }
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self.throttledOutputTimer invalidate];
    if (self.sprung) {
        CGPoint fromPosition = self.thumbLayer.position;
        CGPoint toPosition = self.restPoint;
        self.springAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        self.springAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        [self.thumbLayer addAnimation:self.springAnimation forKey:@"position"];
        self.thumbLayer.position = toPosition;
        [self setAtomValueByY:self.restPoint.y];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setAtomValueByY:(CGFloat)y
{
    CGFloat percent = (CGFloat)(self.maxY - y) / (self.maxY - self.minY);
    if (percent < 0) {
        percent = 0;
    }
    else if (percent > 1) {
        percent = 1;
    }
    self.atomValue = UINT16_MAX * percent;
}

- (NSData *)smartValue
{
    UInt16 forward = 0;
    UInt16 backward = 0;
    CGFloat percent = (self.maxY - self.thumbView.center.y) / (self.maxY - self.minY);
    if (percent < 0) {
        percent = 0;
    }
    else if (percent > 1) {
        percent = 1;
    }

    if (percent < 0.5) {
        backward = fabs(0.5 - percent) * 2 * UINT16_MAX;
    }
    else {
        forward = fabs(0.5 - percent) * 2 * UINT16_MAX;
    }
    NSMutableData *packet = [[NSMutableData alloc] initWithCapacity:4];
    [packet appendBytes:&forward length:2];
    [packet appendBytes:&backward length:2];
    return packet;
}

//- (UInt16)atomValue {
//    CGFloat percent = (self.maxY - self.thumbView.center.y) / (self.maxY - self.minY);
//    UInt16 value;
//    if (percent < 0) {
//        value = 0;
//    }
//    else {
//        value = percent * UINT16_MAX;
//    }
//    return value;
//}

@end
