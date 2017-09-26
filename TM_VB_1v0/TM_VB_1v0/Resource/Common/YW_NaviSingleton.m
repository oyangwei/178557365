//
//  YW_NaviSingleton.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/26.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_NaviSingleton.h"


@implementation YW_NaviSingleton
static YW_NaviSingleton *_instance;

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

+(instancetype)shareInstance
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
