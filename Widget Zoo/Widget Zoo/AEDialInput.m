//
//  AERadialDial.m
//  Custom Controls
//
//  Created by Drew on 10/8/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEDialInput.h"

@interface AEDialInput ()

@property (nonatomic, strong) CALayer *dial;

@end

@implementation AEDialInput

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.controlType = AEControlTypeInput;
        self.controlID = AEControlIDDialInput;
        self.clipsToBounds = YES;
        
        UIView *background = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width * .02, self.bounds.size.height * .1, self.bounds.size.width * .98, self.bounds.size.height * .8)];
        background.backgroundColor = [UIColor whiteColor];
        [self addSubview:background];
        
        CGRect needleFrame = CGRectMake(0.17 * self.bounds.size.width,
                                        0.88 * self.bounds.size.height,
                                        0.69 * self.bounds.size.width,
                                        0.11 * self.bounds.size.height);
        
        self.dial = [CALayer layer];
        self.dial.frame = needleFrame;
        self.dial.contents = (id)[[[AEControlTheme currentTheme] dialNeedle] CGImage];
        self.dial.anchorPoint = CGPointMake(0.5, 0.5);
        [self.layer addSublayer:self.dial];
        
        UIImageView *base = [[UIImageView alloc] initWithFrame:self.bounds];
        base.image = [[AEControlTheme currentTheme] dialOverlay];
        [self addSubview:base];
    }
    return self;
}

- (void)setAtomValue:(UInt16)atomValue {
    CGFloat minAngle = 0.319;
    CGFloat maxAngle = 2.83;
    CGFloat angle = (maxAngle - minAngle) * (CGFloat)atomValue / UINT16_MAX + minAngle;
    [self.dial setTransform:CATransform3DMakeRotation(angle, 0, 0, 1)];
}

@end
