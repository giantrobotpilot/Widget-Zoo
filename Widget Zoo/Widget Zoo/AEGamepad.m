//
//  AEGamepad.m
//  Custom Controls
//
//  Created by Drew on 9/30/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEGamepad.h"

@interface AEGamepad ()

@property (nonatomic, strong) UIImageView *gamepadImageView;

@property (nonatomic, strong) UIImage *upImage;
@property (nonatomic, strong) UIImage *upRightImage;
@property (nonatomic, strong) UIImage *upLeftImage;

@property (nonatomic, strong) UIImage *downImage;
@property (nonatomic, strong) UIImage *downRightImage;
@property (nonatomic, strong) UIImage *downLeftImage;

@property (nonatomic, strong) UIImage *leftImage;
@property (nonatomic, strong) UIImage *rightImage;
@property (nonatomic, strong) UIImage *neutral;

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) NSInteger previousDirValue;

@end

@implementation AEGamepad

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.controlType = AEControlTypeSmartOutput;
        self.controlID = AEControlIDGamepad;
        self.portsRequired = 2;
        self.throttleOutput = YES;
        
        self.upImage = [[AEControlTheme currentTheme] dPadUp];
        self.upRightImage = [[AEControlTheme currentTheme] dPadUpRight];
        self.upLeftImage = [[AEControlTheme currentTheme] dPadUpLeft];
        self.downImage = [[AEControlTheme currentTheme] dPadDown];
        self.downRightImage = [[AEControlTheme currentTheme] dPadDownRight];
        self.downLeftImage = [[AEControlTheme currentTheme] dPadDownLeft];
        self.leftImage = [[AEControlTheme currentTheme] dPadLeft];
        self.rightImage = [[AEControlTheme currentTheme] dPadRight];
        self.neutral = [[AEControlTheme currentTheme] dPadNeutral];
        
        self.gamepadImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.gamepadImageView.image = self.neutral;
        [self addSubview:self.gamepadImageView];
        
        //self.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    }
    return self;
}

//- (void)outputControlValue:(NSTimer *)timer {
//    [self sendActionsForControlEvents:UIControlEventValueChanged];
//}

- (UIBezierPath *)gamepadPath {
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    return path;
}

- (CGRect)upRect {
    return CGRectMake(60, 4, 60, 56);
}

- (CGRect)downRect {
    return CGRectMake(60, 119, 59, 56);
}

- (CGRect)leftRect {
    return CGRectMake(5, 60, 56, 59);
}

- (CGRect)rightRect {
    return CGRectMake(119, 60, 56, 59);
}

- (void)setDirValue:(NSInteger)dirValue
{
    if (dirValue != self.previousDirValue) {
        _dirValue = dirValue;
        self.previousDirValue = dirValue;
        if (self.enabled) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

#pragma mark - Touch tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint currentPoint = [touch locationInView:self];
    if (self.enabled && [[self gamepadPath] containsPoint:currentPoint]) {
        [self configureForTouchPoint:currentPoint];
        return YES;
    }
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.enabled) {
        CGPoint currentPoint = [touch locationInView:self];
        [self configureForTouchPoint:currentPoint];
        return YES;
    }
    else {
        return NO;
    }
}

- (void)configureFor4TouchPoint:(CGPoint)currentPoint {
    if (CGRectContainsPoint([self upRect], currentPoint)) {
        //self.smartValue = kUpSmartValue;
        self.gamepadImageView.image = self.upImage;
    }
    else if (CGRectContainsPoint([self downRect], currentPoint)) {
        //self.smartValue = kDownSmartValue;
        self.gamepadImageView.image = self.downImage;
    }
    else if (CGRectContainsPoint([self leftRect], currentPoint)) {
        //self.smartValue = kLeftSmartValue;
        self.gamepadImageView.image = self.leftImage;
    }
    else if (CGRectContainsPoint([self rightRect], currentPoint)) {
        //self.smartValue = kRightSmartValue;
        self.gamepadImageView.image = self.rightImage;
    }
}

- (void)configureForTouchPoint:(CGPoint)touchPoint
{
    CGFloat angle = [self angleFromPoint:touchPoint];
    if (angle >= 22.5 && angle < 67.5) {
        self.gamepadImageView.image = self.downRightImage;
        self.dirValue = kDownRightSmartValue;
    }
    else if (angle >= 67.5 && angle <112.5) {
        self.gamepadImageView.image = self.downImage;
        self.dirValue = kDownSmartValue;
        //self.smartValue = kDownSmartValue;
    }
    else if (angle >= 112.5 && angle < 157.5) {
        self.gamepadImageView.image = self.downLeftImage;
        self.dirValue = kDownLeftSmartValue;
    }
    else if (angle >= 157.5 && angle < 202.5) {
        self.gamepadImageView.image = self.leftImage;
        //self.smartValue = kLeftSmartValue;
        self.dirValue = kLeftSmartValue;
    }
    else if (angle >= 202.5 && angle < 247.5) {
        self.gamepadImageView.image = self.upLeftImage;
        self.dirValue = kUpLeftSmartValue;
    }
    else if (angle >= 247.5 && angle < 292.5) {
        self.gamepadImageView.image = self.upImage;
        //self.smartValue = kUpSmartValue;
        self.dirValue = kUpSmartValue;
    }
    else if (angle >= 292.5 && angle < 337.5) {
        self.gamepadImageView.image = self.upRightImage;
        self.dirValue = kUpRightSmartValue;
    }
    else {
        self.gamepadImageView.image = self.rightImage;
        //self.smartValue = kRightSmartValue;
        self.dirValue = kRightSmartValue;
    }
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self.throttledOutputTimer invalidate];
    self.gamepadImageView.image = self.neutral;
    self.dirValue = kNeutralSmartValue;
    if (self.enabled) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - Utility

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
