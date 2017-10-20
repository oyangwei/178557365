//
//  YW_ThingsSingleTon.m
//  TestDemo_Tang
//
//  Created by Oyw on 2017/10/18.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_ThingsSingleTon.h"

static YW_ThingsSingleTon *_instance;
@implementation YW_ThingsSingleTon

+(instancetype)shareInstance
{
    return [[self alloc] init];
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (_instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [super allocWithZone:zone];
        });
    }
    return _instance;
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
