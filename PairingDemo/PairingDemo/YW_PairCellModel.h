//
//  YW_PairCellModel.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/13.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YW_PairCellModel : NSObject

/** ThingType */
@property(strong, nonatomic) NSString *thingType;

/** ThingProductInfo */
@property(strong, nonatomic) NSString *productInfo;
    
/** UUID */
@property(strong, nonatomic) NSString *uuid;

+(id)initWithDict:(NSDictionary *)dict;

@end
