//
//  NewsgroupThreadsViewController.h
//  CSH News
//
//  Created by Harlan Haskins on 1/28/14.
//  Copyright (c) 2014 Haskins. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsgroupOutline;

@interface NewsgroupThreadsViewController : UITableViewController

+ (instancetype) threadListWithNewsgroupOutline:(NewsgroupOutline*)outline;

@end
