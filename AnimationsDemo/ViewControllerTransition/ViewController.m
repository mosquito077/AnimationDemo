//
//  ViewController.m
//  AnimationsDemo
//
//  Created by mosquito on 2017/6/19.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import "ViewController.h"
#import "TwoViewController.h"
#import "ProgressButton.h"

@interface ViewController ()<ProgressAnimationDelegate, TransitionDelegate>

@property (weak, nonatomic) IBOutlet ProgressButton *signButton;
@property (assign, nonatomic) CGFloat buttonWidth;
@property (assign, nonatomic) CGFloat buttonHeight;
@property (assign, nonatomic) CGFloat buttonX;
@property (assign, nonatomic) CGFloat buttonY;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _signButton.progressDelegate = self;
    
    _buttonWidth = _signButton.frame.size.width;
    _buttonHeight = _signButton.frame.size.height;
    _buttonX = _signButton.frame.origin.x;
    _buttonY = _signButton.frame.origin.y;
}

- (IBAction)signButtonTapped:(id)sender {
    [_signButton animate];
}

#pragma mark -- delegate
- (void)animationDidStop {
    TwoViewController *vc= [[TwoViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (CGRect)startPathFrame {
    return CGRectMake(_buttonX+(_buttonWidth-_buttonHeight)/2, _buttonY, _buttonHeight, _buttonHeight);
}

- (CGRect)endPathFrame {
    CGFloat radius = sqrt((_buttonX+_buttonWidth/2)*(_buttonX+_buttonWidth/2)+(_buttonY+_buttonHeight/2+20)*(_buttonY+_buttonHeight/2+20));
    return CGRectMake(_buttonX-(radius-_buttonHeight/2), -(radius-_buttonY), radius*2, radius*2);
}

- (void)changeViewBackgroundColor {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
