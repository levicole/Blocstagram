//
//  DataSource.h
//  Blocstagram
//
//  Created by Levi Kennedy on 6/8/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Media;

typedef void (^NewItemCompletionBlock)(NSError *error);
@interface DataSource : NSObject

+(instancetype) sharedInstance;
+(NSString *)instaGramClientID;

@property (nonatomic, strong, readonly) NSArray *mediaItems;
@property (nonatomic, strong, readonly) NSString *accessToken;

- (void) deleteMediaItem:(Media *)item;

- (void) requestNewItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler;
- (void) requestOldItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler;

- (void) downloadImageForMediaItem:(Media *)mediaItem;
@end
