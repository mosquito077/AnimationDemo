//
//  TwoViewController.m
//  AnimationsDemo
//
//  Created by mosquito on 2017/6/23.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import "TwoViewController.h"
#import "PresentTransitionAnimator.h"

static CGFloat const kAddButtonWidthAndHeight = 60.f;
static CGFloat const kCircleRadiusExpand = 100.f;

@interface TwoViewController ()
<UIViewControllerTransitioningDelegate, CircleSpreadTransitionDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *worksArr;
@property (nonatomic, strong) UIButton *vButton;
@property (nonatomic, strong) UIButton *rotateButton;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _worksArr = @[@"帝高阳之苗裔兮", @"朕皇考曰伯庸",
                  @"摄提贞于孟陬兮", @"惟庚寅吾以降",
                  @"皇览揆余初度兮", @"肇锡余以嘉名",
                  @"名余曰正则兮", @"字余曰灵均",
                  @"纷吾既有此内美兮", @"又重之以修能",
                  @"扈江离与辟芷兮", @"纫秋兰以为佩",
                  @"汨余若将不及兮", @"恐年岁之不吾与"];
    
    self.transitioningDelegate = self;
    
    [self initViews];

}

- (void)initViews {
    
    self.mTwitterScrollView = [[MBTwitterScrollView alloc] initScrollViewWithBackground:[UIImage imageNamed:@"mine_bg"] avatarImage:[UIImage imageNamed:@"moren_head"]];
    self.mTwitterScrollView.mTableView.delegate = self;
    self.mTwitterScrollView.mTableView.dataSource = self;
    self.mTwitterScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mTwitterScrollView.mTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mTwitterScrollView];
    [self.mTwitterScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(self.view);
    }];
    
    self.vButton = [[UIButton alloc] initWithFrame:CGRectZero];
    UIImage *iconImage = [UIImage imageNamed:@"mine_note_icon"];
    [self.vButton setImage:iconImage forState:UIControlStateNormal];
    self.vButton.layer.cornerRadius = iconImage.size.height/2;
    self.vButton.alpha = 0.f;
    [self.view addSubview:self.vButton];
    
    [self.vButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15.f);
        make.top.equalTo(self.view).offset(20.f);
        make.width.height.mas_equalTo(iconImage.size.height);
    }];
    
    self.rotateButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.rotateButton setBackgroundColor: [UIColor orangeColor]];
    [self.rotateButton setTitle:@"＋" forState:UIControlStateNormal];
    self.rotateButton.layer.cornerRadius = kAddButtonWidthAndHeight/2;
    self.rotateButton.alpha = 0.f;
    [self.rotateButton addTarget:self action:@selector(animationStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rotateButton];
    [self.rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-30.f);
        make.bottom.equalTo(self.view).offset(-50.f);
        make.width.height.mas_equalTo(kAddButtonWidthAndHeight);
    }];
}

- (void)animationStart {
    POPBasicAnimation *centerAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    centerAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.rotateButton.center.x, self.rotateButton.center.y)];
    centerAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, self.view.center.y)];
    centerAnimation.duration = 0.4;
    centerAnimation.removedOnCompletion = NO;
    [self.rotateButton pop_addAnimation:centerAnimation forKey:@"centerAnimation"];
    
    centerAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
}

- (void)_animationWithButtons {
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.beginTime = 0.4;
    alphaAnimation.duration = 0.4;
    alphaAnimation.toValue = @1.0;
    [self.rotateButton pop_addAnimation:alphaAnimation forKey:@"alpha"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.beginTime = 0.4;
    scaleAnimation.springBounciness = 10.f;
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeZero];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.rotateButton pop_addAnimation:scaleAnimation forKey:@"scalingXY"];
    
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            alphaAnimation.beginTime = 0.4;
            alphaAnimation.duration = 0.4;
            alphaAnimation.toValue = @1.0;
            [self.vButton pop_addAnimation:alphaAnimation forKey:@"alpha"];
            
            POPBasicAnimation *scaleXYAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            scaleXYAnimation.duration = 0.4;
            scaleXYAnimation.fromValue = [NSValue valueWithCGSize:CGSizeZero];
            scaleXYAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
            [self.vButton pop_addAnimation:scaleXYAnimation forKey:@"scalingXY"];
        }
    };
}


#pragma mark - uitableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_worksArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [_worksArr objectAtIndex:indexPath.row];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 44.f, kScreenWidth, 0.8f)];
        lineView.backgroundColor = [UIColor colorWithRed:224/255 green:224/255 blue:224/255 alpha:0.2];
        [cell.contentView addSubview:lineView];
    }
    return cell;
}

#pragma mark -- UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    PresentTransitionAnimator *presentAnimator = [PresentTransitionAnimator transitionWithTransitionType:CircleSpreadTransitionTypePresent];
    presentAnimator.delegate = self;
    return presentAnimator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    PresentTransitionAnimator *dismissAnimator = [PresentTransitionAnimator transitionWithTransitionType:CircleSpreadTransitionTypeDismiss];
    return dismissAnimator;
}

#pragma mark -- CircleSpreadTransitionDelegate

- (void)presentAnimationDidStop {
    [self _animationWithButtons];
}

#pragma mark -- Getter

- (CGRect)smallFrame {
    return CGRectMake((kScreenWidth-kAddButtonWidthAndHeight)/2,
                      (kScreenHeight-kAddButtonWidthAndHeight)/2,
                      kAddButtonWidthAndHeight,
                      kAddButtonWidthAndHeight);
}

- (CGRect)expandFrame {
    CGFloat radius = kScreenHeight+kCircleRadiusExpand;
    return CGRectMake(self.view.center.x-radius/2,
                      self.view.center.y-radius/2,
                      radius,
                      radius);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
