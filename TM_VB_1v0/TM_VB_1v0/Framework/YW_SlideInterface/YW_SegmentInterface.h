//
//  YW_SegmentInterface.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/11.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YW_TabItem.h"

@class YW_SegmentInterface;

@protocol SegmentInterfaceDelegate <NSObject>

@required

@optional
- (void)yw_ClickEvent:(YW_TabItem *)tabItem childViewController:(UIViewController *)childViewController segmentInterface:(YW_SegmentInterface *)segmentInterface;

-(void)childVC_scrollView:(UIScrollView *)scrollView;

@end

@interface YW_SegmentInterface : UIView

/** 协议代理 */
@property(weak, nonatomic) id<SegmentInterfaceDelegate> delegate;

/** 设置TitleScrollView的Frame */
@property(assign, nonatomic) CGRect titleScrollViewFrame;

/** 设置ChildScrollView的Frame */
@property(assign, nonatomic) CGRect childScrollViewFrame;

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

/** 子控制器是否可以滚动 */
@property(assign, nonatomic) BOOL isChildScrollEnabel;


/** 添加控制器的方法(添加控制器按照控制器添加的先后顺序与按钮对应的 */
-(void)intoChildControllerArray:(NSMutableArray *)childControllerArray isInsert:(BOOL)isInsert;

/** 添加标题栏的方法 */
-(void)intoTitlesArray:(NSMutableArray *)titlesArray hostController:(UIViewController *)hostController;

-(void)insertTitle:(NSString *)title childVC:(UIViewController *)childVC position:(int)pos;

-(void)updateTitle:(NSString *)title childVC:(UIViewController *)childVC position:(int)pos;

-(void)deleteTitle:(NSString *)title childVC:(UIViewController *)childVC position:(int)pos;

-(void)setCurrentSelectedItemNum:(int)index;

@end
