//
//  YW_MenuSliderBar.m
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_MenuSliderBar.h"
#import "UIView+YW_ScreenFrame.h"
#import "YW_MenuButton.h"


@interface YW_MenuSliderBar () <YWMenuButtonDelegate>

@end

@implementation YW_MenuSliderBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.alwaysBounceVertical = NO;
    }
    return self;
}

-(void)setUpMenuWithTitleArr:(NSMutableArray *)titleArr
{
    self.buttons = [[NSMutableArray alloc] init];
    self.currentTab = titleArr[0];
    CGFloat buttonW = (self.width) / self.maxShowNum;
    CGFloat buttonH = self.height;
    CGFloat buttonY = 0;
    
    for (int i = 0; i < titleArr.count; i ++) {
        CGFloat buttonX = i * buttonW;
        
        YW_MenuButton *button = [[YW_MenuButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.delegate = self;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tapMenuItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.buttons addObject:button];
        [self addSubview:button];
    }
    
    self.contentSize = CGSizeMake(titleArr.count * buttonW, 0);
}

- (void)updateMenuWithTitleArr:(NSMutableArray *)titleArr
{
    for (id subviews in self.subviews) {
        [subviews removeFromSuperview];
    }
    
    [self setUpMenuWithTitleArr:titleArr];
    
}

-(void)insertMenuWithTitle:(NSString *)title
{
    CGFloat buttonW = (self.width) / self.maxShowNum;
    CGFloat buttonH = self.height;
    CGFloat buttonY = 0;
    CGFloat buttonX = self.buttons.count * buttonW;
    
    YW_MenuButton *button = [[YW_MenuButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    [button setTitle:title forState:UIControlStateNormal];
    button.delegate = self;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapMenuItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttons addObject:button];
    [self addSubview:button];
    
    self.contentSize = CGSizeMake(self.buttons.count * buttonW, 0);
    
    [self setCurrentTab:title];
}

-(void)removeMenuWithTitle:(NSString *)title
{
    for (YW_MenuButton *btn in self.buttons) {
        if ([btn.titleLabel.text isEqualToString:title]) {
            [self deleteButtonRemoveSelf:btn];
            [self.buttons removeObject:btn];
        }
    }
    self.contentSize = CGSizeMake(self.buttons.count * (self.width) / self.maxShowNum, 0);
    NSLog(@"--%@", NSStringFromCGSize(self.contentSize));
}

-(void)tapMenuItem:(YW_MenuButton *)button
{
    button.backgroundColor = [[UIColor colorWithHexString:MenuBarButtonSelectedBgColor] colorWithAlphaComponent:1.0];
    for (YW_MenuButton *btn in self.buttons) {
        if (btn != button) {
            btn.backgroundColor = [UIColor clearColor];
        }
    }
    
    if (self.clickItemBlock) {
        self.clickItemBlock(button);
    }
    
    CGPoint titleOffset = self.contentOffset;
    titleOffset.x = button.center.x - self.width * 0.5;
    
    CGFloat maxTitleOffsetX = self.contentSize.width < self.width ? 0 : self.contentSize.width - self.width;
    if (titleOffset.x < 0) {
        titleOffset.x = 0;
    }
    if (titleOffset.x > maxTitleOffsetX) {
        titleOffset.x = maxTitleOffsetX;
    }
    
    [self setContentOffset:titleOffset animated:YES];
    
}

-(void)deleteButtonRemoveSelf:(YW_MenuButton *)button
{
    [self.buttons removeObject:button];
    
    CGFloat buttonW = (self.width) / self.maxShowNum;
    
    [UIView animateWithDuration:0.5 animations:^{   //重新布局
        for (int i = 0; i < self.buttons.count; i++) {
            CGFloat buttonX = i * buttonW;
            YW_MenuButton *currentBtn = _buttons[i];
            currentBtn.x = buttonX;
        }
    }];
    
    self.contentSize = CGSizeMake(self.buttons.count * buttonW, 0);
    
    [self exitButtonEditStatus];   //删除后推出编辑状态
    
    if (self.clickCloseBlock) {
        self.clickCloseBlock(button);
    }
}

- (void)intoButtonEditStatus
{
    // 进入编辑状态
    for (YW_MenuButton *button in self.buttons) {
        if (button.shaking) return;
        button.shaking = YES;
    }
}

-(void)exitButtonEditStatus
{
    //推出编辑状态
    for (YW_MenuButton *button in self.buttons) {
        button.shaking = NO;
    }
}

-(void)setCurrentTab:(NSString *)currentTab
{
    _currentTab = currentTab;
    
    if ([currentTab isEqualToString:@"home"]) {
        for (YW_MenuButton *button in self.buttons) {
            button.backgroundColor = [UIColor clearColor];
        }
    }else
    {
        for (YW_MenuButton *button in self.buttons) {
            if ([button.titleLabel.text isEqualToString:currentTab])
            {
                button.backgroundColor = [[UIColor colorWithHexString:MenuBarButtonSelectedBgColor] colorWithAlphaComponent:1.0];
                CGPoint titleOffset = self.contentOffset;
                titleOffset.x = button.center.x - self.width * 0.5;
                
                CGFloat maxTitleOffsetX = self.contentSize.width < self.width ? 0 : self.contentSize.width - self.width;
                if (titleOffset.x < 0) {
                    titleOffset.x = 0;
                }
                if (titleOffset.x > maxTitleOffsetX) {
                    titleOffset.x = maxTitleOffsetX;
                }
                
                [self setContentOffset:titleOffset animated:YES];
            }else
            {
                button.backgroundColor = [UIColor clearColor];
            }
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    YW_MenuButton *button = (YW_MenuButton *)[touches anyObject];
    NSLog(@"--%@", button.titleLabel.text);
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

@end
