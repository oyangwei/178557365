//
//  YW_PairCellModel.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/13.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_PairCellModel.h"

@implementation YW_PairCellModel

+(id)initWithDict:(NSDictionary *)dict
{
    YW_PairCellModel *model = [[self alloc] init];
    model.thingType = dict[@"ThingType"];
    model.productInfo = dict[@"ProductInfo"];
    model.uuid = dict[@"uuid"];
    return model;
}

@end
