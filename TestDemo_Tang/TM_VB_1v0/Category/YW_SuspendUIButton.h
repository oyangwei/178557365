//
//  YW_SuspendUIButton.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/18.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  代理按钮的点击事件
 */
@protocol UIDragButtonDelegate <NSObject>

- (void)dragButtonClicked:(UIButton *)sender;

@end

@interface YW_SuspendUIButton : UIButton

/**
 *  悬浮窗所依赖的根视图
 */
@property (nonatomic, strong)UIView *rootView;

/**
 *  UIDragButton的点击事件代理
 */
@property (nonatomic, weak)id<UIDragButtonDelegate>btnDelegate;

@end
