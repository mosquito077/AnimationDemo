//
//  TwoViewController.h
//  AnimationsDemo
//
//  Created by mosquito on 2017/6/23.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransitionDelegate <NSObject>

- (void)changeViewBackgroundColor;

@end

@interface TwoViewController : UIViewController

@property (nonatomic, assign) CGRect smallFrame;
@property (nonatomic, assign) CGRect expandFrame;

@property (nonatomic, strong) id<TransitionDelegate> delegate;

@end
