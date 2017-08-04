//
//  YW_UIGestureRecognizer.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/4.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_UIGestureRecognizer.h"

@implementation YW_UIGestureRecognizer

-(instancetype)initWithTarget:(id)target action:(SEL)action parameter:(NSString *)parameters
{
    self.name = parameters;
    return [self initWithTarget:target action:action];
}

@end
