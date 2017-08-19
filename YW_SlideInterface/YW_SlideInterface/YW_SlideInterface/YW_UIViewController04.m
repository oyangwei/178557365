//
//  YW_UIViewController04.m
//  YW_SlideInterface
//
//  Created by Oyw on 2017/8/19.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_UIViewController04.h"

@interface YW_UIViewController04 ()

@end

@implementation YW_UIViewController04

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256.0) / 255.0 green:arc4random_uniform(256.0) / 255.0 blue:arc4random_uniform(256.0) / 255.0 alpha:1.0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
