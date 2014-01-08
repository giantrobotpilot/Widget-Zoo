//
//  AEHorizontalSprungWeight.h
//  Atoms User App
//
//  Created by Drew on 10/15/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AESprungWeight.h"

typedef enum {
    AEHorizontalWeightTypeSprungLeft,
    AEHorizontalWeightTypeSprungRight
} AEHorizontalWeightType;

@interface AEHorizontalSprungWeight : AESprungWeight

- (id)initWithType:(AEHorizontalWeightType)type;

@end
