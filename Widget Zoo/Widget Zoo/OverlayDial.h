//
//  OverlayDial.h
//  Widget Zoo
//
//  Created by Drew Christensen on 1/14/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "AEControl.h"
#import "OldTestControl.h"

@interface OverlayDial : AEControl

@property (nonatomic, assign) BOOL expanded;
@property (nonatomic, weak) id<TestControlDelegate> delegate;

@end
