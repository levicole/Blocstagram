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

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.idNumber forKey:NSStringFromSelector(@selector(idNumber))];
    [aCoder encodeObject:self.text forKey:NSStringFromSelector(@selector(text))];
    [aCoder encodeObject:self.from forKey:NSStringFromSelector(@selector(from))];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        self.idNumber = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(idNumber))];
        self.text = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(text))];
        self.from = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(from))];
    }
    return self;
}

-(BOOL) isEqual:(id)object {
    if ([self class] == [object class]) {
        Comment *otherComment = (Comment *)object;
        BOOL idNumberEqual = [self.idNumber isEqual:otherComment.idNumber];
        BOOL textEqual     = [self.text isEqual:otherComment.text];
        BOOL fromEqual     = [self.from isEqual:otherComment.from];
        
        return idNumberEqual && textEqual && fromEqual;
    }
    
    return NO;
    
}
@end
