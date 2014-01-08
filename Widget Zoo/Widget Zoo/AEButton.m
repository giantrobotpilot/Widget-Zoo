//
//  AEButton.m
//  Custom Controls
//
//  Created by Drew on 9/30/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEButton.h"

@interface AEButton ()

//@property (nonatomic, assign) BOOL depressed;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation AEButton

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, kSingleWidgetWidth, kSingleWidgetHeight)];
    if (self) {
        self.controlType = AEControlTypeOutput;
        UIImage *backgroundImage;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.controlID = AEControlIDButton;
        backgroundImage = [[AEControlTheme currentTheme] buttonBackground];
        
        // Background image
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backgroundImageView.image = backgroundImage;
        [self addSubview:self.backgroundImageView];
        
        // Button
        CGFloat buttonSize = CGRectGetWidth(self.bounds) * 0.67;
        CGFloat x = self.bounds.size.width / 2 - buttonSize / 2;
        CGFloat y = self.bounds.size.height / 2 - buttonSize / 2;
        button.frame = CGRectMake(x, y, buttonSize, buttonSize);
        [button setImage:[[AEControlTheme currentTheme] buttonUp] forState:UIControlStateNormal];
        [button setImage:[[AEControlTheme currentTheme] buttonDown] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        [self addSubview:button];
        self.button = button;
    }
    return self;
}

- (void)configureForGamepad
{
    self.backgroundImageView.image = [[AEControlTheme atomsTheme] buttonBackground];
}

- (void)setEnabled:(BOOL)enabled
{
    [self.button setEnabled:enabled];
}

- (void)buttonDown:(id)sender {
    self.atomValue = UINT16_MAX;
    //self.smartValue = 1;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)buttonUp:(id)sender {
    self.atomValue = 0;
    self.smartValue = 0;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


@end
