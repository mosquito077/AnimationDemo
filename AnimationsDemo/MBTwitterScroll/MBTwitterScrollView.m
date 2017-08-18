//
//  MBTwitterScrollView.m
//  AnimationsDemo
//
//  Created by mosquito on 2017/8/17.
//  Copyright © 2017年 mosquito. All rights reserved.
//

#import "MBTwitterScrollView.h"
#import "UIScrollView+TwitterCover.h"

static CGFloat const kOffset_HeaderImageStop = 85.0;    //头像缩小程度
static CGFloat const kAvatarSize = 85.f;                // 头像大小
static CGFloat const kOffset_HeaderStop = 92.0;         //动画停止背景图高度
static CGFloat const kOffset_B_LabelHeader = 140.0;     //标题最初的位置
static CGFloat const kDistance_W_LabelHeader = 30.0;    //标题最终停留的Y

static CGFloat const kHeaderViewHegiht = 156.f;
static CGFloat const kMargin_Name_Avatar = 10.f;

typedef NS_ENUM(NSInteger, TwitterScrollBlurState) {
    TwitterScrollBlurState_NotYet = 0,
    TwitterScrollBlurState_Progressing,
    TwitterScrollBlurState_Done
};

@interface MBTwitterScrollView ()

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *identifyIconImageView;
@property (nonatomic, strong) UIButton *headerBgButton;
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UIView *topContentWhiteView;
@property (atomic) TwitterScrollBlurState blurState;

@end

@implementation MBTwitterScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configSubviews];
        
        [self.mTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
     }
    return self;
}

- (instancetype)initScrollViewWithBackground:(UIImage *)backgroundImage avatarImage:(UIImage *)avatarImage {
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self configBackgroundImage:backgroundImage avatarImage:avatarImage];
    }
    return self;
}

- (UIView *)topContentWhiteView {
    if (!_topContentWhiteView) {
        _topContentWhiteView = [[UIView alloc] initWithFrame:CGRectZero];
        _topContentWhiteView.backgroundColor = [UIColor whiteColor];
    }
    return _topContentWhiteView;
}

- (void)dealloc {
    [self.mTableView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - init

- (void)configBackgroundImage:(UIImage *)bgImage avatarImage:(UIImage *)avaterImage {
    self.blurImages = [[NSMutableArray alloc] init];
    self.headerBgImageView.backgroundColor = [UIColor blackColor];
}

- (void)configSubviews {
    // Header
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.headerLabel];
    [self.headerView addSubview:self.headerBgImageView];
    
    [self addSubview:self.mTableView];
    
    CGFloat extraHeight = 75.f;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, kHeaderViewHegiht + extraHeight)];
    headerView.userInteractionEnabled = YES;
    self.mTableView.tableHeaderView = headerView;
    self.mTableView.tableHeaderView.userInteractionEnabled = YES;
    
    [self.mTableView addSubview:self.topContentWhiteView];
    [self.mTableView addSubview:self.avatarImageView];
    [self.mTableView addSubview:self.userNameLabel];
    [self.mTableView addSubview:self.identifyIconImageView];
    [self.mTableView addSubview:self.headerBgButton];
    [self.mTableView addSubview:self.avatarButton];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark- scroll

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        CGFloat offset = self.mTableView.contentOffset.y;
        [self animationForScroll:offset];
        
    }
    CGFloat topWhiteHeight = 120.f;
    CGRect firstSectionRect = [self.mTableView rectForHeaderInSection:0];
    topWhiteHeight = CGRectGetMaxY(firstSectionRect)-CGRectGetMaxY(self.headerBgImageView.frame);
    self.topContentWhiteView.frame = CGRectMake(0,
                                                CGRectGetMaxY(self.headerBgImageView.frame),
                                                CGRectGetWidth(self.frame),
                                                topWhiteHeight);
}

- (void)animationForScroll:(CGFloat) offset {
    
    CATransform3D headerTransform = CATransform3DIdentity;
    CATransform3D avatarTransform = CATransform3DIdentity;
    
    [self.avatarButton setHidden:NO];
    
    if (offset < 0) {
        CGFloat headerScaleFactor = -(offset) / self.headerView.bounds.size.height;
        CGFloat headerSizevariation = ((self.headerView.bounds.size.height * (1.0 + headerScaleFactor)) - self.headerView.bounds.size.height)/2.0;
        headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        
        self.headerView.layer.transform = headerTransform;
    } else {
        //  -----------  Header
        headerTransform = CATransform3DTranslate(headerTransform, 0, MAX(-kOffset_HeaderStop, -offset), 0);
        
        //  ------------ Label
        CATransform3D labelTransform = CATransform3DMakeTranslation(0, MAX(-kDistance_W_LabelHeader, kOffset_B_LabelHeader - offset), 0);
        self.headerLabel.layer.transform = labelTransform;
        self.headerLabel.textColor = [UIColor whiteColor];
        self.headerLabel.layer.zPosition = 2;
        
        //  ------------  Avatar
        CGFloat avatarScaleFactor = (MIN(kOffset_HeaderImageStop, offset)) / self.avatarImageView.bounds.size.height / 1.0;                  // Slow down the animation
        CGFloat avatarSizeVariation = ((self.avatarImageView.bounds.size.height * (1.0 + avatarScaleFactor)) - self.avatarImageView.bounds.size.height) / 2.0;
        avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0);
        avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0);
        
        if (offset <= kOffset_HeaderImageStop) {
            if (self.avatarImageView.layer.zPosition <= self.headerBgImageView.layer.zPosition) {
                self.headerView.layer.zPosition = 0;
                //                self.titleLabel.layer.zPosition -= 2;
            }
        } else {
            if (self.avatarImageView.layer.zPosition >= self.headerBgImageView.layer.zPosition) {
                self.headerView.layer.zPosition = 2;
            }
        }
    }
    if (self.headerBgImageView.image) {
        [self blurWithOffset:offset];
    }
    self.headerView.layer.transform = headerTransform;
    self.avatarImageView.layer.transform = avatarTransform;
}


#pragma mark- blur image handler
- (void) blurWithOffset:(float)offset {
    if (self.blurState != TwitterScrollBlurState_Done) {
        return;
    }
    
    NSInteger index = offset / 10;
    if (index < 0) {
        index = 0;
    }
    else if(index >= self.blurImages.count) {
        index = self.blurImages.count - 1;
    }
    UIImage *image = self.blurImages[index];
    if (self.headerBgImageView.image != image) {
        [self.headerBgImageView setImage:image];
    }
}

#pragma mark-
- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderViewHegiht)];
        _headerView.clipsToBounds = YES;
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UILabel *)headerLabel
{
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.f,
                                                                 self.headerView.frame.size.height - 5,
                                                                 kScreenWidth - 2*40.f,
                                                                 25)];
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.text = @"mosquito";
        _headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
        _headerLabel.textColor = [UIColor whiteColor];
    }
    return _headerLabel;
}

- (UIImageView *)headerBgImageView
{
    if (!_headerBgImageView) {
        _headerBgImageView = [[UIImageView alloc] initWithFrame:self.headerView.frame];
        _headerBgImageView.image = [UIImage imageNamed:@"mine_bg"];
        _headerBgImageView.userInteractionEnabled = YES;
        _headerBgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerBgImageView;
}

- (UITableView *)mTableView
{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.backgroundColor = [UIColor clearColor];
        _mTableView.clipsToBounds = YES;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mTableView;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - kAvatarSize) / 2.0, 90, kAvatarSize, kAvatarSize)];
        _avatarImageView.image = [UIImage imageNamed:@"moren_head"];
        _avatarImageView.userInteractionEnabled = YES;
        _avatarImageView.layer.cornerRadius = kAvatarSize/2.f;
        _avatarImageView.layer.borderWidth = 3;
        _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)userNameLabel
{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90+kAvatarSize+kMargin_Name_Avatar, kScreenWidth, 45.f)];
        _userNameLabel.text = @"mosquito";
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.textColor = [UIColor blackColor];
        _userNameLabel.font = [UIFont systemFontOfSize:26.f];
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _userNameLabel;
}

- (UIImageView *)identifyIconImageView
{
    if (!_identifyIconImageView) {
        _identifyIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v_icon"]];
        _identifyIconImageView.hidden = YES;
    }
    return _identifyIconImageView;
}

- (UIButton *)headerBgButton
{
    if (!_headerBgButton) {
        _headerBgButton = [[UIButton alloc] initWithFrame:self.headerView.frame];
        [_headerBgButton addTarget:self action:@selector(backgroundImageTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerBgButton;
}

- (UIButton *)avatarButton
{
    if (!_avatarButton) {
        _avatarButton = [[UIButton alloc] initWithFrame:self.avatarImageView.frame];
        [_avatarButton addTarget:self action:@selector(avatarImageTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarButton;
}

- (void)backgroundImageTapped:(UIButton *)sender {
    NSLog(@"backgroundImageTapped");
}

- (void)avatarImageTapped:(UIButton *)sender {
    NSLog(@"avatarImageTapped");
}

@end
