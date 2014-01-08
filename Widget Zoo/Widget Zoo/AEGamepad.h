//
//  AEGamepad.h
//  Custom Controls
//
//  Created by Drew on 9/30/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEControl.h"

static const NSInteger kNeutralSmartValue = 0;
static const NSInteger kUpSmartValue = 1;
static const NSInteger kRightSmartValue = 2;
static const NSInteger kDownSmartValue = 3;
static const NSInteger kLeftSmartValue = 4;
static const NSInteger kUpRightSmartValue = 5;
static const NSInteger kUpLeftSmartValue = 6;
static const NSInteger kDownRightSmartValue = 7;
static const NSInteger kDownLeftSmartValue = 8;

@interface AEGamepad : AEControl

@property (nonatomic, assign) NSInteger dirValue;

@end
