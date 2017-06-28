//
//  RectangleLayer.m
//  animationDemo
//
//  Created by mosquito on 2017/6/19.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import "RectangleLayer.h"

@interface RectangleLayer()<CAAnimationDelegate>
@end

@implementation RectangleLayer

- (instancetype)init {
    self = [super init];
    if (self) {
    }
   return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}

- (void)fillProperties:(CGRect)parentBounds color:(UIColor *)color {
    _frameRect = CGRectMake(0, 0, parentBounds.size.width, parentBounds.size.height);
    _frameSquare = CGRectMake(_frameRect.size.width/2- _frameRect.size.height/2, 0, _frameRect.size.height, _frameRect.size.height);
    self.path = self.roundedRectangle.CGPath;
    self.fillColor = color.CGColor;
}

- (void)animate {
    CABasicAnimation *animationSquare = [CABasicAnimation animationWithKeyPath:@"path"];
    animationSquare.fromValue = (__bridge id _Nullable)(self.roundedRectangle.CGPath);
    animationSquare.toValue = (__bridge id _Nullable)(self.roundedSquare.CGPath);
    animationSquare.delegate = self;
    animationSquare.beginTime = 0.0;
    animationSquare.duration = 0.4;
    animationSquare.fillMode = kCAFillModeForwards;
    animationSquare.removedOnCompletion = NO;
    [self addAnimation:animationSquare forKey:nil];
}

- (void)animateInitialState {
    CABasicAnimation *animationRectangle = [CABasicAnimation animationWithKeyPath:@"path"];
    animationRectangle.fromValue = (__bridge id _Nullable)(self.roundedSquare.CGPath);
    animationRectangle.toValue = (__bridge id _Nullable)(self.roundedRectangle.CGPath);
    animationRectangle.duration = 0.4;
    animationRectangle.fillMode = kCAFillModeForwards;
    animationRectangle.removedOnCompletion = NO;
    [self addAnimation:animationRectangle forKey:nil];
}

#pragma mark -- getter

- (UIBezierPath *)roundedRectangle {
    if (!_roundedRectangle) {
        _roundedRectangle = [UIBezierPath bezierPathWithRoundedRect:_frameRect cornerRadius:_frameRect.size.height/2];
    }
    return _roundedRectangle;
}

- (UIBezierPath *)roundedSquare {
    if (!_roundedSquare) {
        _roundedSquare = [UIBezierPath bezierPathWithRoundedRect:_frameSquare cornerRadius:_frameSquare.size.height/2];
    }
    return _roundedSquare;
}

#pragma mark -- delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.delegateAnimation
        && [self.delegateAnimation respondsToSelector:@selector(rectangleAnimationDidStop)]) {
        [self.delegateAnimation rectangleAnimationDidStop];
    }
}

@end
