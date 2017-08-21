//
//  YW_TitleScrollView.h
//  YW_SlideInterface
//
//  Created by Oyw on 2017/8/11.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YW_TabItem.h"

typedef void (^TabItemClickBlock)(int currentNum, YW_TabItem *item);

@interface YW_TitleScrollView : UIScrollView

/** 当前屏幕显示的个数 */
@property(assign, nonatomic) int showItemCount;

/** 未选中时item字体颜色 */
@property(strong, nonatomic) UIColor *itemNormalTextColor;

/** 未选中时item背景色 */
@property(strong, nonatomic) UIColor *itemSelectedTextColor;

/** 选中时item字体颜色 */
@property(strong, nonatomic) UIColor *itemNormalBackgroudColor;

/** 选中时item背景色 */
@property(strong, nonatomic) UIColor *itemSelectedBackgroudColor;

/** 默认选择的item序号 */
@property(assign, nonatomic) int defaultSelectNum;

/** 选择item Block函数 */
@property(copy, nonatomic) TabItemClickBlock tabItemClickBlock;

-(void)intoTitleArray:(NSArray *)titles;

-(void)setSelectedItem:(int)itemNum;

@end
