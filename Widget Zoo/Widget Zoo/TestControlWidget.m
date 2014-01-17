//
//  TestControlWidget.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/16/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "TestControlWidget.h"

@implementation TestControlWidget

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.editable = YES;
        self.controlType = AEControlTypeOutput;
        CALayer *background = [CALayer layer];
        [background setFrame:self.bounds];
        [background setCornerRadius:8];
        [background setBackgroundColor:[[[AEControlTheme currentTheme] controlAtomColor] CGColor]];
        [self.layer addSublayer:background];
        
        [self bringSubviewToFront:self.editButton];
    }
    return self;
}

#pragma mark - Editing

- (void)expandControlWithCompletion:(void (^)(void))completion {
    [super expandControlWithCompletion:^{
        [self.configView setAlpha:0.5];
        [self.configView setBackgroundColor:[UIColor greenColor]];
    }];
}

- (void)shrinkControlWithCompletion:(void (^)(void))completion {
    [super shrinkControlWithCompletion:^{
        
    }];
}

@end
