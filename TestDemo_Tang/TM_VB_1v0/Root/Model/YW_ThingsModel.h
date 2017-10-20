//
//  YW_ThingsModel.h
//  TestDemo_Tang
//
//  Created by Oyw on 2017/10/18.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YW_ThingsModel : NSObject

/** 产品图片 */
@property(strong, nonatomic) NSString *iconName;

/** 产品名 */
@property(strong, nonatomic) NSString *productName;

+(instancetype)thingsModel:(NSDictionary *)dict;
@end
