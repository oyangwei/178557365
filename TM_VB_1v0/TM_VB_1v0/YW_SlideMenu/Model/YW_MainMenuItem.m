//
//  YW_MainMenuItem.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/16.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_MainMenuItem.h"

@implementation YW_MainMenuItem

+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destClass
{
    YW_MainMenuItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    item.destVcClass = destClass;
    return item;
}

+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcNumber:(int)destVcNum
{
    YW_MainMenuItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    item.destVcNum = destVcNum;
    return item;
}

@end
