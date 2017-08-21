//
//  YW_TabItem.m
//  YW_SlideInterface
//
//  Created by Oyw on 2017/8/11.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_TabItem.h"

@implementation YW_TabItem

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    [self titlesLable];
}

-(UILabel *)titlesLable
{
    if (!_titlesLable) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.highlightedTextColor = [UIColor grayColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        _titlesLable = titleLabel;
    }
    return _titlesLable;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupUIFrame];
}

-(void)setupUIFrame
{
    CGFloat tabItemW = self.frame.size.width;
    CGFloat tabItemH = self.frame.size.height;
    CGFloat tabItemCenterX = tabItemW / 2;
    CGFloat tabItemCenterY = tabItemH / 2;
    
    [_titlesLable sizeToFit];
    _titlesLable.center = CGPointMake(tabItemCenterX, tabItemCenterY);
}

-(void)setItemText:(NSString *)itemText
{
    _itemText = itemText;
    _titlesLable.text = itemText;
}

-(void)setItemTitleNormalColor:(UIColor *)itemTitleNormalColor
{
    _itemTitleNormalColor = itemTitleNormalColor;
    if (itemTitleNormalColor) {
        _titlesLable.textColor = _itemTitleNormalColor;
    }
}

-(void)setItemTitleSelectedColor:(UIColor *)itemTitleSelectedColor
{
    _itemTitleSelectedColor = itemTitleSelectedColor;
    if (itemTitleSelectedColor) {
        _titlesLable.highlightedTextColor = itemTitleSelectedColor;
    }
}

@end
