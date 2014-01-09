//
//  ControlPageDescriptor.m
//  Widget Zoo
//
//  Created by Drew Christensen on 1/8/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import "PageDescriptor.h"

@implementation PageDescriptor

- (id)initWithName:(NSString *)name type:(AEControlType)type {
    self = [super init];
    if (self) {
        _name = name;
        _type = type;
    }
    return self;
}

+ (id)descriptorWithName:(NSString *)name type:(AEControlType)type {
    return [[PageDescriptor alloc] initWithName:name type:type];
}

@end
