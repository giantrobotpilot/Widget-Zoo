//
//  OverlayDial.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/14/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "OverlayDial.h"

@interface OverlayDial () {
    CGFloat expandScale;
}

@property (nonatomic, strong) CALayer *dial;
@property (nonatomic, strong) UIView *configView;

@end

@implementation OverlayDial

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setAnchorPoint:CGPointMake(0, 1)];
        CGRect frame1 = self.frame;
        [self setFrame:CGRectMake(frame1.origin.x - frame1.size.width / 2, frame1.origin.y + frame1.size.height / 2, frame1.size.width, frame1.size.height)];
        
        expandScale = 3.3;
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
        
        self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.editButton setFrame:CGRectMake(self.bounds.size.width - 20, 0, 20, 20)];
        [self.editButton setImage:[[AEControlTheme currentTheme] expandButtonImage] forState:UIControlStateNormal];
        [self.editButton addTarget:self
                        action:@selector(editPressed:)
              forControlEvents:UIControlEventTouchUpInside];
        //[self.editButton setBackgroundColor:[UIColor orangeColor]];
        [self addSubview:self.editButton];
        [self.editButton setHidden:YES];
    }
    return self;
}

- (void)setAtomValue:(UInt16)atomValue {
    CGFloat minAngle = 0.319;
    CGFloat maxAngle = 2.83;
    CGFloat angle = (maxAngle - minAngle) * (CGFloat)atomValue / UINT16_MAX + minAngle;
    [self.dial setTransform:CATransform3DMakeRotation(angle, 0, 0, 1)];
}

- (void)editPressed:(id)sender {
    if (self.expanded) {
        [self shrink];
    }
    else {
        [self expand];
    }
    self.expanded = !self.expanded;
}

- (void)setEditMode:(BOOL)editing {
    if (editing) {
        [self.editButton setHidden:NO];
    }
    else {
        [self.editButton setHidden:YES];
    }
}

- (void)expand {
    NSLog(@"%s", __FUNCTION__);
    [UIView animateWithDuration:0.25 animations:^{
        // Main View
        self.transform = CGAffineTransformMakeScale(expandScale, expandScale);
        [self.editButton setImage:[[AEControlTheme currentTheme] contractButtonImage] forState:UIControlStateNormal];
        
        // config view
    } completion:^(BOOL finished) {
        self.configView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width * expandScale, self.bounds.size.height * expandScale)];
        self.configView.transform = CGAffineTransformMakeScale(1.0f/expandScale, 1.0f/expandScale);
        self.configView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.configView];
        [self bringSubviewToFront:self.editButton];
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.configView.bounds.size.width, self.configView.bounds.size.height)];
        [self.configView addSubview:slider];
        self.configView.frame = CGRectMake(0, 0, self.configView.frame.size.width, self.configView.frame.size.height);
        NSLog(@"config frame = %@", [NSValue valueWithCGRect:self.configView.frame]);
    }];
    [self.delegate testControlExpanded:self];
}

- (void)shrink {
    NSLog(@"%s", __FUNCTION__);
    [self.configView removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        // Main View
        self.transform = CGAffineTransformMakeScale(1, 1);
        [self.editButton setImage:[[AEControlTheme currentTheme] expandButtonImage] forState:UIControlStateNormal];
    }];
    [self.delegate testControlContracted:self];
}

@end
