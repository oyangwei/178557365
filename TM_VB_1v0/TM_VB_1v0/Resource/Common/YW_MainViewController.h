//
//  YW_MainViewController.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/27.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YW_MainViewController : UIViewController

/** 菜单栏 */
@property(strong, nonatomic) UIView *menuView;

-(void)setupViewController:(UIViewController *)vc;

-(void)insertMenuButton:(NSString *)title;

@end
