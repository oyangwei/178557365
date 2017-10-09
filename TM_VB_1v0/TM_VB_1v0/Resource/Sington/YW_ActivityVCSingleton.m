//
//  YW_ActivityVCSingleton.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/30.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_ActivityVCSingleton.h"

static YW_ActivityVCSingleton *_instance;

@implementation YW_ActivityVCSingleton

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
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
