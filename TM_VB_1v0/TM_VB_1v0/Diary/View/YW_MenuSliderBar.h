//
//  YW_MenuSliderBar.h
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YW_MenuBarLabel.h"

typedef void(^ClickItemBlock)(YW_MenuBarLabel *label);

@interface YW_MenuSliderBar : UIScrollView <UIScrollViewDelegate>

/** 屏幕可显示的最大数量 */
@property(assign, nonatomic) int maxShowNum;

/** 当前标签 */
@property(strong, nonatomic) NSString *currentTab;

-(void)setUpMenuWithTitleArr:(NSArray *)titleArr;

- (void)updateMenuWithTitleArr:(NSMutableArray *)titleArr;

/** 选中Item Block */
@property(copy, nonatomic) ClickItemBlock clickItemBlock;
@end
