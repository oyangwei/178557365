//
//  YW_ActivityVCSingleton.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/30.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YW_ActivityVCSingleton : NSObject <NSCopying, NSMutableCopying>

+(instancetype)shareInstance;

/** 最后一次访问的页面 */
@property(strong, nonatomic) NSString *lastVCTitle;

/** Share NavigationViewController */
@property(strong, nonatomic) YW_NavigationController *shareVC;

/** Things NavigationViewController */
@property(strong, nonatomic) YW_NavigationController *thingsVC;

/** HotList NavigationViewController */
@property(strong, nonatomic) YW_NavigationController *hotListVC;

/** Active NavigationViewController */
@property(strong, nonatomic) YW_NavigationController *activeVC;

@end
