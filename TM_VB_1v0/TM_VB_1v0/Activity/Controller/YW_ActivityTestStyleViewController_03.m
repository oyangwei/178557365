//
//  YW_ActivityTestStyleViewController_03.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/29.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_ActivityTestStyleViewController_03.h"

#define TopViewHeight 64
#define TopIconWidth 30
#define IconWidth 60
#define FullScreeIconWidth 80
#define ButtonPadding 40

@interface YW_ActivityTestStyleViewController_03 ()
{
    BOOL isFullScreen;
}

/** 顶栏 */
@property(strong, nonatomic) UIView *topView;

/** leftImageView */
@property(strong, nonatomic) UIImageView *leftImageView;

/** 内容 */
@property(strong, nonatomic) UIView *contentView;

/** firstBtn */
@property(strong, nonatomic) UIButton *firstBtn;

/** secondBtn */
@property(strong, nonatomic) UIButton *secondBtn;

/** fullScreenBtn */
@property(strong, nonatomic) UIButton *fullScreenBtn;

@end

@implementation YW_ActivityTestStyleViewController_03

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    [self setupTopBar];
    
    [self setupContentView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [_topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(!isFullScreen?TopViewHeight:TopViewHeight + 20);
    }];
    
    [_firstBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
        make.height.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
    }];
    
    [_secondBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
        make.height.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
    }];
    
    [_fullScreenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(!isFullScreen? 40:64);
        make.height.mas_equalTo(!isFullScreen? 40:64);
    }];
}

-(void)setupTopBar
{
    UIView *topView = [[UIView alloc] init];
    topView.userInteractionEnabled = YES;
    topView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    leftImageView.contentMode = UIViewContentModeScaleToFill;
    leftImageView.image = [UIImage imageNamed:@"logo"];
    
    _topView = topView;
    _leftImageView = leftImageView;
    
    [topView addSubview:leftImageView];
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_equalTo(TopViewHeight);
    }];
    
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(topView.mas_leading).offset(20);
        make.centerY.equalTo(topView.mas_centerY);
        make.width.mas_equalTo(TopIconWidth);
        make.height.mas_equalTo(TopIconWidth);
    }];
    
}

-(void)setupContentView
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, TopViewHeight, self.view.width, self.view.height - TopViewHeight)];
    [self setUIViewBackgroud:contentView name:@"testBg"];
    
    UIButton *firstBtn = [[UIButton alloc] init];
    [firstBtn setImage:[UIImage imageNamed:@"firstBtn"] forState:UIControlStateNormal];
    
    UIButton *secondBtn = [[UIButton alloc] init];
    [secondBtn setImage:[UIImage imageNamed:@"secondBtn"] forState:UIControlStateNormal];
    
    UIButton *fullScreenBtn = [[UIButton alloc] init];
    [fullScreenBtn setImage:[UIImage imageNamed:@"full_screen"] forState:UIControlStateNormal];
    [fullScreenBtn addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    _contentView = contentView;
    _firstBtn = firstBtn;
    _secondBtn = secondBtn;
    _fullScreenBtn = fullScreenBtn;
    
    [contentView addSubview:firstBtn];
    [contentView addSubview:secondBtn];
    [contentView addSubview:fullScreenBtn];
    [self.view addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_trailing);
        make.leading.equalTo(self.view.mas_leading);
        make.top.equalTo(self.view.mas_top).offset(TopViewHeight);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.centerY.equalTo(contentView.mas_centerY);
        make.width.mas_equalTo(IconWidth);
        make.height.mas_equalTo(IconWidth);
    }];
    
    [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.bottom.equalTo(secondBtn.mas_top).offset(-60);
        make.width.mas_equalTo(IconWidth);
        make.height.mas_equalTo(IconWidth);
    }];
    
    [fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(contentView.mas_trailing).offset(-20);
        make.bottom.equalTo(contentView.mas_bottom).offset(-20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - 进入或退出全屏
-(void)fullScreen:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (self.fullScreenPattern) {
        isFullScreen = !isFullScreen;
        [_fullScreenBtn setImage:[UIImage imageNamed:!isFullScreen?@"full_screen":@"exit_full_screen"] forState:UIControlStateNormal];
        self.fullScreenPattern(btn.selected);
        btn.selected = !btn.selected;
    }
}

@end
