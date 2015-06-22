//
//  MediaFullScreenViewController.h
//  Blocstagram
//
//  Created by Levi Kennedy on 6/20/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media;

@interface MediaFullScreenViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView  *imageView;

- (instancetype) initWithMedia:(Media *)media;
- (void) centerScrollView;
@end
