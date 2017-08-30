//
//  YW_AcitivityTestViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/28.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_AcitivityTestViewController.h"

#define TopViewHeight 64
#define TopIconWidth 30
#define IconWidth 44
#define FullScreeIconWidth 64
#define ButtonPadding 40

@interface YW_AcitivityTestViewController ()
{
    BOOL isFullScreen;
}

/** 顶栏 */
@property(strong, nonatomic) UIView *topView;

/** leftImageView */
@property(strong, nonatomic) UIImageView *leftImageView;

/** centerImageView */
@property(strong, nonatomic) UIImageView *centerImageView;

/** rightImageView */
@property(strong, nonatomic) UIImageView *rightImageView;

/** 内容 */
@property(strong, nonatomic) UIView *contentView;

/** upBtn */
@property(strong, nonatomic) UIButton *upBtn;

/** leftBtn */
@property(strong, nonatomic) UIButton *leftBtn;

/** downBtn */
@property(strong, nonatomic) UIButton *downBtn;

/** rightBtn */
@property(strong, nonatomic) UIButton *rightBtn;

/** bottomLeftBtn */
@property(strong, nonatomic) UIButton *bottomLeftBtn;

/** bottomRightBtn */
@property(strong, nonatomic) UIButton *bottomRightBtn;

/** fullScreenBtn */
@property(strong, nonatomic) UIButton *fullScreenBtn;

@end

@implementation YW_AcitivityTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTopBar];
    
    [self setupContentView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [_topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(!isFullScreen?TopViewHeight:TopViewHeight + 20);
    }];
    
    [_upBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
        make.height.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
    }];
    
    [_downBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
        make.height.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
    }];
    
    [_leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
        make.height.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
    }];
    
    [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
        make.height.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
    }];
    
    [_bottomLeftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
        make.height.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
    }];
    
    [_bottomRightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
        make.height.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
    }];
    
    [_fullScreenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
        make.height.mas_equalTo(!isFullScreen? IconWidth:FullScreeIconWidth);
    }];
}

-(void)loadViewIfNeeded
{
    [super loadViewIfNeeded];
}

-(void)setupTopBar
{
    UIView *topView = [[UIView alloc] init];
    topView.userInteractionEnabled = YES;
    topView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    leftImageView.contentMode = UIViewContentModeScaleToFill;
    leftImageView.image = [UIImage imageNamed:@"sofa"];
    
    UIImageView *centerImageView = [[UIImageView alloc] init];
    centerImageView.contentMode = UIViewContentModeScaleToFill;
    centerImageView.image = [UIImage imageNamed:@"logo"];
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    rightImageView.contentMode = UIViewContentModeScaleToFill;
    rightImageView.image = [UIImage imageNamed:@"refresh"];
    
    _topView = topView;
    _leftImageView = leftImageView;
    _centerImageView = centerImageView;
    _rightImageView = rightImageView;
    
    [topView addSubview:leftImageView];
    [topView addSubview:centerImageView];
    [topView addSubview:rightImageView];
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
    
    [centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.centerY.equalTo(topView.mas_centerY);
        make.width.mas_equalTo(TopIconWidth);
        make.height.mas_equalTo(TopIconWidth);
    }];
    
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(topView.mas_trailing).offset(-20);
        make.centerY.equalTo(topView.mas_centerY);
        make.width.mas_equalTo(TopIconWidth);
        make.height.mas_equalTo(TopIconWidth);
    }];
}

-(void)setupContentView
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, TopViewHeight, self.view.width, self.view.height - TopViewHeight)];
    [self setUIViewBackgroud:contentView name:@"testBg"];
    contentView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIButton *upBtn = [[UIButton alloc] init];
    [upBtn setImage:[UIImage imageNamed:@"upBtn"] forState:UIControlStateNormal];
    
    UIButton *downBtn = [[UIButton alloc] init];
    [downBtn setImage:[UIImage imageNamed:@"downBtn"] forState:UIControlStateNormal];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setImage:[UIImage imageNamed:@"leftBtn"] forState:UIControlStateNormal];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setImage:[UIImage imageNamed:@"rightBtn"] forState:UIControlStateNormal];
    
    UIButton *bottomLeftBtn = [[UIButton alloc] init];
    [bottomLeftBtn setImage:[UIImage imageNamed:@"leftBtn"] forState:UIControlStateNormal];
    
    UIButton *bottomRightBtn = [[UIButton alloc] init];
    [bottomRightBtn setImage:[UIImage imageNamed:@"rightBtn"] forState:UIControlStateNormal];
    
    UIButton *fullScreenBtn = [[UIButton alloc] init];
    [fullScreenBtn setImage:[UIImage imageNamed:@"full_screen"] forState:UIControlStateNormal];
    [fullScreenBtn addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    _contentView = contentView;
    _upBtn = upBtn;
    _leftBtn = leftBtn;
    _rightBtn = rightBtn;
    _downBtn = downBtn;
    _bottomLeftBtn = bottomLeftBtn;
    _bottomRightBtn = bottomRightBtn;
    _fullScreenBtn = fullScreenBtn;
    
    [contentView addSubview:upBtn];
    [contentView addSubview:downBtn];
    [contentView addSubview:leftBtn];
    [contentView addSubview:rightBtn];
    [contentView addSubview:bottomLeftBtn];
    [contentView addSubview:bottomRightBtn];
    [contentView addSubview:fullScreenBtn];
    [self.view addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_trailing);
        make.leading.equalTo(self.view.mas_leading);
        make.top.equalTo(self.view.mas_top).offset(TopViewHeight);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.centerY.equalTo(contentView.mas_centerY);
        make.width.mas_equalTo(IconWidth);
        make.height.mas_equalTo(IconWidth);
    }];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(downBtn.mas_leading).offset(-ButtonPadding);
        make.bottom.equalTo(downBtn.mas_top).offset(- ButtonPadding);
        make.width.mas_equalTo(IconWidth);
        make.height.mas_equalTo(IconWidth);
    }];
    
    [upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.bottom.equalTo(leftBtn.mas_top).offset(- ButtonPadding);
        make.width.mas_equalTo(IconWidth);
        make.height.mas_equalTo(IconWidth);
    }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(downBtn.mas_trailing).offset(ButtonPadding);
        make.bottom.equalTo(downBtn.mas_top).offset(- ButtonPadding);
        make.width.mas_equalTo(IconWidth);
        make.height.mas_equalTo(IconWidth);
    }];
    
    [bottomLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(downBtn.mas_leading).offset(-ButtonPadding);
        make.top.equalTo(downBtn.mas_bottom).offset(60);
        make.width.mas_equalTo(IconWidth);
        make.height.mas_equalTo(IconWidth);
    }];
    
    [bottomRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(downBtn.mas_trailing).offset(ButtonPadding);
        make.top.equalTo(downBtn.mas_bottom).offset(60);
        make.width.mas_equalTo(IconWidth);
        make.height.mas_equalTo(IconWidth);
    }];
    
    [fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(contentView.mas_trailing).offset(-20);
        make.bottom.equalTo(contentView.mas_bottom).offset(-20);
        make.width.mas_equalTo(IconWidth - 10);
        make.height.mas_equalTo(IconWidth - 10);
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
