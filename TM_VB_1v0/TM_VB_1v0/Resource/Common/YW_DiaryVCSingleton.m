//
//  YW_DiaryVCSingleton.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/28.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_DiaryVCSingleton.h"

static YW_DiaryVCSingleton *_instance;
@implementation YW_DiaryVCSingleton

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    [super allocWithZone:zone];
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
