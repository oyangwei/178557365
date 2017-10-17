//
//  YW_SliderMenuTool.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/14.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YW_SliderMenuTool : NSObject

/**
 * 根据底部控制器展示
 */
+ (void)showMenuWithRootViewController:(UIViewController *)rootViewController withToViewController:(Class)class;

+(void)showFunctionMenuWithRootViewController:(UIViewController *)rootViewController withToViewController:(Class)class;
/**
 * 隐藏菜单栏
 */
+ (void)hide;

@end
