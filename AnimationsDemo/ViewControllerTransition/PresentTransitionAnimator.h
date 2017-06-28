//
//  PresentTransitionAnimator.h
//  AnimationsDemo
//
//  Created by mosquito on 2017/6/28.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CircleSpreadTransitionType) {
    CircleSpreadTransitionTypePresent = 0,
    CircleSpreadTransitionTypeDismiss
};

@protocol CircleSpreadTransitionDelegate <NSObject>

- (void)presentAnimationDidStop;

- (void)dismissAnimationDidStop;

@end

@interface PresentTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning, CAAnimationDelegate>

@property (nonatomic, assign) CircleSpreadTransitionType type;

@property (nonatomic, weak) id <CircleSpreadTransitionDelegate> delegate;

+ (instancetype)transitionWithTransitionType:(CircleSpreadTransitionType)type;

- (instancetype)initWithTransitionType:(CircleSpreadTransitionType)type;

@end
