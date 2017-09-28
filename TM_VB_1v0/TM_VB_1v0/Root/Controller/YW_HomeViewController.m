//
//  YW_HomeViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/22.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_HomeViewController.h"
#import "YW_IconButton.h"
#import "YW_MenuSliderBar.h"
#import "YW_DiaryViewController.h"
#import "YW_NavigationController.h"
#import "YW_ActivityViewController.h"
#import "YW_NewsViewController.h"
#import "YW_MeViewController.h"
#import "YW_MenuButton.h"
#import "YW_MainViewController.h"
#import "SPKitExample.h"

#define ButtonViewLeftMargin 30      // 存放按钮容器距离左边间距
#define ButtonColumnMarginSpace 35         // 按钮列间距
#define ButtonRowMarginSpace 30         // 按钮行间距
#define ColumnNumber 3                  // 列数
#define IconButtonLabelHeight 25     // 图标按钮文字高度
#define BottomMenuViewHeight 49     // 底部菜单高度

static NSString *const currentTitle = @"home";

@interface YW_HomeViewController ()

/** 父控制器 */
@property(strong, nonatomic) YW_MainViewController *mainVC;

@end

@implementation YW_HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.mainVC = (YW_MainViewController *)self.parentViewController;
    
    [self setupContentView];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mainVC insertMenuButton:currentTitle];
}

-(void)setupContentView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ButtonViewLeftMargin, 64, self.view.width - 2 * ButtonViewLeftMargin, self.view.height - 49 - 104)];
    [self.view addSubview:view];
    
    NSArray *iconTitles = [NSArray arrayWithObjects:@"Diary", @"Activity", @"News", @"Me", nil];
    
    // 计算按钮的Y坐标 (从下往上排列)
//    CGFloat buttonW = (view.width - (ColumnNumber - 1) * ButtonColumnMarginSpace) / ColumnNumber;
  //  CGFloat buttonH = buttonW + IconButtonLabelHeight;
 //   CGFloat buttonX = 0;
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
        if (i == rowNumber - 1) {
            rowMaxCount = iconTitles.count % ColumnNumber;  //计算当前行存放的Button最大数量
        }
        
        for (int j = 0; j < rowMaxCount; j ++) {
            buttonX = buttonW * j + ButtonRowMarginSpace * j;
            
            YW_IconButton *button = [[YW_IconButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
            button.tag = 100 + i * ColumnNumber + j;
            button.alpha = 0.7;
            [button setImage:[UIImage imageNamed:@"testBg"] forState:UIControlStateNormal];
            [button setTitle:iconTitles[i * ColumnNumber + j] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:button];
        }
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)buttonClick:(UIButton *)button
{
    switch (button.tag - 100) {
        case 0:
        {
            YW_NavigationController *diaryNVC = [YW_NaviSingleton shareInstance].diaryNVC;
            if (!diaryNVC) {   //第一次进入,创建新的diaryVC
                YW_DiaryViewController *diaryVC = [[YW_DiaryViewController alloc] init];
                diaryVC.rootVC = self.mainVC;
                diaryNVC = [[YW_NavigationController alloc] initWithRootViewController:diaryVC];
                [[YW_NaviSingleton shareInstance] setDiaryNVC:diaryNVC];
                [self.mainVC setupViewController:diaryNVC];
            }else
            {
                [self.mainVC setupViewController:diaryNVC];
                
            }
            break;
        }
        case 1:
        {
            YW_ActivityViewController *activityVC = [[YW_ActivityViewController alloc] init];
            activityVC.rootVC = self.mainVC;
            YW_NavigationController *nVC = [[YW_NavigationController alloc] initWithRootViewController:activityVC];
            
            [self.mainVC setupViewController:nVC];
            break;
        }
        case 2:
        {
            YW_NavigationController *nVC = [YW_NaviSingleton shareInstance].newsNVC;
            if (!nVC) {   //第一次进入,创建新的newsVC
                YW_NewsViewController *newsVC = [[YW_NewsViewController alloc] init];
                newsVC.rootVC = self.mainVC;
                nVC = [[YW_NavigationController alloc] initWithRootViewController:newsVC];
                [[YW_NaviSingleton shareInstance] setNewsNVC:nVC];
            }
            
            [nVC popToViewController:nVC.topViewController animated:YES];
            
            [self.mainVC setupViewController:nVC];
            break;
        }
        case 3:
        {
            YW_MeViewController *meVC = [[YW_MeViewController alloc] init];
            meVC.rootVC = self.mainVC;
            YW_NavigationController *nVC = [[YW_NavigationController alloc] initWithRootViewController:meVC];
            
            [self.mainVC setupViewController:nVC];
            break;
        }
        default:
            break;
    }
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
