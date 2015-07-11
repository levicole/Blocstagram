//
//  MediaTests.m
//  Blocstagram
//
//  Created by Levi Kennedy on 7/10/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "User.h"
#import "Media.h"
#import "Comment.h"

@interface MediaTests : XCTestCase

@end

@implementation MediaTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testThatInitializerWorks {
    NSDictionary *userDictionary = @{@"id": @"8675309",
                                    @"username": @"d'oh",
                                    @"full_name": @"Homer Simpson",
                                    @"profile_picture" : @"http://www.example.com/example.jpg"};
    NSDictionary *commentUserDictionary = @{@"id": @"8675309",
                                            @"username": @"d'oh",
                                            @"full_name": @"Marge",
                                            @"profile_picture" : @"http://www.example.com/example.jpg"};
    
    User *mediaUser   = [[User alloc] initWithDictionary:userDictionary];
   
    NSDictionary *commentDictionary = @{@"id": @"1234", @"text": @"I love duff", @"from": commentUserDictionary};
    NSDictionary *mediaDictionary = @{@"user":userDictionary, @"caption": @{@"text": @"I love duff beer"}, @"user_has_liked": @"true", @"comments": @{@"data": @[commentDictionary]}, @"images": @{@"standard_resolution": @{@"url": @"http://example.com/example.jpg"}}};
    
    Media *mediaToTest = [[Media alloc] initWithDictionary:mediaDictionary];
    Comment *mediaComment = [[Comment alloc] initWithDictionary:commentDictionary];
    
    XCTAssertEqual(mediaToTest.likeState, LikeStateLiked, @"Media should be liked");
    XCTAssertEqualObjects(mediaToTest.user, mediaUser, @"Media user should be equal");
    XCTAssertEqualObjects(mediaToTest.comments, @[mediaComment]);
    XCTAssertEqualObjects(mediaToTest.mediaURL, [NSURL URLWithString:mediaDictionary[@"images"][@"standard_resolution"][@"url"]], @"Media URL should match");
}

@end
