//
//  YW_MenuSliderBar.m
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_MenuSliderBar.h"
#import "YW_MenuBarLabel.h"
#import "UIView+YW_ScreenFrame.h"


@interface YW_MenuSliderBar ()

@end

@implementation YW_MenuSliderBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pagingEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.alwaysBounceVertical = NO;
    }
    return self;
}

-(void)setUpMenuWithTitleArr:(NSArray *)titleArr
{
    CGFloat labelW = (self.width) / self.maxShowNum;
    CGFloat labelH = self.height;
    CGFloat labelY = 0;
    
    for (int i = 0; i < titleArr.count; i ++) {
        CGFloat labelX = i * labelW;
        
        YW_MenuBarLabel *label = [[YW_MenuBarLabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        label.text = titleArr[i];
        
        label.tag = 100 + i;
    
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMenuItem:)];
        [label addGestureRecognizer:tapGestureRecognizer];
        
        [self addSubview:label];
    }
    
    self.contentSize = CGSizeMake(titleArr.count * labelW, 0);
}

- (void)updateMenuWithTitleArr:(NSMutableArray *)titleArr
{
    for (id subviews in self.subviews) {
        [subviews removeFromSuperview];
    }
    
    [self setUpMenuWithTitleArr:titleArr];
}

-(void)tapMenuItem:(UITapGestureRecognizer *)tapGestureRecognizer
{
    YW_MenuBarLabel *label = (YW_MenuBarLabel *)tapGestureRecognizer.view;
    label.backgroundColor = [UIColor colorWithHexString:@"#FF0000"];
    label.alpha = 0.5;
    label.textColor = [UIColor whiteColor];
    
    for (YW_MenuBarLabel *otherLabel in self.subviews) {
        if (otherLabel != label) {
            otherLabel.backgroundColor = [UIColor clearColor];
            otherLabel.textColor = [UIColor blackColor];
            otherLabel.alpha = 1.0;
        }
    }
    CGPoint titleOffset = self.contentOffset;
    titleOffset.x = label.center.x - self.width * 0.5;
    
    CGFloat maxTitleOffsetX = self.contentSize.width - self.width;
    if (titleOffset.x < 0) {
        titleOffset.x = 0;
    }
    if (titleOffset.x > maxTitleOffsetX) {
        titleOffset.x = maxTitleOffsetX;
    }
    
    [self setContentOffset:titleOffset animated:YES];
}

@end
