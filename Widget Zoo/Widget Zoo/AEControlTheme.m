//
//  AEControlTheme.m
//  Atoms User App
//
//  Created by Drew on 10/5/13.
//  Copyright (c) 2013 Atoms-Express. All rights reserved.
//

#import "AEControlTheme.h"
#import "AEAtomsControlTheme.h"
#import "AEColorCodedControlTheme.h"

@implementation AEControlTheme

+ (id <AEControlThemeDelegate>)currentTheme
{
    return [AEControlTheme colorCodedTheme];
}

+ (id <AEControlThemeDelegate>)atomsTheme
{
    static dispatch_once_t onceToken;
    static AEAtomsControlTheme *sharedInstace = nil;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[AEAtomsControlTheme alloc] init];
    });
    return sharedInstace;
}

+ (AEColorCodedControlTheme *)colorCodedTheme
{
    static dispatch_once_t onceToken;
    static AEColorCodedControlTheme *sharedInstace = nil;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[AEColorCodedControlTheme alloc] init];
    });
    return sharedInstace;
}

@end