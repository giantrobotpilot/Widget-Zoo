//
//  TestControl.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/10/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "OldTestControl.h"
#import "AEControlTheme.h"

CGFloat expandScale = 3.3;

@interface OldTestControl ()

@property (nonatomic, strong) UIView *configView;

@property (nonatomic, strong) CALayer *background;
@property (nonatomic, strong) CALayer *corner;
@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, strong) UIButton *changeColorButton;
@property (nonatomic, assign) NSInteger chosenColor;
@property (nonatomic, strong) NSArray *colorArray;

@end

@implementation OldTestControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAutoresizesSubviews:NO];
        
        _colorArray = @[ [UIColor greenColor], [UIColor purpleColor], [UIColor blackColor], [UIColor yellowColor], [UIColor blueColor], [UIColor redColor], [UIColor orangeColor], [UIColor whiteColor] ];
        _configView = [[UIView alloc] initWithFrame:self.bounds];
        
        [self.layer setAnchorPoint:CGPointMake(0, 1)];
        CGRect frame1 = self.frame;
        [self setFrame:CGRectMake(frame1.origin.x - frame1.size.width / 2, frame1.origin.y + frame1.size.height / 2, frame1.size.width, frame1.size.height)];
        
        _background = [CALayer layer];
        [_background setCornerRadius:8];
        [_background setFrame:self.bounds];
        [_background setBackgroundColor:[[[AEControlTheme currentTheme] actionAtomColor] CGColor]];
        [self.layer addSublayer:_background];
        
        _corner = [CALayer layer];
        [_corner setCornerRadius:3];
        _corner.frame = CGRectMake(2, 2, 20, 20);
        _corner.backgroundColor = [[self nextColor] CGColor];
        [self.background addSublayer:_corner];
        
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setFrame:CGRectMake(self.bounds.size.width - 25, -5, 20, 20)];
        [_editButton setImage:[[AEControlTheme currentTheme] expandButtonImage] forState:UIControlStateNormal];
        [_editButton addTarget:self
                       action:@selector(editPressed:)
             forControlEvents:UIControlEventTouchUpInside];
        [_editButton setBackgroundColor:[UIColor orangeColor]];
        [self addSubview:_editButton];
        [_editButton setHidden:YES];
        
        _changeColorButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_changeColorButton setFrame:CGRectMake(5, 35, 100, 20)];
        [_changeColorButton setBackgroundColor:[UIColor yellowColor]];
        [_changeColorButton setTitle:@"Change Color" forState:UIControlStateNormal];
        [_changeColorButton addTarget:self
                               action:@selector(changeColorPressed:)
                     forControlEvents:UIControlEventTouchUpInside];
        [_configView addSubview:_changeColorButton];
        //[_changeColorButton setHidden:YES];
        
        _originalFrame = self.frame;
    }
    return self;
}

- (UIColor *)nextColor {
    NSInteger colorIndex = self.chosenColor % [self.colorArray count];
    self.chosenColor++;
    return [self.colorArray objectAtIndex:colorIndex];
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

- (void)changeColorPressed:(id)sender {
    [self.corner setBackgroundColor:[[self nextColor] CGColor]];
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
        // Main View
        //self.layer.transform = CATransform3DMakeScale(expandScale, expandScale, 1);
        self.transform = CGAffineTransformMakeScale(expandScale, expandScale);
        [self.editButton setImage:[[AEControlTheme currentTheme] contractButtonImage] forState:UIControlStateNormal];
        
        // config view
        self.configView.transform = CGAffineTransformMakeScale(1.0f/expandScale, 1.0f/expandScale);
    } completion:^(BOOL finished) {
        [self.editButton setSelected:YES];
        [self addSubview:self.configView];
        NSLog(@"expanded frame: %@", [NSValue valueWithCGRect:self.frame]);
        NSLog(@"transform: %@", [NSValue valueWithCGAffineTransform:self.transform]);
    }];
    //[self.delegate testControlExpanded:self];

}

- (void)shrink {
    [self.configView removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        // Main View
        //self.layer.transform = CATransform3DMakeScale(1, 1, 1);
        self.transform = CGAffineTransformMakeScale(1, 1);
        [self.editButton setImage:[[AEControlTheme currentTheme] expandButtonImage] forState:UIControlStateNormal];

        // config view
        self.configView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
    } completion:^(BOOL finished) {
        
    }];
    //[self.delegate testControlContracted:self];
}

@end
