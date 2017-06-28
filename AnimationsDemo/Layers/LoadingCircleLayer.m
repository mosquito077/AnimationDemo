//
//  LoadingCircleLayer.m
//  AnimationsDemo
//
//  Created by mosquito on 2017/6/21.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import "LoadingCircleLayer.h"

static NSString *const kCircleTypeAnimationRotationGroup = @"kCircleTypeAnimationRotationGroup";

@interface LoadingCircleLayer()<CAAnimationDelegate>

@end

@implementation LoadingCircleLayer

+ (instancetype)layer {
    return [[LoadingCircleLayer alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)layoutSublayers {
    [super layoutSublayers];
}

- (void)fillProperties:(CGRect)parentBounds circleRadius:(CGFloat)radius {
    self.frame = CGRectMake(parentBounds.size.width/2-parentBounds.size.height/2, 0, parentBounds.size.height, parentBounds.size.height);
    self.cornerRadius = parentBounds.size.height/2;
    self.backgroundColor = [UIColor clearColor].CGColor;
    self.circleRadius = radius-5;
    self.fillColor = [UIColor clearColor].CGColor;
    self.strokeColor = [UIColor whiteColor].CGColor;
    self.path = self.loadingPath.CGPath;
    self.opacity = 0.0;
}

- (void)loadingAnimate {
    self.opacity = 1.0;
    
    CGFloat circleGap = 0.15;
    CGFloat strokeEnd = 1.0f - circleGap;
    CABasicAnimation *strokeEndToStart = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndToStart.fromValue = @(circleGap);
    strokeEndToStart.toValue = @(strokeEnd);
    strokeEndToStart.duration = self.circleAnimationDuration;
    strokeEndToStart.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *strokeEndToEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndToEnd.beginTime = self.circleAnimationDuration;
    strokeEndToEnd.fromValue = @(strokeEnd);
    strokeEndToEnd.toValue = @(circleGap);
    strokeEndToEnd.duration = self.circleAnimationDuration;
    strokeEndToEnd.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAAnimationGroup *joggingAnimationGroup = [[CAAnimationGroup alloc] init];
    joggingAnimationGroup.animations = @[strokeEndToStart, strokeEndToEnd];
    joggingAnimationGroup.duration = self.circleAnimationDuration * 2;
    joggingAnimationGroup.repeatCount = 0;
    [self addAnimation:joggingAnimationGroup forKey:@"CircleTypeAnimationJoggingGroup"];

    CABasicAnimation *startRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    startRotationAnimation.toValue = [NSNumber numberWithFloat:(M_PI * 2.0f * 3.0f)];
    startRotationAnimation.duration = self.circleAnimationDuration * 2;
    startRotationAnimation.repeatCount = 0;
    startRotationAnimation.delegate = self;
    startRotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self addAnimation:startRotationAnimation forKey:@"CircleTypeAnimationRotationGroup"];
}

- (void)fadeIn {
    self.opacity = 0.0;
}

#pragma mark - Setters & Getters

- (CGFloat)circleAnimationDuration {
    return 0.6f;
}

- (UIBezierPath *)loadingPath {
    if (!_loadingPath) {
        _loadingPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.frame)/2.0f, CGRectGetHeight(self.frame)/2.0f) radius:self.circleRadius startAngle:M_PI*1.75 endAngle:M_PI*1.25 clockwise:YES];
        _loadingPath.lineWidth = 2.0;
    }
    return _loadingPath;
}

#pragma mark -- delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.loadingDelegate
        && [self.loadingDelegate respondsToSelector:@selector(loadingAnimationDidStop)]) {
        [self.loadingDelegate loadingAnimationDidStop];
    }
}

@end
