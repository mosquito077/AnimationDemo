//
//  UIScrollView+TwitterCover.h
//  AnimationsDemo
//
//  Created by mosquito on 2017/8/17.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CHTwitterCoverViewHeight  200.0f

@interface CHTwitterCoverView : UIImageView

@property (nonatomic, weak) UIScrollView *scrollView;

- (id)initWithFrame:(CGRect)frame andContentTopView:(UIView *)view;

@end

@interface UIImage (Blur)

- (UIImage *)boxBlurImageWithBlur:(CGFloat)blur;

@end

@interface UIScrollView (TwitterCover)

@property (nonatomic, weak) CHTwitterCoverView *twitterCoverView;

- (void)addTwitterCoverWithImage:(UIImage *)image;

- (void)addTwitterCoverWithImage:(UIImage *)image withTopView:(UIView *)topView;

- (void)removeTwitterCoverView;

@end
