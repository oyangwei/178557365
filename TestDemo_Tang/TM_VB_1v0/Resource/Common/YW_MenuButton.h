//
//  YW_MenuButton.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YW_MenuButton;

@protocol YWMenuButtonDelegate <NSObject>
@optional

- (void)intoButtonEditStatus;

- (void)deleteButtonRemoveSelf:(YW_MenuButton *)button;

- (void)exitButtonEditStatus;

@end

@interface YW_MenuButton : UIButton

@property (nonatomic, weak) id<YWMenuButtonDelegate> delegate;

// 是否抖动
@property (nonatomic, assign, getter=isShaking) BOOL shaking;

@end
