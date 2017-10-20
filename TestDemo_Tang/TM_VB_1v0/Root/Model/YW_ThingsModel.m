//
//  YW_ThingsModel.m
//  TestDemo_Tang
//
//  Created by Oyw on 2017/10/18.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_ThingsModel.h"

@implementation YW_ThingsModel

+(instancetype)thingsModel:(NSDictionary *)dict
{
    YW_ThingsModel *model = [[YW_ThingsModel alloc] init];
    model.iconName = dict[@"Icon"];
    model.productName = dict[@"Name"];
    return model;
}

@end
