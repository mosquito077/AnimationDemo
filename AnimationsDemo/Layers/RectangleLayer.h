//
//  RectangleLayer.h
//  animationDemo
//
//  Created by mosquito on 2017/6/19.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@protocol RectangleProtocol <NSObject>

- (void)rectangleAnimationDidStop;

@end

@interface RectangleLayer : CAShapeLayer

@property (assign, nonatomic) CGRect frameRect;
@property (assign, nonatomic) CGRect frameSquare;

@property (strong, nonatomic) UIBezierPath *roundedRectangle;
@property (strong, nonatomic) UIBezierPath *roundedSquare;

@property (nonatomic, weak) id<RectangleProtocol> delegateAnimation;

- (instancetype)init;

- (void)animate;

- (void)animateInitialState;

- (void)fillProperties:(CGRect)parentBounds color:(UIColor *)color;

@end
