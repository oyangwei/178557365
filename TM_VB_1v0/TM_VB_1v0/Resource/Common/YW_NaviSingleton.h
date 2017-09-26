//
//  YW_NaviSingleton.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/26.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YW_NavigationController.h"

@interface YW_NaviSingleton : NSObject <NSCopying, NSMutableCopying>

/** DiaryNavigationViewController */
@property(strong, nonatomic) YW_NavigationController *diaryNVC;

/** NewsNavigationViewController */
@property(strong, nonatomic) YW_NavigationController *newsNVC;

+(instancetype)shareInstance;

@end
