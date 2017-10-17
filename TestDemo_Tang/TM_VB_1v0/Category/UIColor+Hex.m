//
//  UIColor+Hex.m
//  海外英才
//
//  Created by administrator on 16/10/8.
//  Copyright © 2016年 Administrator. All rights reserved.
//


#import "UIColor+Hex.h"

@implementation UIColor (Hex)


+(UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //字符串是6 或者 8 个字符
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    //如果是0x开头，那么截取字符串，从2开始到末尾
    if([cString hasPrefix:@"0x"]){
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，从1开始到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    //separate into r,g,b substring
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    //scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
    
}

+(UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}

@end

