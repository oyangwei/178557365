//
//  YW_NavigationController.m
//  Teleconmobile
//
//  Created by YangWei on 17/6/26.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_NavigationController.h"

@interface YW_NavigationController ()

@property(strong, nonatomic) id popDelegate;

@end

@implementation YW_NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 * 这个方法是为了，后台进入前台，导航栏的位置会改变
 */
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.navigationBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
}

@end
