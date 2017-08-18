//
//  UIScrollView+TwitterCover.m
//  AnimationsDemo
//
//  Created by mosquito on 2017/8/17.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import "UIScrollView+TwitterCover.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

static char UIScrollViewTwitterCover;

@implementation UIScrollView (TwitterCover)

- (void)setTwitterCoverView:(CHTwitterCoverView *)twitterCoverView {
    [self willChangeValueForKey:@"twitterCoverView"];
    objc_setAssociatedObject(self, &UIScrollViewTwitterCover, twitterCoverView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"twitterCoverView"];
}

- (CHTwitterCoverView *)twitterCoverView {
    return objc_getAssociatedObject(self, &UIScrollViewTwitterCover);
}

- (void)addTwitterCoverWithImage:(UIImage *)image {
    [self addTwitterCoverWithImage:image withTopView:nil];
}

- (void)addTwitterCoverWithImage:(UIImage *)image withTopView:(UIView *)topView {
    CHTwitterCoverView *coverView = [[CHTwitterCoverView alloc] initWithFrame:CGRectMake(0, 0, 320, CHTwitterCoverViewHeight) andContentTopView:topView];
    coverView.backgroundColor = [UIColor clearColor];
    coverView.image = image;
    coverView.scrollView = self;
    
    [self addSubview:coverView];
    
    if (topView) {
        [self addSubview:topView];
    }
    self.twitterCoverView = coverView;
    
}

- (void)removeTwitterCoverView {
    [self.twitterCoverView removeFromSuperview];
    self.twitterCoverView = nil;
}

@end


@implementation CHTwitterCoverView {
    NSMutableArray *blurImages_;
    UIView *topView;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame andContentTopView:nil];
}

- (id)initWithFrame:(CGRect)frame andContentTopView:(UIView *)view {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        blurImages_ = [[NSMutableArray alloc]initWithCapacity:20];
        topView = view;
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    [super setImage:image];
    [blurImages_ removeAllObjects];
    [self prepareForBlurImages];
}

- (void)prepareForBlurImages {
    CGFloat factor = 0.1;
    [blurImages_ addObject:self.image];
    for (NSUInteger i = 0; i < 20; i++) {
        [blurImages_ addObject:[self.image boxBlurImageWithBlur:factor]];
        factor += 0.04;
    }
}

- (void)setScrollView:(UIScrollView *)scrollView {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    _scrollView = scrollView;
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeFromSuperview {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [topView removeFromSuperview];
    [super removeFromSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.scrollView.contentOffset.y < 0) {
        CGFloat offset = -self.scrollView.contentOffset.y;
        topView.frame = CGRectMake(0, -offset, 320, topView.bounds.size.height);
        self.frame = CGRectMake(-offset,-offset + topView.bounds.size.height, 320+ offset * 2, CHTwitterCoverViewHeight + offset);
        NSInteger index = offset / 10;
        if (index < 0) {
            index = 0;
        } else if(index >= blurImages_.count) {
            index = blurImages_.count - 1;
        }
        UIImage *image = blurImages_[index];
        if (self.image != image) {
            [super setImage:image];
        }
    } else {
        topView.frame = CGRectMake(0, 0, 320, topView.bounds.size.height);
        self.frame = CGRectMake(0,topView.bounds.size.height, 320, CHTwitterCoverViewHeight);
        UIImage *image = blurImages_[0];
        if (self.image != image) {
            [super setImage:image];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setNeedsLayout];
}

@end


@implementation UIImage (Blur)

- (UIImage *)boxBlurImageWithBlur:(CGFloat)blur {
    NSData *imageData = UIImageJPEGRepresentation(self, 1);
    UIImage *destImage = [UIImage imageWithData:imageData];
    
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur*50);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = destImage.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
    
}

@end
