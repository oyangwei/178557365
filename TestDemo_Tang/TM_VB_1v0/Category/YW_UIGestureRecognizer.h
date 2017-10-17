//
//  YW_UIGestureRecognizer.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/4.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YW_UIGestureRecognizer : UILongPressGestureRecognizer

/** 名称 */
@property(strong, nonatomic) NSString *name;

-(instancetype)initWithTarget:(id)target action:(SEL)action parameter:(NSString *)parameters;

@end
