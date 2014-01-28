//
//  Post.m
//  CSH News
//
//  Created by Harlan Haskins on 1/26/14.
//  Copyright (c) 2014 Haskins. All rights reserved.
//

#import "Post.h"
#import "ISO8601DateFormatter.h"
#import "WebNewsDataHandler.h"

@interface Post ()

@property (nonatomic, readwrite) NSString *newsgroup;
@property (nonatomic, readwrite) NSString *subject;
@property (nonatomic, readwrite) NSString *authorName;
@property (nonatomic, readwrite) NSString *authorEmail;
@property (nonatomic, readwrite) NSString *stickyUserName;
@property (nonatomic, readwrite) NSString *stickyRealName;
@property (nonatomic, readwrite) NSString *parentNewsgroup;
@property (nonatomic, readwrite) NSString *followUpNewsgroup;
@property (nonatomic, readwrite) NSString *body;
@property (nonatomic, readwrite) NSString *headers;

@property (nonatomic, readwrite) NSDate *date;
@property (nonatomic, readwrite) NSDate *stickyUntilDate;

@property (nonatomic, readwrite) NSInteger number;

@property (nonatomic, readwrite) PersonalClass personalClass;

@property (nonatomic, readwrite, getter = isStarred) BOOL starred;
@property (nonatomic, readwrite, getter = isOrphaned) BOOL orphaned;
@property (nonatomic, readwrite, getter = isStripped) BOOL stripped;
@property (nonatomic, readwrite, getter = isReparented) BOOL reparented;

@end

@implementation Post

- (void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.newsgroup forKey:@"newsgroup"];
    [coder encodeObject:self.subject forKey:@"subject"];
    [coder encodeObject:self.authorName forKey:@"authorName"];
    [coder encodeObject:self.authorEmail forKey:@"authorEmail"];
    [coder encodeObject:self.stickyUserName forKey:@"stickyUserName"];
    [coder encodeObject:self.stickyRealName forKey:@"stickyRealName"];
    [coder encodeObject:self.parentNewsgroup forKey:@"parentNewsgroup"];
    [coder encodeObject:self.followUpNewsgroup forKey:@"followUpNewsgroup"];
    [coder encodeObject:self.body forKey:@"body"];
    [coder encodeObject:self.headers forKey:@"headers"];
    
    [coder encodeObject:self.date forKey:@"date"];
    [coder encodeObject:self.stickyUntilDate forKey:@"stickyUntilDate"];
    
    [coder encodeObject:@(self.number) forKey:@"number"];
    
    [coder encodeObject:@(self.personalClass) forKey:@"personalClass"];
    
    [coder encodeObject:@(self.starred) forKey:@"starred"];
    [coder encodeObject:@(self.orphaned) forKey:@"orphaned"];
    [coder encodeObject:@(self.stripped) forKey:@"stripped"];
    [coder encodeObject:@(self.reparented) forKey:@"reparented"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.newsgroup = [decoder decodeObjectForKey:@"newsgroup"];
        self.subject = [decoder decodeObjectForKey:@"subject"];
        self.authorName = [decoder decodeObjectForKey:@"authorName"];
        self.authorEmail = [decoder decodeObjectForKey:@"authorEmail"];
        self.stickyUserName = [decoder decodeObjectForKey:@"stickyUserName"];
        self.stickyRealName = [decoder decodeObjectForKey:@"stickyRealName"];
        self.parentNewsgroup = [decoder decodeObjectForKey:@"parentNewsgroup"];
        self.followUpNewsgroup = [decoder decodeObjectForKey:@"followUpNewsgroup"];
        self.body = [decoder decodeObjectForKey:@"body"];
        self.headers = [decoder decodeObjectForKey:@"headers"];
        
        self.date = [decoder decodeObjectForKey:@"date"];
        self.stickyUntilDate = [decoder decodeObjectForKey:@"stickyUntilDate"];
        
        self.number = [[decoder decodeObjectForKey:@"number"] integerValue];
        
        self.personalClass = [[decoder decodeObjectForKey:@"personalClass"] integerValue];
        
        self.starred = [[decoder decodeObjectForKey:@"starred"] boolValue];
        self.orphaned = [[decoder decodeObjectForKey:@"orphaned"] boolValue];
        self.stripped = [[decoder decodeObjectForKey:@"stripped"] boolValue];
        self.reparented = [[decoder decodeObjectForKey:@"reparented"] boolValue];
    }
    return self;
}

+ (instancetype) postwithDictionary:(NSDictionary*)postDictionary {
    
    if (!postDictionary || [postDictionary isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    Post *post = [Post new];
    
    post.newsgroup = postDictionary[@"newsgroup"];
    post.subject = postDictionary[@"subject"];
    post.authorName = postDictionary[@"author_name"];
    post.authorEmail = postDictionary[@"author_email"];
    
    ISO8601DateFormatter *dateFormatter = [[ISO8601DateFormatter alloc] init];
    post.date = [dateFormatter dateFromString:postDictionary[@"date"]];
    post.stickyUntilDate = [dateFormatter dateFromString:postDictionary[@"sticky_until"]];
    
    post.number = [postDictionary[@"number"] integerValue];
    
    post.personalClass = [self personalClassFromString:postDictionary[@"personal_class"]];
    
    post.body = postDictionary[@"body"];
    
    post.headers = postDictionary[@"headers"];
    
    post.stripped = [postDictionary[@"stripped"] boolValue];
    
    post.orphaned = [postDictionary[@"orphaned"] boolValue];
    
    post.reparented = [postDictionary[@"reparented"] boolValue];
    
    post.starred = [postDictionary[@"starred"] boolValue];
    
    NSDictionary *stickyUser = postDictionary[@"sticky_user"];
    post.stickyUserName = stickyUser[@"username"];
    post.stickyRealName = stickyUser[@"real_name"];
    
    return post;
}

+ (PersonalClass) personalClassFromString:(NSString*)string {
    if ([string isKindOfClass:[NSNull class]]) {
        return PersonalClassDefault;
    }
    else if ([string isEqualToString:@"mine_reply"]) {
        return PersonalClassReplyToMine;
    }
    else if ([string isEqualToString:@"mine_in_thread"]) {
        return PersonalClassInThreadWithMine;
    }
    else if ([string isEqualToString:@"mine"]) {
        return PersonalClassMine;
    }
    return PersonalClassDefault;
}

- (NSString*) dateString {
    
    // Create an empty formatter.
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    // Set the date format to a nice format.
    [dateFormatter setDateFormat:@"yyyy-MM-d"];
    
    // Create the subtitle from those components.
    return [dateFormatter stringFromDate:self.date];
}

- (NSString *) timeString {
    // Create an empty formatter.
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    // Set the date format to a nice format.
    [dateFormatter setDateFormat:@"hh:mm:sa"];
    
    // Create the subtitle from those components.
    return [dateFormatter stringFromDate:self.date];
}

- (NSString*) friendlyDate {
    
    NSString *time = [self timeString];
    NSString *date = [self dateString];
    NSString *friendlyString = [NSString stringWithFormat:@"%@ at %@", date, time];
    
    return friendlyString;
}

- (NSString *) authorshipAndTimeString {
    return [NSString stringWithFormat:@"by %@ on %@", self.authorName, [self friendlyDate]];
}

- (UIColor*) subjectColor {
    NSArray *colors = @[[UIColor colorWithRed:0.953 green:0.268 blue:0.935 alpha:1.000],
                        [UIColor colorWithRed:0.000 green:0.814 blue:0.000 alpha:1.000],
                        [UIColor colorWithRed:0.415 green:0.000 blue:0.414 alpha:1.000],
                        [UIColor blackColor]];
    
    return colors[self.personalClass];
}

@end

@interface PostCell ()

@property (nonatomic, readwrite) Post *post;

@end

@implementation PostCell

+ (instancetype) cellWithPost:(Post*)post level:(NSInteger)level
{
    PostCell *cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self cellIdentifier]];
    cell.post = post;
    
    cell.textLabel.textColor = [post subjectColor];
    
    NSString *parameters = [NSString stringWithFormat:@"%@%@/%i",kBaseURLFormat, post.newsgroup, post.number];
    
    [WebNewsDataHandler runHTTPOperationWithParameters:parameters success:^(AFHTTPRequestOperation *op, id response) {
        cell.post = response;
    } failure:nil];
    
    cell.textLabel.text = cell.post.subject;
    cell.detailTextLabel.text = [cell.post authorshipAndTimeString];
    return cell;
}

+ (NSString*) cellIdentifier {
    return @"PostCell";
}

@end
