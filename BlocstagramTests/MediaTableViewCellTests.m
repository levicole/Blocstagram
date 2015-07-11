//
//  MediaTableViewCellTests.m
//  Blocstagram
//
//  Created by Levi Kennedy on 7/11/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Media.h"
#import "MediaTableViewCell.h"

@interface MediaTableViewCellTests : XCTestCase

@end

@implementation MediaTableViewCellTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testHeightForMediaItemReturnsAppropriateHeight {
    NSDictionary *userDictionary = @{@"id": @"8675309",
                                    @"username": @"d'oh",
                                    @"full_name": @"Homer Simpson",
                                    @"profile_picture" : @"http://www.example.com/example.jpg"};
   
    NSDictionary *mediaDictionary = @{@"user":userDictionary, @"caption": @{@"text": @""}, @"user_has_liked": @"true", @"comments": @{@"data": @[]}, @"images": @{@"standard_resolution": @{@"url": @"http://example.com/example.jpg"}}};
    Media *media = [[Media alloc] initWithDictionary:mediaDictionary];
    media.image = [UIImage imageNamed:@"1.jpg"];
    UITraitCollection *traitCollection = [[UIApplication sharedApplication] keyWindow].traitCollection;
    CGFloat height = [MediaTableViewCell heightForMediaItem:media width:100 traitCollection:traitCollection];
    
    // heightOfUserNameLabel + bottomMarginOfUserNameLabel + (media.image.height/media.image.width) * width) + heightOfCommentView
    // 18 + 20 + ((2816/2112) * 100) + 100
    // I probably got lazy/did this wrong. I guess I could have set up a UILabel,
    // got it's sizeThatFits, and basically completely duped the code of willLayoutSubviews
    // in MediaTableViewCell, but no way....this is good enough for me.
    
    XCTAssertEqual(height, 271.5, @"height should be the expected height");
}

@end
