//
//  YW_SliderMenuTool.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/14.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_SliderMenuTool.h"
#import "YW_AnimateMemuViewController.h"
#import "YW_BaseNavigationController.h"
#import "YW_MainMenuViewController.h"
#import "YW_SubMenuViewController.h"

@implementation YW_SliderMenuTool

static UIWindow *menuWindow;

/**
 * 根据底部控制器展示
 */
+(void)showMenuWithRootViewController:(UIViewController *)rootViewController withToViewController:(Class)class
{
    menuWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    menuWindow.backgroundColor = [UIColor clearColor];
    menuWindow.hidden = NO;
    
    YW_AnimateMemuViewController *vc = [[YW_AnimateMemuViewController alloc] init];
    vc.destClass = class;
    vc.showMenuStyle = YW_ShowMenuFromLeft;
    vc.view.backgroundColor = [UIColor clearColor];
    vc.rootViewController = rootViewController;
    YW_BaseNavigationController *nav = [[YW_BaseNavigationController alloc] initWithRootViewController:vc];
    nav.view.backgroundColor = [UIColor clearColor];
    menuWindow.rootViewController = nav;
    [menuWindow addSubview:nav.view];
}

+(void)showFunctionMenuWithRootViewController:(UIViewController *)rootViewController withToViewController:(Class)class
{
    menuWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    menuWindow.backgroundColor = [UIColor clearColor];
    menuWindow.hidden = NO;
    
    YW_AnimateMemuViewController *vc = [[YW_AnimateMemuViewController alloc] init];
    vc.destClass = class;
    vc.showMenuStyle = YW_ShowMenuFromRight;
    vc.rootViewController = rootViewController;
    YW_BaseNavigationController *nVC = [[YW_BaseNavigationController alloc] initWithRootViewController:vc];
    nVC.view.backgroundColor = [UIColor clearColor];
    menuWindow.rootViewController = nVC;
    [menuWindow addSubview:nVC.view];
}

+(void)hide
{
    menuWindow.hidden = YES;
    menuWindow.rootViewController = nil;
    menuWindow = nil;
}

@end
