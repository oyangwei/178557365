//
//  YW_TableViewCell.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/16.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_TableViewCell.h"

@interface YW_TableViewCell()

/** 图像 */
@property(strong, nonatomic) UIImageView *iconView;

/** 标题 */
@property(strong, nonatomic) UILabel *titleLabel;

/** 箭头 */
@property(strong, nonatomic) UIImageView *arrowView;

@end

@implementation YW_TableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YW_MainMenuCell";
    YW_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YW_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 初始化操作
        [self setupView];
    }
    return self;
}

/** 初始化View */
-(void)setupView
{
    self.backgroundColor = [UIColor clearColor];
    
    /** 图像 */
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    /** 标题 */
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    /** 箭头 */
    UIImageView *arrowView = [[UIImageView alloc] init];
    arrowView.image = [UIImage imageNamed:@"caret_right"];
    [self.contentView addSubview:arrowView];
    self.arrowView = arrowView;
    
}

/** 设置子控制器Frame */
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat contentH = self.contentView.bounds.size.height;
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(15);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(contentH);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconView.mas_trailing).offset(10);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
        make.height.mas_equalTo(contentH);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-15);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(14);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

-(void)setItem:(YW_MainMenuItem *)item
{
    _item = item;
    self.iconView.image = [UIImage imageNamed:item.icon];
    self.titleLabel.text = item.itmeTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
