//
//  YW_DiaryVCSingleton.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/28.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YW_NavigationController.h"

@interface YW_DiaryVCSingleton : NSObject <NSCopying, NSMutableCopying>

+ (instancetype)shareInstance;

/** 记录DiaryVC的NVC */
@property(strong, nonatomic) YW_NavigationController *chatVC;
@property(strong, nonatomic) YW_NavigationController *contactVC;

/** 最后一次访问的界面 */
@property(strong, nonatomic) NSString *lastVCTitle;

@end
