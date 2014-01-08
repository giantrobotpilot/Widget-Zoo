//
//  AEHorizontalLeveler.h
//  Custom Controls
//
//  Created by Drew on 9/30/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AELeveler.h"

typedef enum {
    AEHorizontalLevelTypeUnsprung,
    AEHorizontalLevelTypeRightSprung,
    AEHorizontalLevelTypeLeftSprung
} AEHorizontalLevelType;

@interface AEHorizontalLeveler : AELeveler

- (id)init;

@end
