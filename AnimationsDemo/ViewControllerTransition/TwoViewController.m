//
//  TwoViewController.m
//  AnimationsDemo
//
//  Created by mosquito on 2017/6/23.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import "TwoViewController.h"
#import "PresentTransitionAnimator.h"
#import "Masonry.h"
#import <pop/POP.h>

static CGFloat const kNumButtonWidthAndHeight = 30.f;
static CGFloat const kAddButtonWidthAndHeight = 60.f;

#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface TwoViewController ()<UIViewControllerTransitioningDelegate, CircleSpreadTransitionDelegate, CAAnimationDelegate>

@property (nonatomic, strong) UIButton *numButton;
@property (nonatomic, strong) UIButton *addButton;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.transitioningDelegate = self;
    
    self.numButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.numButton setTitle:@"3" forState:UIControlStateNormal];
    [self.numButton setBackgroundColor:[UIColor yellowColor]];
    self.numButton.layer.cornerRadius = kNumButtonWidthAndHeight/2;
    self.numButton.alpha = 0.f;
    [self.view addSubview:self.numButton];
    [self.numButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(100.f);
        make.top.equalTo(self.view).offset(100.f);
        make.width.height.mas_equalTo(kNumButtonWidthAndHeight);
    }];
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.addButton setBackgroundColor: [UIColor redColor]];
    [self.addButton setTitle:@"＋" forState:UIControlStateNormal];
    self.addButton.layer.cornerRadius = kAddButtonWidthAndHeight/2;
    self.addButton.alpha = 0.f;
    [self.addButton addTarget:self action:@selector(animationStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-30.f);
        make.bottom.equalTo(self.view).offset(-50.f);
        make.width.height.mas_equalTo(kAddButtonWidthAndHeight);
    }];
}

- (void)animationStart {
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.addButton.center.x, self.addButton.center.y)];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, self.view.center.y)];
    positionAnimation.duration = 0.4;
    positionAnimation.delegate = self;
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.fillMode = kCAFillModeForwards;
    [self.addButton.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)_animationWithButtons {
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.beginTime = 0.4;
    alphaAnimation.duration = 0.4;
    alphaAnimation.toValue = @1.0;
    [self.addButton pop_addAnimation:alphaAnimation forKey:@"alpha"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.beginTime = 0.4;
    scaleAnimation.springBounciness = 10.f;
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeZero];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.addButton pop_addAnimation:scaleAnimation forKey:@"scalingXY"];
    
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            alphaAnimation.beginTime = 0.4;
            alphaAnimation.duration = 0.4;
            alphaAnimation.toValue = @1.0;
            [self.numButton pop_addAnimation:alphaAnimation forKey:@"alpha"];
            
            POPBasicAnimation *scaleXYAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            scaleXYAnimation.duration = 0.4;
            scaleXYAnimation.fromValue = [NSValue valueWithCGSize:CGSizeZero];
            scaleXYAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
            [self.numButton pop_addAnimation:scaleXYAnimation forKey:@"scalingXY"];
        }
    };
}

#pragma mark -- UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    PresentTransitionAnimator *presentAnimator = [PresentTransitionAnimator transitionWithTransitionType:CircleSpreadTransitionTypePresent];
    presentAnimator.delegate = self;
    return presentAnimator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    PresentTransitionAnimator *dismissAnimator = [PresentTransitionAnimator transitionWithTransitionType:CircleSpreadTransitionTypeDismiss];
    dismissAnimator.delegate = self;
    return dismissAnimator;
}

#pragma mark -- CircleSpreadTransitionDelegate

- (void)presentAnimationDidStop {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self _animationWithButtons];
}

- (void)dismissAnimationDidStop {
    if (self.delegate) {
        [self.delegate changeViewBackgroundColor];
    }
}

#pragma mark -- caanimationdelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -- getter
- (CGRect)smallFrame {
    return CGRectMake((kScreenWidth-kAddButtonWidthAndHeight)/2, (kScreenHeight-kAddButtonWidthAndHeight)/2, kAddButtonWidthAndHeight, kAddButtonWidthAndHeight);
}

- (CGRect)expandFrame {
    CGFloat radius = kScreenHeight+100;
    return CGRectMake(self.view.center.x-radius/2, self.view.center.y-radius/2, radius, radius);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end