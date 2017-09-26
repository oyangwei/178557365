//
//  YW_New01ViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/26.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_New01ViewController.h"
#import "YW_IconButton.h"
#import "YW_MenuSliderBar.h"
#import "YW_HomeViewController.h"
#import "YW_MenuButton.h"
#import "YW_MeViewController.h"
#import "YW_ActivityViewController.h"
#import "YW_DiaryViewController.h"
#import "YW_NavigationController.h"
#import "YW_New02ViewController.h"

#define ButtonViewLeftMargin 30      // 存放按钮容器距离左边间距
#define ButtonColumnMarginSpace 35         // 按钮列间距
#define ButtonRowMarginSpace 30         // 按钮行间距
#define ColumnNumber 3                  // 列数
#define IconButtonLabelHeight 25     // 图标按钮文字高度
#define BottomMenuViewHeight 49     // 底部菜单高度

static NSString *const currentTitle = @"News";
@interface YW_New01ViewController ()

@end

@implementation YW_New01ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self setupBottomMenuView];
    
    [[YW_NaviSingleton shareInstance] setNewsNVC:(YW_NavigationController *)self.navigationController];
    
}

-(void)setupBottomMenuView
{
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - BottomMenuViewHeight - 64, self.view.width, BottomMenuViewHeight)];
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
        }else if ([button.titleLabel.text isEqualToString:@"Me"])
        {
            YW_MeViewController *meVC = [[YW_MeViewController alloc] init];
            YW_NavigationController *nVC = [[YW_NavigationController alloc] initWithRootViewController:meVC];
            weakSelf.view.window.rootViewController = nVC;
        }
    };
    
    [[YW_MenuSingleton shareMenuInstance] setSliderBar:sliderBar];
    
    [menuView addSubview:[YW_MenuSingleton shareMenuInstance].sliderBar];
    [menuView addSubview:mainBtn];
    
    [self.view addSubview:menuView];
}

-(void)mainClick:(UIButton *)button
{
    YW_HomeViewController *homeVC = [[YW_HomeViewController alloc] init];
    self.view.window.rootViewController = homeVC;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    YW_New02ViewController *news02VC = [[YW_New02ViewController alloc] init];
    [self.navigationController pushViewController:news02VC animated:YES];
}

@end
