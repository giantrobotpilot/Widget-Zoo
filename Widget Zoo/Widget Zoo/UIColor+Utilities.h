//
//  UIColor+Utilities.h
//  Sounds True Library
//
//  Created by Drew Christensen on 5/16/13.
//  Copyright (c) 2013 Quick Left. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utilities)

- (NSString *) stringFromColor;
- (NSString *) hexStringFromColor;
+ (UIColor *) colorWithString: (NSString *) stringToConvert;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

@end
