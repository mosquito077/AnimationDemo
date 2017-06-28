//
//  ProgressButton.m
//  animationDemo
//
//  Created by mosquito on 2017/6/19.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import "ProgressButton.h"
#import "RectangleLayer.h"
#import "LabelLayer.h"
#import "LoadingCircleLayer.h"

@interface ProgressButton()<RectangleProtocol, LoadingCircleLayerProtocol, CAAnimationDelegate>

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) RectangleLayer *rectangleLayer;
@property (nonatomic, strong) LabelLayer *labelLayer;
@property (nonatomic, strong) LoadingCircleLayer *loadingLayer;

@end

@implementation ProgressButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initial];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initial];
    }
    return self;
}

- (void)initial {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.rectangleLayer = [[RectangleLayer alloc]init];
    self.rectangleLayer.delegateAnimation = self;
    [self.layer addSublayer:self.rectangleLayer];
    
    self.labelLayer = [[LabelLayer alloc]init];
    [self.layer addSublayer:self.labelLayer];
    
    self.loadingLayer = [[LoadingCircleLayer alloc] init];
    self.loadingLayer.loadingDelegate = self;
    [self.layer addSublayer:self.loadingLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.rectangleLayer fillProperties:self.bounds color:[UIColor redColor]];
    [self.labelLayer fillProperties:self.bounds text:@"Sign In"];
    [self.loadingLayer fillProperties:self.bounds circleRadius:[self circleRadius]];
}

- (void)animate {
    [self hideLabel];
    [self.rectangleLayer animate];
}

- (void)hideLabel {
    [self.labelLayer fadeIn];
}

- (CGFloat)circleRadius {
    return ceil(MIN(CGRectGetHeight(self.frame), CGRectGetWidth(self.frame)) / 2.0f);
}

#pragma mark -- rectangleProtocol
- (void)rectangleAnimationDidStop {
    [self.loadingLayer loadingAnimate];
}

#pragma mark - loadingCircleProtocol
- (void)loadingAnimationDidStop {
    [self.loadingLayer fadeIn];
    if (self.progressDelegate && [self.progressDelegate respondsToSelector:@selector(animationDidStop)]) {
        [self.rectangleLayer animateInitialState];
        [self.labelLayer fadeOut];
        [self.progressDelegate animationDidStop];
    }
}

@end
