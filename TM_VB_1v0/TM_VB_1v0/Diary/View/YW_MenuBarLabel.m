//
//  YW_MenuBarLabel.m
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/26.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_MenuBarLabel.h"

@implementation YW_MenuBarLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:15];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end
