//
//  ProgressButton.h
//  animationDemo
//
//  Created by mosquito on 2017/6/19.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProgressAnimationDelegate <NSObject>

- (void)animationDidStop;

@end

@interface ProgressButton : UIButton

@property (weak, nonatomic) id<ProgressAnimationDelegate> progressDelegate;

- (void)animate;

@end
