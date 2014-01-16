//
//  TestControl.h
//  Widget Zoo
//
//  Created by Drew Christensen on 1/10/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OldTestControl;

@protocol TestControlDelegate <NSObject>

- (void)testControlExpanded:(id)control;
- (void)testControlContracted:(id)control;

@end

@interface OldTestControl : UIControl

@property (nonatomic, assign) BOOL expanded;
@property (nonatomic, strong) UIButton *editButton;

- (void)setEditMode:(BOOL)editing;

@end
