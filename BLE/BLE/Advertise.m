//
//  Advertise.m
//  BLE
//
//  Created by YangWei on 2017/7/12.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "Advertise.h"

@implementation Advertise

+(id)instanceWithDictionary:(NSDictionary *)dict
{
    Advertise *ad = [[Advertise alloc] init];
    [ad setValuesForKeysWithDictionary:dict];
    return ad;
}

@end
