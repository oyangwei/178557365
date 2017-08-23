//
//  YW_BaseNavigationController.m
//  Teleconmobile
//
//  Created by YangWei on 17/6/26.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_BaseNavigationController.h"

@interface YW_BaseNavigationController () <UINavigationControllerDelegate>

@property(strong, nonatomic) id popDelegate;

@end

@implementation YW_BaseNavigationController

+(void)initialize
{
    [self setupNavigationBar];
}

-(void)viewDidLoad
{
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.childViewControllers.count > 1;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >= 1) {   //如果现在push的不是栈底控制器（最先push进来的那个控制器）
        viewController.hidesBottomBarWhenPushed = YES;
        
        //设置导航栏按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        [button setImage:[UIImage imageNamed:@"default_back"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [button addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        // 就有滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    [super pushViewController:viewController animated:animated];
}

+(void)setupNavigationBar
{
    UINavigationBar *appearance = [UINavigationBar appearance];
//    appearance.translucent = NO;
    
    //统一设置导航栏颜色，如果单个界面需要设置，可以再viewWillAppear里面设置，在viewWillDisappear设置回统一格式。
    [appearance setBarTintColor:[UIColor colorWithHexString:ThemeColor alpha:1.0]];
    NSMutableDictionary *textAttribute = [NSMutableDictionary dictionary];
    textAttribute[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttribute[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [appearance setTitleTextAttributes:textAttribute];
}

// 完全展示完调用
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 如果展示的控制器是根控制器，就还原pop手势代理
    if (viewController == [self.viewControllers firstObject]) {
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }
}

-(void)popView
{
    [self popViewControllerAnimated:YES];
}

@end
