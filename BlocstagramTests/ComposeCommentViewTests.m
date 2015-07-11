//
//  ComposeCommentViewTests.m
//  Blocstagram
//
//  Created by Levi Kennedy on 7/10/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ComposeCommentView.h"

@interface ComposeCommentViewTests : XCTestCase

@end

@implementation ComposeCommentViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testThatSetTextSetsIsWriting {
    ComposeCommentView *cv = [[ComposeCommentView alloc] init];
    
    [cv setText:@"I'm writing"];
    XCTAssertEqual(cv.isWritingComment, YES, @"Should be writing comment");
    [cv setText:@""];
    XCTAssertEqual(cv.isWritingComment, NO, @"Should not be writing comment");
}
@end
