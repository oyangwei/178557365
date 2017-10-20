//
//  YW_ThingsSingleTon.h
//  TestDemo_Tang
//
//  Created by Oyw on 2017/10/18.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YW_ThingsSingleTon : NSObject<NSCopying, NSMutableCopying>

/** Things数组 */
@property(strong, nonatomic) NSMutableArray *thingsArray;

+(instancetype)shareInstance;

@end
