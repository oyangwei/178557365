//
//  YW_MenuSliderBar.h
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YW_MenuBarLabel.h"
#import "DMPagingScrollView.h"

@class YW_MenuButton;

typedef void(^ClickItemBlock)(YW_MenuButton *button);

typedef void(^ClickCloseBlock)(YW_MenuButton *button);

@interface YW_MenuSliderBar : UIScrollView <UIScrollViewDelegate>

/** 屏幕可显示的最大数量 */
@property(assign, nonatomic) int maxShowNum;

/** 按钮数组 */
@property(strong, nonatomic) NSMutableArray *buttons;

/** 当前标签 */
@property(strong, nonatomic) NSString *currentTab;

-(void)setUpMenuWithTitleArr:(NSMutableArray *)titleArr;

- (void)updateMenuWithTitleArr:(NSMutableArray *)titleArr;

- (void)insertMenuWithTitle:(NSString *)title;

- (void)removeMenuWithTitle:(NSString *)title;

/** 选中Item Block */
@property(copy, nonatomic) ClickItemBlock clickItemBlock;

/** 关闭Item Block */
@property(copy, nonatomic) ClickCloseBlock clickCloseBlock;

@end
