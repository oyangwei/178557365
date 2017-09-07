//
//  YW_MainMenuItem.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/16.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ItemAction)();

@interface YW_MainMenuItem : NSObject

/** 图标 */
@property(strong, nonatomic) NSString *icon;

/** 标题 */
@property(strong, nonatomic) NSString *itmeTitle;

/**  点击事件 */
@property(copy, nonatomic) ItemAction itemAction;

/** 选择Item的序号 */
@property(assign, nonatomic) int destVcNum;

/** 点击某行跳转的控制器 */
@property(strong, nonatomic) Class destVcClass;

+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destClass;

+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcNumber:(int)num;

@end
