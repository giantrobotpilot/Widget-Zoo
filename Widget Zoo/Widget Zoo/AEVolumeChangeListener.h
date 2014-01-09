//
//  AEVolumeChangeListener.h
//  stc.iOSWidgets
//
//  Created by Ian Morris Nieves on 8/5/13.
//  Copyright (c) 2013 Ian Morris Nieves. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AEVolumeChangeListener
- (void) appVolumeChangedExternallyToPercent:(float)volumePercent;
@end
