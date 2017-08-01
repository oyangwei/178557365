//
//  YW_NaviBarListViewController.h
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/26.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ListItemBlock)(NSInteger index);

@interface YW_NaviBarListViewController : UIViewController

/** 分割线高度 */
@property(assign, nonatomic) CGFloat labelLineH;

/** Items */
@property(strong, nonatomic) NSArray *titles;

/** ListItemBlock */
@property(copy, nonatomic) ListItemBlock listItemBlock;

-(void)updateItems:(NSArray *)titles;

@end
