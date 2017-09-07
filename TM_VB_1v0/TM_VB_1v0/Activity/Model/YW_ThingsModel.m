

//
//  YW_ThingsModel.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/1.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_ThingsModel.h"

@implementation YW_ThingsModel

+(id)initWithDict:(NSDictionary *)dict
{
    YW_ThingsModel *model = [[self init] alloc];
    
    model.things_ID = dict[@"things_ID"];
    model.manufature_ID = dict[@"manufature_ID"];
    model.things_Type = dict[@"things_Type"];
    model.things_Data = dict[@"things_Data"];
    model.Pid = dict[@"Pid"];
    return model;
}

@end
