//
//  YWQuestionViewCell.m
//  Teleconmobile
//
//  Created by YangWei on 17/6/28.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YWQuestionViewCell.h"

#define EdgeInsetsWidth 10

@implementation YWQuestionViewCell

-(instancetype)init
{
    if (self = [super init]) {
        UILabel *questionLable = [[UILabel alloc] init];
        self.questionLable = questionLable;
        
        [self addSubview:questionLable];
    }
    return self;
}

-(void)layoutSubviews
{
    self.questionLable.textAlignment = NSTextAlignmentLeft;
    
    [self.questionLable makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing).offset(-10);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
    }];
}

-(void)setQuestionLableTitle:(NSString *)question
{
    self.questionLable.text = question;
}

@end
