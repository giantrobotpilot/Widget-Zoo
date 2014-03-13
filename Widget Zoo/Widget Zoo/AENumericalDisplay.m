//
//  AENumericalDisplay.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/9/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "AENumericalDisplay.h"
#import "AEControlTheme.h"

@interface AENumericalDisplay ()

@property (nonatomic, strong) UILabel *label;
@end

@implementation AENumericalDisplay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CALayer *background = [CALayer layer];
        [background setFrame:self.bounds];
        [background setBackgroundColor:[[[AEControlTheme currentTheme] actionAtomColor] CGColor]];
        [background setCornerRadius:5];
        [self.layer addSublayer:background];
        
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.text = @"0";
        self.label.font = [UIFont fontWithName:@"AvenirNext-Bold" size:36];
        self.label.textColor = [UIColor whiteColor];
        [_label setBackgroundColor:[UIColor clearColor]];
        [self.layer addSublayer:self.label.layer];
        
        [self addSubview:self.editButton];
    }
    return self;
}

- (void)setAtomValue:(UInt16)atomValue {
    NSInteger converted = (float)atomValue/UINT16_MAX * 100;
    self.label.text = [NSString stringWithFormat:@"%d", converted];
}

@end
