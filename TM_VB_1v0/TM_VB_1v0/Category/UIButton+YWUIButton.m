//
//  UIButton+YWUIButton.m
//  Teleconmobile
//
//  Created by YangWei on 17/6/26.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "UIButton+YWUIButton.h"

@implementation UIButton (YWUIButton)

+(UIButton *)createButtonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector Image:(NSString *)image ImagePressed:(NSString *)imagePressed
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    
    UIImage *newImage = [UIImage imageNamed:image];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    
    UIImage *newPressImage = [UIImage imageNamed:imagePressed];
    [button setBackgroundImage:newPressImage   forState:UIControlStateHighlighted];
    [button addTarget:target action:@selector(selector) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+(UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title Target:(id)target Selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)setUIButtonBorderColor:(CGColorRef)color borderWidth:(CGFloat)width borderRadius:(CGFloat)radius
{
    self.layer.borderColor = color;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
}

@end
