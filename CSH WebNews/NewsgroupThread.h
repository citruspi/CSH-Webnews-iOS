//
//  NewsgroupThreads.h
//  CSH News
//
//  Created by Harlan Haskins on 1/28/14.
//  Copyright (c) 2014 Haskins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHPostProtocol.h"

@class Post;

@interface NewsgroupThread : NSObject<NSCoding, HHPostProtocol>

@property (nonatomic, readonly) Post *post;

@property (nonatomic, readonly) NSMutableArray *allPosts;
@property (nonatomic, readonly) NSMutableArray *allThreads;

+ (instancetype) newsgroupThreadWithDictionary:(NSDictionary*)dictionary;

@end

@interface NewsgroupThreadCell : UITableViewCell

+ (instancetype) cellWithNewsgroupThread:(NewsgroupThread*)thread reuseIdentifier:(NSString*)cellIdentifier;

@end