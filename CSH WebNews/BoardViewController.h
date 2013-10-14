//
//  BoardViewController.h
//  CSH WebNews
//
//  Created by Harlan Haskins on 9/20/13.
//  Copyright (c) 2013 Haskins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebNewsDataHandler.h"
#import "APIKeyViewController.h"

@interface BoardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, WebNewsDataHandlerProtocol, APIKeyDelegate>

@property (strong, nonatomic) NSArray *data;
@property (nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSString *pathString;
@property (strong, nonatomic) NSDictionary *specialParameters;
@property (nonatomic) NSDate *lastUpdated;

- (id)initWithTitle:(NSString*)title;

@end
