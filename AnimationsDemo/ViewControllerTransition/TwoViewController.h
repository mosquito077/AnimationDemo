//
//  TwoViewController.h
//  AnimationsDemo
//
//  Created by mosquito on 2017/6/23.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBTwitterScrollView.h"

@interface TwoViewController : UIViewController

@property (nonatomic, assign) CGRect smallFrame;
@property (nonatomic, assign) CGRect expandFrame;

@property (strong, nonatomic) MBTwitterScrollView *mTwitterScrollView;

@end

