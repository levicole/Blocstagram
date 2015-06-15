//
//  Comment.m
//  Blocstagram
//
//  Created by Levi Kennedy on 6/8/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import "Comment.h"
#import "User.h"

@implementation Comment

-(instancetype) initWithDictionary:(NSDictionary *)commentDictionary {
    self = [super init];
    
    if (self) {
        self.idNumber = commentDictionary[@"id"];
        self.text     = commentDictionary[@"text"];
        self.from     = [[User alloc] initWithDictionary:commentDictionary[@"from"]];
    }
    
    return self;
}
@end
