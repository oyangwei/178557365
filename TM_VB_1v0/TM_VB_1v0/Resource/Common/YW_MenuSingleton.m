//
//  YW_MenuSingleton.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_MenuSingleton.h"

@implementation YW_MenuSingleton
static YW_MenuSingleton *_instance;

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+(instancetype)shareMenuInstance
{
    return [[self alloc] init];
}

-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

@end
