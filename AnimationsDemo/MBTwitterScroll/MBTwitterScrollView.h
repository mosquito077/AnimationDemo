//
//  MBTwitterScrollView.h
//  AnimationsDemo
//
//  Created by mosquito on 2017/8/17.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBTwitterScrollView : UIView<UIScrollViewDelegate>

- (instancetype)initScrollViewWithBackground:(UIImage *)backgroundImage avatarImage:(UIImage *)avatarImage;

@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIImageView *headerBgImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UITableView *mTableView;

@property (atomic, strong) NSMutableArray *blurImages;

@end
