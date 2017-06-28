//
//  LabelLayer.h
//  animationDemo
//
//  Created by mosquito on 2017/6/19.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface LabelLayer : CATextLayer

- (void)fillProperties:(CGRect)parentBounds text:(NSString *)text;

- (void)fadeIn;

- (void)fadeOut;

@end
