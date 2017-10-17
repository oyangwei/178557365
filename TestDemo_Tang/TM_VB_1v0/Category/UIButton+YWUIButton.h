//
//  UIButton+YWUIButton.h
//  Teleconmobile
//
//  Created by YangWei on 17/6/26.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YWUIButton)

+(UIButton *)createButtonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector Image:(UIImage *)image ImagePressed:(UIImage *)image;

+(UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title Target:(id)target Selector:(SEL)selector;

-(void)setUIButtonBorderColor:(CGColorRef)color borderWidth:(CGFloat)width borderRadius:(CGFloat)radius;

@end
