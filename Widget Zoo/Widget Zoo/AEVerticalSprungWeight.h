//
//  AEVerticalSprungWeight.h
//  Atoms User App
//
//  Created by Drew on 10/15/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AESprungWeight.h"

typedef enum {
    AEVerticalWeightSprungTop,
    AEVerticalWeightSprungBottom
} AEVerticalWeightType;

@interface AEVerticalSprungWeight : AESprungWeight

- (id)initWithType:(AEVerticalWeightType)type;

@end
