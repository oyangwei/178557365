//
//  YW_ThingsModel.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/1.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YW_ThingsModel : NSObject

/** things_ID */
@property(strong, nonatomic) NSString *things_ID;

/** manufature_ID */
@property(strong, nonatomic) NSString *manufature_ID;

/** things_Type */
@property(strong, nonatomic) NSString *things_Type;

/** things_Data */
@property(strong, nonatomic) NSString *things_Data;

/** Pid */
@property(strong, nonatomic) NSString *Pid;

+(id)initWithDict:(NSDictionary *)dict;

@end
