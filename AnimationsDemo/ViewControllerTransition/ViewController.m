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

static CGFloat const kSignButtonWidthMargin = 180.f;
static CGFloat const kSignButtonHeightMargin = 45.f;
static CGFloat const kSignButtonBottomMargin = 100.f;

@interface ViewController ()<ProgressAnimationDelegate, UITextFieldDelegate>

@property (strong, nonatomic) ProgressButton *signButton;
@property (strong, nonatomic) UITextField *accountTF;
@property (strong, nonatomic) UITextField *passwordTF;
@property (assign, nonatomic) CGFloat buttonWidth;
@property (assign, nonatomic) CGFloat buttonHeight;
@property (assign, nonatomic) CGFloat buttonX;
@property (assign, nonatomic) CGFloat buttonY;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view.layer addSublayer: [self backgroundLayer]];
    [self setUp];
    
    _signButton.progressDelegate = self;
    
    _buttonWidth = kSignButtonWidthMargin;
    _buttonHeight = kSignButtonHeightMargin;
    _buttonX = (kScreenWidth-kSignButtonWidthMargin)/2;
    _buttonY = kScreenHeight-kSignButtonBottomMargin-kSignButtonHeightMargin;
}

- (void)setUp {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"CLOVER";
    titleLabel.font = [UIFont systemFontOfSize:40.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view).offset(150.f);
        make.width.mas_equalTo(200.f);
        make.height.mas_equalTo(50.f);
    }];
    
    _accountTF = [[UITextField alloc]initWithFrame:CGRectZero];
    _accountTF.placeholder = @"Username";
    [self.view addSubview:_accountTF];
    [_accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view).offset(350.f);
        make.width.mas_equalTo(270.f);
        make.height.mas_equalTo(30.f);
    }];
    
    _passwordTF = [[UITextField alloc]initWithFrame:CGRectZero];
    _passwordTF.placeholder = @"Password";
    [self.view addSubview:_passwordTF];
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.accountTF).offset(60.f);
        make.width.mas_equalTo(270.f);
        make.height.mas_equalTo(30.f);
    }];
    
    _signButton = [[ProgressButton alloc] initWithFrame:CGRectZero];
    [_signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _signButton.layer.cornerRadius = 22.5f;
    [_signButton addTarget:self action:@selector(signButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signButton];
    [_signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view).offset(-kSignButtonBottomMargin);
        make.width.mas_equalTo(kSignButtonWidthMargin);
        make.height.mas_equalTo(kSignButtonHeightMargin);
    }];
}

- (CAGradientLayer *)backgroundLayer {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor orangeColor].CGColor,
                             (__bridge id)[UIColor purpleColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@0.65, @1];
    return gradientLayer;
}

- (void)signButtonTapped:(id)sender {
    [_signButton animate];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//点击屏幕空白处键盘消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_accountTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
}

#pragma mark -- ProgressAnimationDelegate

- (void)animationDidStop {
    TwoViewController *vc= [[TwoViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark -- Getter

- (CGRect)startPathFrame {
    return CGRectMake(_buttonX+(_buttonWidth-_buttonHeight)/2,
                      _buttonY,
                      _buttonHeight,
                      _buttonHeight);
}

- (CGRect)endPathFrame {
    CGFloat radius = sqrt((_buttonX+_buttonWidth/2)*(_buttonX+_buttonWidth/2)+(_buttonY+_buttonHeight/2+20)*(_buttonY+_buttonHeight/2+20));
    return CGRectMake(_buttonX-(radius-_buttonHeight/2),
                      -(radius-_buttonY),
                      radius*2,
                      radius*2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
