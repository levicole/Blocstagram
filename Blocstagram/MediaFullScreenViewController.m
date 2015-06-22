//
//  MediaFullScreenViewController.m
//  Blocstagram
//
//  Created by Levi Kennedy on 6/20/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import "MediaFullScreenViewController.h"
#import "Media.h"

@interface MediaFullScreenViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) Media *media;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation MediaFullScreenViewController

- (instancetype) initWithMedia:(Media *)media {
    self = [super init];
    if (self) {
        self.media = media;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [UIScrollView new];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    
    self.imageView = [UIImageView new];
    self.imageView.image = self.media.image;
    
    [self.scrollView addSubview:self.imageView];
    
    self.scrollView.contentSize = self.media.image.size;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(tapFired:)];
    self.tap = tap;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] init];
    [doubleTap addTarget:self action:@selector(doubleTapFired:)];
    doubleTap.numberOfTapsRequired = 2;
    self.doubleTap = doubleTap;
    
    [self.tap requireGestureRecognizerToFail:doubleTap];
    
    [self.scrollView addGestureRecognizer:self.tap];
    [self.scrollView addGestureRecognizer:self.doubleTap];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.shareButton.backgroundColor = [UIColor whiteColor];
    self.shareButton.layer.cornerRadius = 5;
    
    [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [self.shareButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.shareButton];
    [self.shareButton addTarget:self action:@selector(doShare) forControlEvents:UIControlEventTouchUpInside];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.shareButton.titleLabel sizeToFit];
    CGSize shareButtonTitleLabelSize = self.shareButton.titleLabel.frame.size;
    
    self.shareButton.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - shareButtonTitleLabelSize.width - 40, 40, shareButtonTitleLabelSize.width + 20, shareButtonTitleLabelSize.height + 10);
    
    self.scrollView.frame = self.view.bounds;
    
    CGSize scrollViewFrameSize = self.scrollView.frame.size;
    CGSize contentSize    = self.scrollView.contentSize;
    
    
    //    this is what I originally did.
    //    CGFloat heightScale = CGRectGetHeight(self.scrollView.frame)/self.media.image.size.height;
    //    CGFloat widthScale  = CGRectGetWidth(self.scrollView.frame)/self.media.image.size.width;
    
    CGFloat heightScale = scrollViewFrameSize.height/contentSize.height;
    CGFloat widthScale  = scrollViewFrameSize.width/contentSize.width;
    
    self.scrollView.minimumZoomScale = MIN(heightScale, widthScale);
    self.scrollView.maximumZoomScale = 1;
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self centerScrollView];
}

- (void) centerScrollView {
    [self.imageView sizeToFit];
    
    
    // get the size of each element
    CGSize boundsSize     = self.scrollView.bounds.size;
    CGRect imageViewFrame = self.imageView.frame;
    
    if (boundsSize.width > imageViewFrame.size.width) {
        imageViewFrame.origin.x = (boundsSize.width - CGRectGetWidth(imageViewFrame))/2;
    } else {
        imageViewFrame.origin.x = 0;
    }
    
    if (boundsSize.height > imageViewFrame.size.height) {
        imageViewFrame.origin.y = (boundsSize.height - CGRectGetHeight(imageViewFrame))/2;
    } else {
        imageViewFrame.origin.y = 0;
    }
    
    self.imageView.frame = imageViewFrame;
}

#pragma mark - UIScrollViewDelegate

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollView];
}

#pragma mark - Gesture Recognizers

- (void) tapFired:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) doubleTapFired:(UITapGestureRecognizer *)sender {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        // had to look this one up
        CGPoint locationPoint = [sender locationInView:self.imageView];
        CGSize scrollViewSize = self.scrollView.bounds.size;
        
        CGFloat width = scrollViewSize.width / self.scrollView.maximumZoomScale;
        CGFloat height = scrollViewSize.height / self.scrollView.maximumZoomScale;
        CGFloat x = locationPoint.x - (width/2);
        CGFloat y = locationPoint.y - (height/2);
        
        [self.scrollView zoomToRect:CGRectMake(x, y, width, height) animated:YES];
    } else {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

#pragma mark - misc

-(void) doShare {
    NSMutableArray *itemsToShare = [NSMutableArray array];
    if (self.media.caption.length > 0) {
        [itemsToShare addObject:self.media.caption];
    }
    
    if (self.media.image) {
        [itemsToShare addObject:self.media.image];
    }
    
    if (itemsToShare.count > 0) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}
@end
