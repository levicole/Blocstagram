//
//  User.m
//  Blocstagram
//
//  Created by Levi Kennedy on 6/8/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype) initWithDictionary:(NSDictionary *)userDictionary {
    self = [super init];
    
    if (self) {
        self.idNumber = userDictionary[@"id"];
        self.userName = userDictionary[@"username"];
        self.fullName = userDictionary[@"full_name"];
        
        NSString *profileURLString = userDictionary[@"profile_picture"];
        NSURL *profileURL = [NSURL URLWithString:profileURLString];
        
        if (profileURL) {
            self.profilePictureURL = profileURL;
        }
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.idNumber forKey:NSStringFromSelector(@selector(idNumber))];
    [aCoder encodeObject:self.userName forKey:NSStringFromSelector(@selector(userName))];
    [aCoder encodeObject:self.fullName forKey:NSStringFromSelector(@selector(fullName))];
    [aCoder encodeObject:self.profilePictureURL forKey:NSStringFromSelector(@selector(profilePictureURL))];
    [aCoder encodeObject:self.profilePicture forKey:NSStringFromSelector(@selector(profilePicture))];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.idNumber = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(idNumber))];
        self.userName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(userName))];
        self.fullName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(fullName))];
        self.profilePictureURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(profilePictureURL))];
        self.profilePicture = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(profilePicture))];
    }
    return self;
}

- (BOOL) isEqual:(id)object {
    NSLog(@"Object Class: %@ self class %@", NSStringFromClass([object class]), NSStringFromClass([self class]));
    if ([object class] == [self class]) {
        User *otherUser = (User *)object;
        BOOL idNumberEqual = [self.idNumber isEqual:otherUser.idNumber];
        BOOL userNameEqual = [self.userName isEqual:otherUser.userName];
        BOOL fullNameEqual = [self.fullName isEqual:otherUser.fullName];
        BOOL profilePictureUrlEqual = [self.profilePictureURL isEqual:otherUser.profilePictureURL];
        return idNumberEqual && userNameEqual && fullNameEqual && profilePictureUrlEqual;
    }
    return NO;
}
@end
