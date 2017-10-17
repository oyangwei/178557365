//
//  YW_AnimateMemuViewController.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/16.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YW_AnimateMemuViewController : UIViewController

/** rootVc */
@property (nonatomic, strong) UIViewController *rootViewController;

/** 目标菜单控制器 */
@property(strong, nonatomic) Class destClass;

/** hideStatusBar */
@property (nonatomic, assign) BOOL hideStatusBar;

/** 显示方式 */
@property(assign, nonatomic) YW_ShowMenuStyles showMenuStyle;

-(void)closeMenu;

@end
