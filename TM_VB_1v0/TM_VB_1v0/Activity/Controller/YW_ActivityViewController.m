//
//  YW_ActivityViewController.m
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_ActivityViewController.h"
#import "YW_IconButton.h"
#import "YW_MenuSliderBar.h"
#import "YW_HomeViewController.h"
#import "YW_MenuButton.h"
#import "YW_MeViewController.h"
#import "YW_NewsViewController.h"
#import "YW_DiaryViewController.h"
#import "YW_NavigationController.h"
#import "YW_ActivityThingsViewController.h"
#import "YW_ActivityRecentViewController.h"

#define ButtonViewLeftMargin 30      // 存放按钮容器距离左边间距
#define ButtonColumnMarginSpace 35         // 按钮列间距
#define ButtonRowMarginSpace 30         // 按钮行间距
#define ColumnNumber 3                  // 列数
#define IconButtonLabelHeight 25     // 图标按钮文字高度
#define BottomMenuViewHeight 49     // 底部菜单高度


static NSString *const currentTitle = @"Activity";

@interface YW_ActivityViewController () <YWMenuButtonDelegate>

/** UIView */
@property(strong, nonatomic) UIView *mainView;

@end

@implementation YW_ActivityViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:ViewBgColor]];
    
    self.title = currentTitle;
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.height -= 64;
    
    [self setupContentView];
    
    [self.rootVC insertMenuButton:currentTitle];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)setupContentView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ButtonViewLeftMargin, 20, self.view.width - 2 * ButtonViewLeftMargin, self.view.height - BottomMenuViewHeight - 104)];
    self.mainView = view;
    [self.view addSubview:view];
    
    NSArray *iconTitles = [NSArray arrayWithObjects:@"Shares", @"Things", @"HotList", @"Active", nil];
    
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
            [button setTitleColor:[UIColor colorWithHexString:ViewTitleColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:button];
        }
    }
}

-(void)buttonClick:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"Shares"]) {
        
        
    }else if ([button.titleLabel.text isEqualToString:@"Things"])
    {
        YW_NavigationController *activityNVC = [YW_ActivityVCSingleton shareInstance].thingsVC;
        if (!activityNVC) {  //第一次访问
            YW_ActivityRecentViewController *thingsVC = [[YW_ActivityRecentViewController alloc] init];
            activityNVC = [[YW_NavigationController alloc] initWithRootViewController:thingsVC];
        }else
        {
            [activityNVC popToViewController:activityNVC.topViewController animated:YES];
        }
        [self.rootVC setupViewController:activityNVC];
    }else if ([button.titleLabel.text isEqualToString:@"HotList"])
    {
        
    }else if ([button.titleLabel.text isEqualToString:@"Active"])
    {
        
    }
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
