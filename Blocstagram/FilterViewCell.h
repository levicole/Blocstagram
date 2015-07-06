//
//  FilterViewCell.h
//  Blocstagram
//
//  Created by Levi Kennedy on 7/5/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterViewCell;

@interface FilterViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *filterName;
@property (nonatomic, strong) UIImage  *filteredImage;

//- (void) showBorder;
//- (void) hideBorder;
@end
