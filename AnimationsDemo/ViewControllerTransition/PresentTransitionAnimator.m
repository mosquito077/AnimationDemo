//
//  PresentTransitionAnimator.m
//  AnimationsDemo
//
//  Created by mosquito on 2017/6/28.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import "PresentTransitionAnimator.h"
#import "ViewController.h"
#import "TwoViewController.h"

@implementation PresentTransitionAnimator

+ (instancetype)transitionWithTransitionType:(CircleSpreadTransitionType)type {
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(CircleSpreadTransitionType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (_type) {
        case CircleSpreadTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case CircleSpreadTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
        default:
            break;
    }
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController *temp = (ViewController *)fromVC;
    toVC.view.backgroundColor = [UIColor redColor];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithRoundedRect:temp.startPathFrame cornerRadius:temp.startPathFrame.size.height/2];
    UIBezierPath *endCycle = [UIBezierPath bezierPathWithRoundedRect:temp.endPathFrame cornerRadius:temp.endPathFrame.size.height/2];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];    //创建CAShapeLayer进行遮盖
    maskLayer.path = endCycle.CGPath;
    toVC.view.layer.mask = maskLayer;                  //将maskLayer作为toVC.View的遮盖
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    TwoViewController *temp = (TwoViewController *)fromVC;
    toVC.view.backgroundColor = [UIColor redColor];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithRoundedRect:temp.smallFrame cornerRadius:temp.smallFrame.size.height/2];
    UIBezierPath *endCycle = [UIBezierPath bezierPathWithRoundedRect:temp.expandFrame cornerRadius:temp.expandFrame.size.height/2];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];         //创建CAShapeLayer进行遮盖
    maskLayer.path = endCycle.CGPath;
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

#pragma mark -- animationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    switch (_type) {
        case CircleSpreadTransitionTypePresent:{
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:YES];
            [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.backgroundColor = [UIColor whiteColor];
            if (_delegate && [_delegate respondsToSelector:@selector(presentAnimationDidStop)]) {
                [_delegate presentAnimationDidStop];
            }
        }
            break;
        case CircleSpreadTransitionTypeDismiss:{
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if ([transitionContext transitionWasCancelled]) {
                
            }
            [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.backgroundColor = [UIColor whiteColor];
        }
            break;
    }
}

@end

