//
//  YWCommonMethod.h
//  Teleconmobile
//
//  Created by YangWei on 17/6/28.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWCommonMethod : NSObject

+(id)sharedCommonMethod;

-(BOOL)validMobile:(NSString *)mobile;   //判断手机号码格式是否正确


-(UIImage *)imageWithColorOfHexString:(NSString *)colorStr;  //颜色转图片。

-(UIImage *)imageWithColor:(UIColor *)color;

@end
