//
//  PostViewController.h
//  CSH WebNews
//
//  Created by Harlan Haskins on 9/20/13.
//  Copyright (c) 2013 Haskins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebNewsDataHandler.h"
#import "APIKeyViewController.h"

@interface ThreadsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, WebNewsDataHandlerProtocol, APIKeyDelegate>

@property (strong, nonatomic) NSDictionary *parentPost;
@property (strong, nonatomic) NSArray *data;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSString *pathString;
@property (nonatomic) NSString *number;
@property (nonatomic) NSDate *lastUpdated;

- (instancetype) initWithParentPost:(NSDictionary*) parentPost;
@end