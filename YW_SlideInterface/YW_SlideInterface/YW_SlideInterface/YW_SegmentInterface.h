//
//  YW_SegmentInterface.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/11.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YW_SegmentInterface : UIView

/** 设置TitleScrollView的Frame */
@property(assign, nonatomic) CGRect titleScrollViewFrame;

#pragma mark - TitleScrollView属性设置
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

/** 当前页面选择的item序号 */
@property(assign, nonatomic) int currentItemNum;



/** 添加控制器的方法(添加控制器按照控制器添加的先后顺序与按钮对应的 */
-(void)intoChildControllerArray:(NSMutableArray *)childControllerArray isInsert:(BOOL)isInsert;

/** 添加标题栏的方法 */
-(void)intoTitlesArray:(NSMutableArray *)titlesArray hostController:(UIViewController *)hostController;

-(void)insertTitle:(NSString *)title childVC:(UIViewController *)childVC position:(int)pos;

@end
