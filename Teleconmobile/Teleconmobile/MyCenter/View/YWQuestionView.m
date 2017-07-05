//
//  YWQuestionView.m
//  Teleconmobile
//
//  Created by YangWei on 17/6/27.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YWQuestionView.h"

#define EdgeInsetsWidth 10

@implementation YWQuestionView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *splitLine = [[UILabel alloc] init];
        self.splitLine = splitLine;
        
        UILabel *questionLabel = [[UILabel alloc] init];
        self.questionLabel = questionLabel;
        
        UIButton *questionBtn = [[UIButton alloc] init];
        self.questionBtn = questionBtn;
        
        [self addSubview:self.questionLabel];
        [self addSubview:self.splitLine];
        [self addSubview:self.questionBtn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.questionLabel.textAlignment = NSTextAlignmentLeft;
    self.questionLabel.backgroundColor = [UIColor whiteColor];
    self.questionLabel.userInteractionEnabled = YES;
    self.questionLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.questionLabel.text];
    NSInteger length = [self.questionLabel.text length];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    style.firstLineHeadIndent = 10;
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    [self.questionLabel setAttributedText:attrString];
    
    self.splitLine.backgroundColor = [UIColor colorWithHexString:@"#D2D2D2"];
    
    self.questionBtn.imageEdgeInsets = UIEdgeInsetsMake(EdgeInsetsWidth, EdgeInsetsWidth, EdgeInsetsWidth, EdgeInsetsWidth);;
    [self.questionBtn setImage:[UIImage imageNamed:@"more_unfold"] forState:UIControlStateNormal];
    
    [self.questionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading);
        make.trailing.equalTo(self.mas_trailing).offset(-50);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
    }];
    
    [self.splitLine makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.questionLabel.mas_trailing);
        make.height.equalTo(self.mas_height);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(1.0);
    }];
    
    [self.questionBtn makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.splitLine.mas_leading);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
        make.trailing.equalTo(self.mas_trailing);
    }];
}

-(void)setQuestionLabelText:(NSString *)title
{
    self.questionLabel.text = title;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.questionLabel.text];
    NSInteger length = [self.questionLabel.text length];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    style.firstLineHeadIndent = 10;
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    [self.questionLabel setAttributedText:attrString];
}

@end
