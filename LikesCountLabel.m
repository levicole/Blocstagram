//
//  LikesCountLabel.m
//  Blocstagram
//
//  Created by Levi Kennedy on 6/26/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import "LikesCountLabel.h"

@implementation LikesCountLabel

- (void) drawTextInRect:(CGRect)rect {
//    CGSize sizeThatFits = [self sizeThatFits:rect.size];
//    
//    rect.size.height = sizeThatFits.height;
//    [super drawTextInRect:rect];
    CGPoint rectOrigin = CGPointMake(self.bounds.origin.x, self.bounds.origin.y + 8);
    CGRect textRect = CGRectMake(rectOrigin.x, rectOrigin.y, 25, 25);
    [super drawTextInRect:textRect];
}

@end
