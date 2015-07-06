//
//  FilterViewCell.m
//  Blocstagram
//
//  Created by Levi Kennedy on 7/5/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import "FilterViewCell.h"

@interface FilterViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel     *filterLabel;
//@property (nonatomic, strong) CALayer     *bottomBorder;

@end

@implementation FilterViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageView   = [[UIImageView alloc] init];
        self.filterLabel = [[UILabel alloc] init];
        // see the notes at the bottom of the file...
        // self.bottomBorder = [CALayer layer];
        // self.bottomBorder.backgroundColor = [UIColor colorWithRed:0.345 green:0.318 blue:0.424 alpha:1].CGColor;
        
        self.backgroundColor = [UIColor whiteColor];
        self.imageView.backgroundColor = [UIColor whiteColor];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.filterLabel.textAlignment = NSTextAlignmentCenter;
        self.filterLabel.backgroundColor = [UIColor whiteColor];
        self.filterLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:10];
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.filterLabel];
    }
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    
    self.imageView.frame = CGRectMake(0, 0, width, width);
    self.filterLabel.frame = CGRectMake(0, width, width, 20);
//    self.bottomBorder.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame) - 3, width, 3.0);
}

- (void) setFilterName:(NSString *)filterName {
    _filterName = filterName;
    self.filterLabel.text = filterName;
}

- (void) setFilteredImage:(UIImage *)filteredImage {
    _filteredImage = filteredImage;
    self.imageView.image = filteredImage;
}

// These didn't work the way I wanted them to...
// When cells were dequeued the highlighted attribute stuck around,
// so it was highlighting cells that shouldn't have been highlighted
//- (void) showBorder {
//    [self.layer addSublayer:self.bottomBorder];
//}
//
//- (void) hideBorder {
//    [self.bottomBorder removeFromSuperlayer];
//}


@end
