//
//  ImageLibraryViewController.h
//  Blocstagram
//
//  Created by Levi Kennedy on 6/29/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageLibraryViewController;

@protocol ImageLibraryViewControllerDelegate <NSObject>

- (void) imageLibraryViewController:(ImageLibraryViewController *)imageLibraryViewController didCompleteWithImage:(UIImage *) image;

@end

@interface ImageLibraryViewController : UICollectionViewController

@property (nonatomic, weak) NSObject <ImageLibraryViewControllerDelegate> *delegate;

@end
