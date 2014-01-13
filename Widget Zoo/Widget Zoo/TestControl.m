//
//  TestControl.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/10/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "TestControl.h"
#import "AEControlTheme.h"

CGFloat expandScale = 3.3;

@interface TestControl ()

@property (nonatomic, strong) CALayer *background;
@property (nonatomic, assign) CGRect originalFrame;

@end

@implementation TestControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setAnchorPoint:CGPointMake(0, 1)];
        CGRect frame1 = self.frame;
        [self setFrame:CGRectMake(frame1.origin.x - frame1.size.width / 2, frame1.origin.y + frame1.size.height / 2, frame1.size.width, frame1.size.height)];
        
        _background = [CALayer layer];
        [_background setCornerRadius:8];
        [_background setFrame:self.bounds];
        [_background setBackgroundColor:[[[AEControlTheme currentTheme] actionAtomColor] CGColor]];
        [self.layer addSublayer:_background];
        
        CALayer *corner = [CALayer layer];
        [corner setCornerRadius:3];
        corner.frame = CGRectMake(2, 2, 20, 20);
        corner.backgroundColor = [[UIColor greenColor] CGColor];
        [self.background addSublayer:corner];
        
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setFrame:CGRectMake(self.bounds.size.width - 25, -5, 20, 20)];
        [_editButton setImage:[[AEControlTheme currentTheme] expandButtonImage] forState:UIControlStateNormal];
        [_editButton addTarget:self
                       action:@selector(editPressed:)
             forControlEvents:UIControlEventTouchUpInside];
        [_editButton setBackgroundColor:[UIColor orangeColor]];
        [self addSubview:_editButton];
        [_editButton setHidden:YES];
        
        _originalFrame = self.frame;
    }
    return self;
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
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.transform = CATransform3DMakeScale(expandScale, expandScale, 1);
    } completion:^(BOOL finished) {
        [self.editButton setSelected:YES];
        [self.editButton setImage:[[AEControlTheme currentTheme] contractButtonImage] forState:UIControlStateNormal];
    }];
    [self.delegate testControlExpanded:self];
}

- (void)shrink {
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.transform = CATransform3DMakeScale(1, 1, 1);
    } completion:^(BOOL finished) {
        [self.editButton setImage:[[AEControlTheme currentTheme] expandButtonImage] forState:UIControlStateNormal];
    }];
    [self.delegate testControlContracted:self];
}

@end
