//
//  DataSource.m
//  Blocstagram
//
//  Created by Levi Kennedy on 6/8/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import "DataSource.h"
#import "User.h"
#import "Media.h"
#import "Comment.h"
#import "LoginViewController.h"
#import <UICKeychainStore.h>
#import <AFNetworking.h>

@interface DataSource() {
    NSMutableArray *_mediaItems;
}

@property (nonatomic, strong) NSArray *mediaItems;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLoadinOlderItems;
@property (nonatomic, assign) BOOL thereAreNoMoreOlderMessages;
@property (nonatomic, strong) NSString *accessToken;

@property (nonatomic, strong) AFHTTPRequestOperationManager *instagramOperationManager;
@end

@implementation DataSource

+(NSString *) instaGramClientID {
    return @"015a4cbd61824f43877dcaafff56e810";
}

+(instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
        [self createOperationManager];
        self.accessToken = [UICKeyChainStore stringForKey:@"access token"];
        if (!self.accessToken) {
            [self registerForAccessTokenNotification];
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSString *fullPath = [self pathForFilename:NSStringFromSelector(@selector(mediaItems))];
                NSArray *storedMediaItems = @[];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (storedMediaItems.count > 0) {
                        NSMutableArray *mutableMediaItems = [storedMediaItems mutableCopy];
                        [self willChangeValueForKey:@"mediaItems"];
                        self.mediaItems = mutableMediaItems;
                        [self didChangeValueForKey:@"mediaItems"];
                    } else {
                        [self populateDataWithParameters:nil completionHandler:nil];
                    }
                });
            });
        }
    }
    
    return self;
}

- (void) registerForAccessTokenNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:LoginViewControllerDidGetAccessTokenNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.accessToken = note.object;
        [UICKeyChainStore setString:self.accessToken forKey:@"access token"];
        [self populateDataWithParameters:nil completionHandler:nil];
    }];
}

- (void) populateDataWithParameters:(NSDictionary *)parameters completionHandler:(NewItemCompletionBlock)completionHandler {
    if (self.accessToken) {
        NSMutableDictionary *mutableParams = [@{@"access_token": self.accessToken} mutableCopy];
        [mutableParams addEntriesFromDictionary:parameters];
        
        [self.instagramOperationManager GET:@"users/self/feed" parameters:mutableParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Class of Response Object: %@", NSStringFromClass([responseObject class]));
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [self parseDataFromFeedDictionary:responseObject fromRequestWithParameters:parameters];
            }
            
            if (completionHandler) {
                completionHandler(nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (completionHandler) {
                completionHandler(error);
            }
        }];
    }
}

- (void) parseDataFromFeedDictionary:(NSDictionary *)feedDictionary fromRequestWithParameters:(NSDictionary *)parameters {
    NSArray *mediaArray = feedDictionary[@"data"];
    
    NSMutableArray *tmpMediaItems = [NSMutableArray array];
    
    for (NSDictionary *mediaDictionary in mediaArray) {
        Media *mediaItem = [[Media alloc] initWithDictionary:mediaDictionary];
        
        if (mediaItem) {
            [tmpMediaItems addObject:mediaItem];
        }
    }
    
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
    
    if (parameters[@"min_id"]) {
        
        NSRange rangeOfIndexes = NSMakeRange(0, tmpMediaItems.count);
        NSIndexSet *indexSetOfNewObjects = [NSIndexSet indexSetWithIndexesInRange:rangeOfIndexes];
        
        [mutableArrayWithKVO insertObjects:tmpMediaItems atIndexes:indexSetOfNewObjects];
    } else if (parameters[@"max_id"]) {
        if (tmpMediaItems.count == 0) {
            self.thereAreNoMoreOlderMessages = YES;
        } else {
            [mutableArrayWithKVO addObjectsFromArray:tmpMediaItems];
        }
    } else {
        [self willChangeValueForKey:@"mediaItems"];
        self.mediaItems = tmpMediaItems;
        [self didChangeValueForKey:@"mediaItems"];
    }
    [self saveImages];
}

- (void) saveImages {
    if (self.mediaItems.count > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSUInteger numberOfItemsToSave = MIN(self.mediaItems.count, 50);
            NSArray *mediaItemsToSave = [self.mediaItems subarrayWithRange:NSMakeRange(0, numberOfItemsToSave)];
            
            
            NSString *fullPath = [self pathForFilename:NSStringFromSelector(@selector(mediaItems))];
            NSData *mediaItemData = [NSKeyedArchiver archivedDataWithRootObject:mediaItemsToSave];
            
            NSError *dataError;
            BOOL wroteSuccessfully = [mediaItemData writeToFile:fullPath options:NSDataWritingAtomic | NSDataWritingFileProtectionComplete error:&dataError];
            if (!wroteSuccessfully) {
                NSLog(@"Couldn't write file: %@", dataError);
            }
            
        });
    }
}

- (void) downloadImageForMediaItem:(Media *)mediaItem {
    if (mediaItem.mediaURL && !mediaItem.image) {
        mediaItem.downloadState = MediaDownloadStateDownloadInProgress;

        [self.instagramOperationManager GET:mediaItem.mediaURL.absoluteString parameters:nil
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        if ([responseObject isKindOfClass:[UIImage class]]) {
                                            mediaItem.image = responseObject;
                                            mediaItem.downloadState = MediaDownloadStateHasImage;
                                            NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
                                            NSUInteger index = [mutableArrayWithKVO indexOfObject:mediaItem];
                                            [mutableArrayWithKVO replaceObjectAtIndex:index withObject:mediaItem];
                                            [self saveImages];
                                            
                                        } else {
                                            mediaItem.downloadState = MediaDownloadStateNonRecoverableError;
                                        }
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        NSLog(@"Error Downloading image: %@", error);
                                        mediaItem.downloadState = MediaDownloadStateNonRecoverableError;
                                        
                                        if ([error.domain isEqualToString:NSURLErrorDomain]) {
                                            if (error.code == NSURLErrorTimedOut ||
                                                error.code == NSURLErrorCancelled ||
                                                error.code == NSURLErrorCannotConnectToHost ||
                                                error.code == NSURLErrorNetworkConnectionLost ||
                                                error.code == NSURLErrorNotConnectedToInternet ||
                                                error.code == kCFURLErrorInternationalRoamingOff ||
                                                error.code == kCFURLErrorCallIsActive ||
                                                error.code == kCFURLErrorDataNotAllowed ||
                                                error.code == kCFURLErrorRequestBodyStreamExhausted) {
                                                mediaItem.downloadState = MediaDownloadStateNeedsImage;
                                            }
                                        }
                                    }];
    }
}

- (void) toggleLikeOnMediaItem:(Media *)mediaItem withCompletionHandler:(void (^)(void))completionHandler {
    if (mediaItem.likeState == LikeStateNotLiked) {
        mediaItem.likeState = LikeStateLiking;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            mediaItem.likeState = LikeStateLiked;
            
            if (completionHandler) {
                completionHandler();
            }
        });
        
    } else if (mediaItem.likeState == LikeStateLiked) {
        mediaItem.likeState = LikeStateUnliking;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            mediaItem.likeState = LikeStateNotLiked;
            
            if (completionHandler) {
                completionHandler();
            }
        });
    }
}

- (void) commentOnMediaItem:(Media *)mediaItem withCommentText:(NSString *)commentText {
    if (!commentText || commentText.length == 0) {
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"media/%@/comments", mediaItem.idNumber];
    NSDictionary *parameters = @{@"access_token": self.accessToken, @"text": commentText};
    
    [self.instagramOperationManager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        mediaItem.temporaryComment = nil;
        NSString *refreshMediaUrlString = [NSString stringWithFormat:@"media/%@", mediaItem.idNumber];
        NSDictionary *parameters = @{@"access_token": self.accessToken};
        [self.instagramOperationManager GET:refreshMediaUrlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            Media *newMediaItem = [[Media alloc] initWithDictionary:responseObject];
            NSMutableArray *mutabalArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
            NSUInteger index = [mutabalArrayWithKVO indexOfObject:mediaItem];
            [mutabalArrayWithKVO replaceObjectAtIndex:index withObject:newMediaItem];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self reloadMediaItem:mediaItem];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Error: %@", error);
        NSLog(@"Response: %@", operation.responseObject);
        [self reloadMediaItem:mediaItem];
    }];
}

- (void) reloadMediaItem:(Media *)mediaItem {
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
    NSUInteger index = [mutableArrayWithKVO indexOfObject:mediaItem];
    [mutableArrayWithKVO replaceObjectAtIndex:index withObject:mediaItem];
}

- (void) requestNewItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler {
    self.thereAreNoMoreOlderMessages = NO;
    if (self.isRefreshing == NO) {
        self.isRefreshing = YES;
        
        NSString *minID = [[self.mediaItems firstObject] idNumber];
        NSDictionary *parameters;
        
        if (minID) {
            parameters = @{@"min_id": minID};
        }
        
        [self populateDataWithParameters:parameters completionHandler:^(NSError *error) {
            self.isRefreshing = NO;
            
            if (completionHandler) {
                completionHandler(nil);
            }
        }];
    }
}

- (void) requestOldItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler {
    if (self.isLoadinOlderItems == NO && self.thereAreNoMoreOlderMessages == NO) {
        self.isLoadinOlderItems = YES;
        
        //TODO: Add images
        NSString *maxID = [[self.mediaItems lastObject] idNumber];
        NSDictionary *parameters;
        
        if (maxID) {
            parameters = @{@"max_id": maxID};
        }
        [self populateDataWithParameters:parameters completionHandler:^(NSError *error) {
            self.isLoadinOlderItems = NO;
            
            if (completionHandler) {
                completionHandler(nil);
            }
        }];
    }
}

- (void) createOperationManager {
    NSURL *baseUrl = [NSURL URLWithString:@"https://api.instagram.com/v1/"];
    
    self.instagramOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    
    AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
    AFImageResponseSerializer *imageSerializer = [AFImageResponseSerializer serializer];
    imageSerializer.imageScale = 1.0;
    
    AFCompoundResponseSerializer *compoundSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[jsonSerializer, imageSerializer]];
    
    self.instagramOperationManager.responseSerializer = compoundSerializer;
}

#pragma mark - Key/Value Observing

- (NSUInteger) countOfMediaItems {
    return self.mediaItems.count;
}

- (id) objectInMediaItemsAtIndex:(NSUInteger)index {
    return [self.mediaItems objectAtIndex:index];
}

- (NSArray *) mediaItemsAtIndexes:(NSIndexSet *)indexes {
    return [self.mediaItems objectsAtIndexes:indexes];
}

- (void) insertObject:(Media *)object inMediaItemsAtIndex:(NSUInteger)index {
    [_mediaItems insertObject:object atIndex:index];
}

- (void) removeObjectFromMediaItemsAtIndex:(NSUInteger)index {
    [_mediaItems removeObjectAtIndex:index];
}

- (void) replaceObjectInMediaItemsAtIndex:(NSUInteger)index withObject:(id)object {
    [_mediaItems replaceObjectAtIndex:index withObject:object];
}

- (void) deleteMediaItem:(Media *)item {
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
    [mutableArrayWithKVO removeObject:item];
}

- (NSString *) pathForFilename:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    return dataPath;
}
@end
