//
//  YW_IconButton.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/22.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_IconButton.h"

@implementation YW_IconButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

-(void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.layer.cornerRadius = 10;
    
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.imageView.height;
}

@end
