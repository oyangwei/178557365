//
//  YWAreaCodeView.m
//  Teleconmobile
//
//  Created by YangWei on 17/6/28.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YWAreaCodeViewCell.h"

#define EdgeInsetsWidth 10

@implementation YWAreaCodeViewCell

-(instancetype)init
{
    if (self = [super init]) {
        UILabel *codeLabel = [[UILabel alloc] init];
        self.codeLable = codeLabel;
        
        UILabel *areaLabel = [[UILabel alloc] init];
        self.areaLabel = areaLabel;
        
        [self addSubview:codeLabel];
        [self addSubview:areaLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    self.codeLable.textAlignment = NSTextAlignmentLeft;
    
    self.areaLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.codeLable makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(10);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
    }];
    
    [self.areaLabel makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing).offset(-10);
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
