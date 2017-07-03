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
        
        UIButton *selectBtn = [[UIButton alloc] init];
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
    
    self.selectBtn.imageEdgeInsets = UIEdgeInsetsMake(EdgeInsetsWidth, EdgeInsetsWidth, EdgeInsetsWidth, EdgeInsetsWidth);
    [self.selectBtn setImage:[UIImage imageNamed:@"more_unfold"] forState:UIControlStateNormal];
    
    [self.codeLable makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leading).offset(10);
        make.top.equalTo(self.top);
        make.height.equalTo(self.height);
    }];
    
    [self.selectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.trailing);
        make.top.equalTo(self.top);
        make.height.equalTo(self.height);
        make.width.equalTo(self.height).offset(-1);
    }];
    
    [self.splitLabel makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.selectBtn.leading);
        make.top.equalTo(self.top);
        make.width.equalTo(1.0);
        make.height.equalTo(self.height);
    }];
    
    [self.areaLabel makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.splitLabel.leading).offset(-10);
        make.top.equalTo(self.top);
        make.height.equalTo(self.height);
    }];
}

-(void)setCodeLabel:(NSString *)code areaLabel:(NSString *)area
{
    self.codeLable.text = code;
    self.areaLabel.text = area;
}

@end
