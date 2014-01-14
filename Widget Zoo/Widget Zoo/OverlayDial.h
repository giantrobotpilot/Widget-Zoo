//
//  OverlayDial.h
//  Widget Zoo
//
//  Created by Drew Christensen on 1/14/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "AEControl.h"
#import "TestControl.h"

@interface OverlayDial : AEControl

@property (nonatomic, assign) BOOL expanded;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, weak) id<TestControlDelegate> delegate;

- (void)setEditMode:(BOOL)editing;

@end
