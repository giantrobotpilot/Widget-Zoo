//
//  AEBarMeter.m
//  Custom Controls
//
//  Created by Drew on 10/8/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEBarMeterInput.h"

@interface AEBarMeterInput ()

@property (nonatomic, strong) UIView *maskView;

@end

@implementation AEBarMeterInput

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, kSingleWidgetWidth, kSingleInputHeight)];
    if (self) {
        self.controlType = AEControlTypeInput;
        self.controlID = AEControlIDBarMeterInput;
        UIImageView *meterView = [[UIImageView alloc] initWithFrame:self.bounds];
        meterView.image = [[AEControlTheme currentTheme] barMeterBars];
        [self addSubview:meterView];
        
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 10,
                                                                 CGRectGetWidth(self.bounds),
                                                                 CGRectGetHeight(self.bounds)-20)];
        self.maskView.backgroundColor = [[AEControlTheme currentTheme] barMeterMaskColor];
        [self addSubview:self.maskView];
        
        UIImageView *baseView = [[UIImageView alloc] initWithFrame:self.bounds];
        baseView.image = [[AEControlTheme currentTheme] barMeterOverlay];
        [self addSubview:baseView];
    }
    return self;
}

- (void)setAtomValue:(UInt16)atomValue {
    CGFloat value = (CGFloat)atomValue / UINT16_MAX * self.bounds.size.width;
    CGRect maskRect = self.maskView.frame;
    if (self.enabled) {
        [self.maskView setFrame:CGRectMake(value, maskRect.origin.y, CGRectGetWidth(self.bounds)-value, maskRect.size.height)];
    }
}

@end
