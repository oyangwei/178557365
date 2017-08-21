//
//  YWRootTabBarViewController.m
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_RootTabBarController.h"
#import "YW_NavigationController.h"
#import "YW_DiaryViewController.h"
#import "YW_ActivityViewController.h"
#import "YW_DiscoveryViewController.h"
#import "YW_ShopViewController.h"
#import "YW_MeViewController.h"

@implementation YW_RootTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBar.tintColor = [UIColor redColor];
    
    [self setupChildVC:[[YW_DiaryViewController alloc] init] title:@"Diary" image:@"" selectedImage:@""];
    [self setupChildVC:[[YW_ActivityViewController alloc] init] title:@"Activity" image:@"" selectedImage:@""];
    [self setupChildVC:[[YW_DiscoveryViewController alloc] init] title:@"Discovery" image:@"" selectedImage:@""];
    [self setupChildVC:[[YW_ShopViewController alloc] init] title:@"Shop" image:@"" selectedImage:@""];
    [self setupChildVC:[[YW_MeViewController alloc] init] title:@"Me" image:@"" selectedImage:@""];
    
}

- (void)setupChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    YW_NavigationController *nVC = [[YW_NavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nVC];
}

@end
