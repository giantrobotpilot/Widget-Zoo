//
//  AEToggle.m
//  Atoms User App
//
//  Created by Drew on 10/15/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEToggle.h"

@interface AEToggle ()

@property (nonatomic, strong) CALayer *thumbLayer;
@property (nonatomic, assign) BOOL on;
@property (nonatomic, assign) CGPoint onPoint;
@property (nonatomic, assign) CGPoint offPoint;

@end

@implementation AEToggle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, kSingleWidgetWidth, kSingleWidgetWidth)];
    if (self) {
        self.controlID = AEControlIDToggleSwitch;
        self.onPoint = CGPointMake(100.0f/200 * CGRectGetWidth(self.bounds),
                                   78.0f/204 * CGRectGetHeight(self.bounds));
        self.offPoint = CGPointMake(100.0f/200 * CGRectGetWidth(self.bounds),
                                    126.0f/204 * CGRectGetHeight(self.bounds));
        
        CGRect onFrame = CGRectMake(39.0f/200 * CGRectGetWidth(self.bounds),
                                    103.f/204 * CGRectGetHeight(self.bounds),
                                    121.0f/200 * CGRectGetWidth(self.bounds),
                                    54.0f/204 * CGRectGetHeight(self.bounds));
        
        CALayer *onBG = [CALayer layer];
        onBG.frame = onFrame;
        onBG.backgroundColor = [[UIColor colorWithRed:95.0f/255 green:195.0f/255 blue:60.0f/255 alpha:1] CGColor];
        [self.layer addSublayer:onBG];
        
        CGRect offFrame = CGRectMake(33.0f/200 * CGRectGetWidth(self.bounds),
                                     36.0f/204 * CGRectGetHeight(self.bounds),
                                     134.0f/200 * CGRectGetWidth(self.bounds),
                                     65.0f/204 * CGRectGetHeight(self.bounds));
        CALayer *offBG = [CALayer layer];
        offBG.frame = offFrame;
        offBG.backgroundColor = [[UIColor colorWithRed:244.0f/255 green:64.0f/255 blue:16.0f/255 alpha:1] CGColor];
        [self.layer addSublayer:offBG];
        
        UIImageView *baseView = [[UIImageView alloc] initWithFrame:self.bounds];
        baseView.image = [[AEControlTheme currentTheme] toggleBase];
        [self addSubview:baseView];
        
        self.thumbLayer = [CALayer layer];
        self.thumbLayer.frame = CGRectMake(43.0f/200 * CGRectGetWidth(self.bounds),
                                           46.0f/204 * CGRectGetHeight(self.bounds),
                                           112.0f/200 * CGRectGetWidth(self.bounds),
                                           63.0f/204 * CGRectGetHeight(self.bounds));
        self.thumbLayer.contents = (id)[[[AEControlTheme currentTheme] toggleThumb] CGImage];
        [self.layer addSublayer:self.thumbLayer];
        self.thumbLayer.anchorPoint = CGPointMake(0.5, 0.5);
        self.thumbLayer.position = self.offPoint;
    }
    return self;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return self.enabled;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.on) {
        self.on = NO;
        [self.thumbLayer setPosition:self.offPoint];
        self.atomValue = 0;
    }
    else {
        self.on = YES;
        [self.thumbLayer setPosition:self.onPoint];
        self.atomValue = UINT16_MAX;
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
