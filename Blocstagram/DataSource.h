//
//  DataSource.h
//  Blocstagram
//
//  Created by Levi Kennedy on 6/8/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject
+(instancetype) sharedInstance;
@property (nonatomic, strong, readonly) NSArray *mediaItems;
@end
