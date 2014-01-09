//
//  ControlPageDescriptor.h
//  Widget Zoo
//
//  Created by Drew Christensen on 1/8/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AEControl.h"

@interface PageDescriptor : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) AEControlType type;

+ (id)descriptorWithName:(NSString *)name type:(AEControlType)type;

@end
