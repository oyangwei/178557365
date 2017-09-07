//
//  YW_ActivityViewController.h
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YW_ActivityViewController : UIViewController

/** 设置当前被选中的标题 */
-(void)setCurrentSelectedViewController:(NSInteger)currentItemNum;

/** 菜单栏功能选项 */
-(void)selectFunctionOfItemTitle:(NSString *)itemTitle;

@end
