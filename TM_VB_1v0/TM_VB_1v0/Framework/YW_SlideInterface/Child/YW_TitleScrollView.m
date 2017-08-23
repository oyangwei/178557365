//
//  YW_TitleScrollView.m
//  YW_SlideInterface
//
//  Created by Oyw on 2017/8/11.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_TitleScrollView.h"
#import "YW_TabItem.h"


static CGFloat itemW = 0;
static CGFloat itemH = 0;

@implementation YW_TitleScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.scrollEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.bouncesZoom = YES;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)intoTitleArray:(NSArray *)titles
{
    itemW = self.frame.size.width / self.showItemCount;
    itemH = self.frame.size.height;
    
    for (int i = 0; i < titles.count; i++) {
        YW_TabItem *item = [[YW_TabItem alloc] initWithFrame:CGRectMake(itemW * i, 0, itemW, itemH)];
        item.itemText = titles[i];
        item.tag = i + 100;
        [self addSubview:item];
        
        if (i == self.defaultSelectNum) {
            item.titlesLable.textColor = self.itemSelectedTextColor;
            item.backgroundColor = self.itemSelectedBackgroudColor;
        }else
        {
            item.titlesLable.textColor = self.itemNormalTextColor;
            item.backgroundColor = self.itemNormalBackgroudColor;
        }
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapItem:)];
        [item addGestureRecognizer:tapGestureRecognizer];
    }
    self.contentSize = CGSizeMake(itemW * titles.count, 0);
    
    CGPoint currentOffset = self.contentOffset;
    currentOffset.x = itemW * self.defaultSelectNum + itemW * 0.5 - self.frame.size.width * 0.5;
    [self setScrollViewContentOffset:currentOffset];
}

-(void)tapItem:(UITapGestureRecognizer *)tapGestureRecognizer
{
    YW_TabItem *item = (YW_TabItem *)tapGestureRecognizer.view;
    
    for (YW_TabItem *otherItem in self.subviews) {
        if (otherItem != item) {
            otherItem.titlesLable.textColor = self.itemNormalTextColor;
            otherItem.backgroundColor = self.itemNormalBackgroudColor;
        }else
        {
            otherItem.titlesLable.textColor = self.itemSelectedTextColor;
            otherItem.backgroundColor = self.itemSelectedBackgroudColor;
        }
    }
    
    CGPoint currentOffset = self.contentOffset;
    currentOffset.x = item.center.x - self.frame.size.width * 0.5;
    [self setScrollViewContentOffset:currentOffset];
    
    if (self.tabItemClickBlock) {
        self.tabItemClickBlock((int)item.tag - 100, item);
    }
}

-(void)setSelectedItem:(int)itemNum
{
    for (YW_TabItem *otherItem in self.subviews) {
        if (otherItem.tag != 100 + itemNum) {
            otherItem.titlesLable.textColor = self.itemNormalTextColor;
            otherItem.backgroundColor = self.itemNormalBackgroudColor;
        }else
        {
            otherItem.titlesLable.textColor = self.itemSelectedTextColor;
            otherItem.backgroundColor = self.itemSelectedBackgroudColor;
        }
    }
    
    CGPoint currentOffset = self.contentOffset;
    currentOffset.x = itemW * itemNum + itemW * 0.5 - self.frame.size.width * 0.5;
    [self setScrollViewContentOffset:currentOffset];
}

-(void)setScrollViewContentOffset:(CGPoint)currentOffset
{
    CGFloat maxtTitleOffsetX = self.contentSize.width - self.frame.size.width;
    if (currentOffset.x < 0) {
        currentOffset.x = 0;
    }
    if (currentOffset.x > maxtTitleOffsetX) {
        currentOffset.x = maxtTitleOffsetX;
    }
    [self setContentOffset:currentOffset animated:NO];
    
}

@end
