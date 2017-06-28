//
//  LoadingCircleLayer.h
//  AnimationsDemo
//
//  Created by mosquito on 2017/6/21.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@protocol LoadingCircleLayerProtocol <NSObject>

- (void)loadingAnimationDidStop;

@end

@interface LoadingCircleLayer : CAShapeLayer

@property (nonatomic, assign) CGFloat circleAnimationDuration;
@property (nonatomic, assign) CGFloat circleRadius;
@property (nonatomic, strong) UIBezierPath *loadingPath;

@property (nonatomic, weak) id<LoadingCircleLayerProtocol> loadingDelegate;

- (void)fillProperties:(CGRect)parentBounds circleRadius:(CGFloat)radius;

- (instancetype)init;

- (void)loadingAnimate;

- (void)fadeIn;

@end
