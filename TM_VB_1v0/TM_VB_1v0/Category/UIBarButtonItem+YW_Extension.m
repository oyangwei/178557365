//
//  UIBarButtonItem+YW_Extension.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/29.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "UIBarButtonItem+YW_Extension.h"

@implementation UIBarButtonItem (YW_Extension)

+(instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}

@end
