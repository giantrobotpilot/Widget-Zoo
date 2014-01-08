//
//  AEMasterViewController.h
//  Widget Zoo
//
//  Created by Drew Christensen on 1/8/14.
//  Copyright (c) 2014 Seamless Toy Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AEDetailViewController;

@interface AEMasterViewController : UITableViewController

@property (strong, nonatomic) AEDetailViewController *detailViewController;

@end
