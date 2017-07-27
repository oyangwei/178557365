//
//  Advertise.h
//  BLE
//
//  Created by YangWei on 2017/7/12.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Advertise : NSObject

+(id)instanceWithDictionary:(NSDictionary *)dict;

@property(strong, nonatomic) NSString *packet;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSNumber *RSSI;

@end
