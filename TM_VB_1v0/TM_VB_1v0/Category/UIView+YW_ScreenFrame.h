//
//  UIView+YW_ScreenFrame.h
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YW_ScreenFrame)

/** 自定义高度 */
@property(assign, nonatomic) CGFloat height;

/** 自定义宽度 */
@property(assign, nonatomic) CGFloat width;

/** 自定义X坐标 */
@property(assign, nonatomic) CGFloat x;

/** 自定义Y坐标 */
@property(assign, nonatomic) CGFloat y;

/** 自定义Size */
@property(assign, nonatomic) CGSize size;

@end
