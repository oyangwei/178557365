//
//  YW_ActivityThingsTableViewCell.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/9.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_ActivityThingsTableViewCell.h"

@interface YW_ActivityThingsTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation YW_ActivityThingsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.frame) * 0.5;
    self.avatarImageView.clipsToBounds = YES;
}

-(void)configureWithAvatar:(UIImage *)image title:(NSString *)title
{
    self.avatarImageView.image = image;
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
