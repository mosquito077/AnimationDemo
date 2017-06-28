//
//  LabelLayer.m
//  animationDemo
//
//  Created by mosquito on 2017/6/19.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import "LabelLayer.h"

@implementation LabelLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}

- (instancetype)initWithLayer:(id)layer {
    return [super initWithLayer:layer];
}

- (void)fillProperties:(CGRect)parentBounds text:(NSString *)text{
    UIFont *font = [UIFont systemFontOfSize:15.f];
    self.string = text;
    self.font = (__bridge CFTypeRef _Nullable)(@"bold");
    self.fontSize = font.pointSize;
    self.frame = CGRectMake(0, (parentBounds.size.height-self.fontSize)/2, parentBounds.size.width, self.fontSize+5);
    self.foregroundColor = [UIColor whiteColor].CGColor;
    self.wrapped = YES;
    self.alignmentMode = kCAAlignmentCenter;
    self.contentsScale = [UIScreen mainScreen].scale;
    self.opacity = 1.0;
}

- (void)fadeIn {
    CABasicAnimation *animationFadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationFadeIn.fromValue = @(1.0);
    animationFadeIn.toValue = @(0.0);
    animationFadeIn.duration = 0.5;
    animationFadeIn.fillMode = kCAFillModeForwards;
    animationFadeIn.removedOnCompletion = NO;
    [self addAnimation:animationFadeIn forKey:nil];
}

- (void)fadeOut {
    CABasicAnimation *animationFadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationFadeIn.fromValue = @(0.0);
    animationFadeIn.toValue = @(1.0);
    animationFadeIn.duration = 0.5;
    animationFadeIn.fillMode = kCAFillModeForwards;
    animationFadeIn.removedOnCompletion = false;
    [self addAnimation:animationFadeIn forKey:nil];
}

@end
