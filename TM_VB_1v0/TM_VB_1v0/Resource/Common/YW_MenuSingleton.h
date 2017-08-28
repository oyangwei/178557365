//
//  YW_MenuSingleton.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YW_MenuSingleton : NSObject <NSCopying, NSMutableCopying>

/** Current View Title */
@property(strong, nonatomic) NSString *viewTitle;

/** Current Menu Title */
@property(strong, nonatomic) NSString *menuTitle;

/** Current SubMenu Title */
@property(strong, nonatomic) NSString *subMenuTitle;

/** 菜单项 */
@property(strong, nonatomic) NSMutableArray *menuControllersTitlesArr;

+(instancetype)shareMenuInstance;

@end
