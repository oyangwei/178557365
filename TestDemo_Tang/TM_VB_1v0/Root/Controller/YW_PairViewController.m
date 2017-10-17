//
//  YW_PairViewController.m
//  TestDemo_Tang
//
//  Created by Oyw on 2017/10/16.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_PairViewController.h"

@interface YW_PairViewController ()

@end

@implementation YW_PairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self.view setBackgroundColor:[UIColor redColor]];
}

-(void)setupNav
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:ThemeColor]];
    
}


@end
