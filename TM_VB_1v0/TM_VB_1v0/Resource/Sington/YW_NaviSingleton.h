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

/** 当前所处界面 */
@property(strong, nonatomic) NSString *mainTitle;

/** 当前所处界面 */
@property(strong, nonatomic) NSString *currentTitle;

/** DiaryNavigationViewController */
@property(strong, nonatomic) YW_NavigationController *diaryNVC;

/** ActivityNavigationViewController */
@property(strong, nonatomic) YW_NavigationController *activityNVC;

/** NewsNavigationViewController */
@property(strong, nonatomic) YW_NavigationController *newsNVC;

+(instancetype)shareInstance;

@end
