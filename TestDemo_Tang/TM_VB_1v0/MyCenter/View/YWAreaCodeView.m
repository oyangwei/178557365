//
//  YWAreaCodeView.m
//  Teleconmobile
//
//  Created by YangWei on 17/6/28.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YWAreaCodeView.h"

#define EdgeInsetsWidth 10

@implementation YWAreaCodeView

-(instancetype)init
{
    if (self = [super init]) {
        UILabel *codeLabel = [[UILabel alloc] init];
        self.codeLable = codeLabel;
        
        UILabel *areaLabel = [[UILabel alloc] init];
        self.areaLabel = areaLabel;
        
        UILabel *splitLabel = [[UILabel alloc] init];
        self.splitLabel = splitLabel;
        
        UIImageView *selectBtn = [[UIImageView alloc] init];
        self.selectBtn = selectBtn;
        
        [self addSubview:codeLabel];
        [self addSubview:areaLabel];
        [self addSubview:splitLabel];
        [self addSubview:selectBtn];
    }
    return self;
}

-(void)layoutSubviews
{
    self.codeLable.textAlignment = NSTextAlignmentLeft;
    
    self.areaLabel.textAlignment = NSTextAlignmentLeft;

    self.splitLabel.backgroundColor = [UIColor colorWithHexString:CustomBorderColor];

    [self.selectBtn setImage:[UIImage imageNamed:@"more_unfold"]];
    self.selectBtn.contentMode = UIViewContentModeCenter;
    
    [self.codeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(10);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(self.mas_height).offset(-1);
    }];
    
    [self.splitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.selectBtn.mas_leading);
        make.top.equalTo(self.mas_top);
        make.width.mas_equalTo(1.0);
        make.height.equalTo(self.mas_height);
    }];
    
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.splitLabel.mas_leading).offset(-10);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
    }];
}

-(void)setCodeLabel:(NSString *)code areaLabel:(NSString *)area
{
    self.codeLable.text = code;
    self.areaLabel.text = area;
}

@end
