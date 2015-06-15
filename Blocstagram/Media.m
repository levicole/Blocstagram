//
//  Media.m
//  Blocstagram
//
//  Created by Levi Kennedy on 6/8/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import "Media.h"
#import "User.h"
#import "Comment.h"

@implementation Media

- (instancetype) initWithDictionary:(NSDictionary *)mediaDictionary {
    self = [super init];
    
    if (self) {
        self.idNumber = mediaDictionary[@"id"];
        self.user     = [[User alloc] initWithDictionary:mediaDictionary[@"user"]];
        NSString *standardResolutionString = mediaDictionary[@"images"][@"standard_resolution"][@"url"];
        NSURL *standardResolutionURL       = [NSURL URLWithString:standardResolutionString];
        
        if (standardResolutionURL) {
            self.mediaURL = standardResolutionURL;
        }
        
        NSDictionary *captionDicionary = mediaDictionary[@"caption"];
        
        if ([captionDicionary isKindOfClass:[NSDictionary class]]) {
            self.caption = captionDicionary[@"text"];
        } else {
            self.caption = @"";
        }
        
        NSMutableArray *commentsArray = [NSMutableArray array];
        
        for (NSDictionary *commentDictionary in mediaDictionary[@"comments"][@"data"]) {
            Comment *comment = [[Comment alloc] initWithDictionary:commentDictionary];
            [commentsArray addObject:comment];
        }
        
        self.comments = commentsArray;
    }
    
    return self;
}

@end
