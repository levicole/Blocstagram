//
//  CameraToolbar.m
//  Blocstagram
//
//  Created by Levi Kennedy on 6/29/15.
//  Copyright (c) 2015 Levi Kennedy. All rights reserved.
//

#import "CameraToolbar.h"

@interface CameraToolbar ()

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIView *purpleView;

@end

@implementation CameraToolbar

- (instancetype) initWithImageNames:(NSArray *)imageNames {
    self = [super init];
    
    if (self) {
        self.leftButton   = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.leftButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.cameraButton addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.leftButton   setImage:[UIImage imageNamed:imageNames.firstObject] forState:UIControlStateNormal];
        [self.rightButton  setImage:[UIImage imageNamed:imageNames.lastObject] forState:UIControlStateNormal];
        
        [self.cameraButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [self.cameraButton setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 15, 10)];
        
        self.whiteView = [UIView new];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        
        self.purpleView = [UIView new];
        self.purpleView.backgroundColor = [UIColor colorWithRed:0.345 green:0.318 blue:0.424 alpha:1];
        
        for (UIView *view in @[self.whiteView, self.purpleView, self.leftButton, self.cameraButton, self.rightButton]) {
            [self addSubview:view];
            view.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        [self createConstraints];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.purpleView.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.purpleView.bounds;
    maskLayer.path  = maskPath.CGPath;
    
    self.purpleView.layer.mask = maskLayer;
}

- (void) createConstraints {
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_leftButton, _cameraButton, _rightButton, _whiteView, _purpleView);
    
    NSArray *allButtonsHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftButton][_cameraButton(==_leftButton)][_rightButton(==_leftButton)]|"
                                                                                       options:kNilOptions
                                                                                       metrics:nil
                                                                                         views:viewDictionary];
    
    NSArray *leftButtonVerticalConstraints  = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_leftButton]"
                                                                                      options:kNilOptions
                                                                                      metrics:nil
                                                                                        views:viewDictionary];
    
    NSArray *cameraButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraButton]|"
                                                                                       options:kNilOptions
                                                                                       metrics:nil
                                                                                         views:viewDictionary];
    
    NSArray *rightButtonVerticalConstraints  = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_rightButton]|"
                                                                                       options:kNilOptions
                                                                                       metrics:nil
                                                                                         views:viewDictionary];
    
    NSArray *whiteViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_whiteView]|"
                                                                                       options:kNilOptions
                                                                                       metrics:nil
                                                                                         views:viewDictionary];
    
    NSArray *whiteViewVerticalConstraints   = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_whiteView]|"
                                                                                      options:kNilOptions
                                                                                      metrics:nil
                                                                                        views:viewDictionary];
    
    NSArray *purpleViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[_leftButton][_purpleView][_rightButton]"
                                                                                       options:NSLayoutFormatAlignAllBottom
                                                                                       metrics:nil
                                                                                         views:viewDictionary];
    NSArray *purpleViewVerticalConstraints   = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_purpleView]"
                                                                                       options:kNilOptions
                                                                                       metrics:nil
                                                                                         views:viewDictionary];
    
    NSArray *allConstraintsArray = @[allButtonsHorizontalConstraints, leftButtonVerticalConstraints, cameraButtonVerticalConstraints, rightButtonVerticalConstraints, whiteViewHorizontalConstraints, whiteViewVerticalConstraints, purpleViewHorizontalConstraints, purpleViewVerticalConstraints];
    
    
    for (NSArray *constraintsArray in allConstraintsArray) {
        for (NSLayoutConstraint *constraint in constraintsArray) {
            [self addConstraint:constraint];
        }
    }
    
}


# pragma mark - Button Handlers

- (void) leftButtonPressed:(UIButton *)sender {
    [self.delegate leftButtonPressedOnToolbar:self];
}

- (void) rightButtonPressed:(UIButton *)sender {
    [self.delegate rightButtonPressedOnToolbar:self];
}

- (void) cameraButtonPressed:(UIButton *)sender {
    [self.delegate cameraButtonPressedOnToolbar:self];
}

@end
