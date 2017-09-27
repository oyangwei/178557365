//
//  YW_DiaryViewController.m
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_MeViewController.h"
#import "YW_IconButton.h"
#import "YW_MenuSliderBar.h"
#import "YW_HomeViewController.h"
#import "YW_MenuButton.h"
#import "YW_NewsViewController.h"
#import "YW_ActivityViewController.h"
#import "YW_DiaryViewController.h"
#import "YW_NavigationController.h"

#define ButtonViewLeftMargin 30      // 存放按钮容器距离左边间距
#define ButtonColumnMarginSpace 35         // 按钮列间距
#define ButtonRowMarginSpace 30         // 按钮行间距
#define ColumnNumber 3                  // 列数
#define IconButtonLabelHeight 25     // 图标按钮文字高度
#define BottomMenuViewHeight 49     // 底部菜单高度


static NSString *const currentTitle = @"Me";

@interface YW_MeViewController () <YWMenuButtonDelegate>

/** UIView */
@property(strong, nonatomic) UIView *mainView;

@end

@implementation YW_MeViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self setUIViewBackgroud:self.view name:@"home_bg"];
    
    self.title = currentTitle;
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.height -= 64;
    
    [self setupContentView];
    
    [self.rootVC insertMenuButton:currentTitle];
    
}

-(void)setupContentView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ButtonViewLeftMargin, 20, self.view.width - 2 * ButtonViewLeftMargin, self.view.height - BottomMenuViewHeight - 104)];
    self.mainView = view;
    [self.view addSubview:view];
    
    NSArray *iconTitles = [NSArray arrayWithObjects:@"Me_01", @"Me_02", @"Me_03", nil];
    
    // 计算按钮的Y坐标 (从下往上排列)
    //  CGFloat buttonW = (view.width - (ColumnNumber - 1) * ButtonColumnMarginSpace) / ColumnNumber;
    //  CGFloat buttonH = buttonW + IconButtonLabelHeight;
    //  CGFloat buttonX = 0;
    //  CGFloat buttonY = view.height - buttonW;
    
    // 计算按钮的Y坐标(从上往下排列)
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    CGFloat buttonW = (view.width - (ColumnNumber - 1) * ButtonColumnMarginSpace) / ColumnNumber;
    CGFloat buttonH = buttonW + IconButtonLabelHeight;
    
    NSInteger rowNumber = iconTitles.count % ColumnNumber ? (NSInteger)(iconTitles.count / ColumnNumber) + 1 : (NSInteger)(iconTitles.count / ColumnNumber);   //计算行数
    
    for (int i = 0; i < rowNumber; i ++) {
        buttonY = buttonH * i + i * ButtonRowMarginSpace;  //计算按钮的Y坐标 (从上往下排列)
        
        //   buttonY = view.height - (buttonH * (i + 1) + i * ButtonRowMarginSpace);  //计算按钮的Y坐标(从下往上排列)
        
        CGFloat rowMaxCount = ColumnNumber;
        if (i == rowNumber - 1 && iconTitles.count % ColumnNumber != 0) {
            rowMaxCount = iconTitles.count % ColumnNumber;  //计算当前行存放的Button最大数量
        }
        
        for (int j = 0; j < rowMaxCount; j ++) {
            buttonX = buttonW * j + ButtonRowMarginSpace * j;
            
            YW_IconButton *button = [[YW_IconButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
            button.alpha = 0.7;
            [button setImage:[UIImage imageNamed:@"login_bg"] forState:UIControlStateNormal];
            [button setTitle:iconTitles[i * ColumnNumber + j] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:button];
        }
    }
}

-(void)setupBottomMenuView
{
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - BottomMenuViewHeight, self.view.width, BottomMenuViewHeight)];
    menuView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    UIButton *mainBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BottomMenuViewHeight, BottomMenuViewHeight)];
    [mainBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [mainBtn addTarget:self action:@selector(mainClick:) forControlEvents:UIControlEventTouchUpInside];
    
    YW_MenuSliderBar *sliderBar = [YW_MenuSingleton shareMenuInstance].sliderBar;
    sliderBar.currentTab = currentTitle;
    BOOL isExitBtn = false;
    for (YW_MenuButton *button in sliderBar.buttons) {
        if ([button.titleLabel.text isEqualToString:currentTitle]) {
            isExitBtn = YES;
            break;
        }
    }
    
    if (!isExitBtn) {
        [sliderBar insertMenuWithTitle:currentTitle];
    }
    
    __weak typeof(self) weakSelf = self;
    sliderBar.clickCloseBlock = ^(YW_MenuButton *button) {
        if ([button.titleLabel.text isEqualToString:currentTitle]) {
            YW_HomeViewController *homeVC = [[YW_HomeViewController alloc] init];
            weakSelf.view.window.rootViewController = homeVC;
        }
    };
    
    sliderBar.clickItemBlock = ^(YW_MenuButton *button) {
        if ([button.titleLabel.text isEqualToString:@"Diary"]) {
            YW_DiaryViewController *diaryVC = [[YW_DiaryViewController alloc] init];
            YW_NavigationController *nVC = [[YW_NavigationController alloc] initWithRootViewController:diaryVC];
            
            weakSelf.view.window.rootViewController = nVC;
        }else if ([button.titleLabel.text isEqualToString:@"Activity"])
        {
            YW_ActivityViewController *activityVC = [[YW_ActivityViewController alloc] init];
            YW_NavigationController *nVC = [[YW_NavigationController alloc] initWithRootViewController:activityVC];
            weakSelf.view.window.rootViewController = nVC;
        }else if ([button.titleLabel.text isEqualToString:@"News"])
        {
            YW_NewsViewController *newsVC = [[YW_NewsViewController alloc] init];
            YW_NavigationController *nVC = [[YW_NavigationController alloc] initWithRootViewController:newsVC];
            weakSelf.view.window.rootViewController = nVC;
        }
    };
    
    [[YW_MenuSingleton shareMenuInstance] setSliderBar:sliderBar];
    
    [menuView addSubview:[YW_MenuSingleton shareMenuInstance].sliderBar];
    [menuView addSubview:mainBtn];
    
    [self.view addSubview:menuView];
}

-(void)buttonClick:(UIButton *)button
{
    NSLog(@"%s, line = %d", __func__, __LINE__);
}

-(void)mainClick:(UIButton *)button
{
    YW_HomeViewController *homeVC = [[YW_HomeViewController alloc] init];
    self.view.window.rootViewController = homeVC;
}

-(void)shakeAnimation:(UIButton *)button
{
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    CGFloat angle = M_PI / 36;
    NSArray *values = @[@(angle), @(-angle), @(angle)];
    [shake setValues:values];
    [shake setRepeatCount:100];
    [shake setDuration:0.5];
    
    [button.imageView.layer addAnimation:shake forKey:nil];
    [button.imageView startAnimating];
    
}

@end
