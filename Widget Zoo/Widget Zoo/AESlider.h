//
//  AESlider.h
//  Custom Controls
//
//  Created by Drew on 9/27/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEControl.h"

typedef enum {
    AESliderTypeNormal,
    AESliderTypeCenterSprung,
    AESliderTypeBottomSprung
} AESliderType;

@interface AESlider : AEControl

- (id)initWithFrame:(CGRect)frame type:(AESliderType)type;

@end
