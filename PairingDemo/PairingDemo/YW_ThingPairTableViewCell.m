//
//  YW_ThingPairTableViewCell.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/13.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_ThingPairTableViewCell.h"
#import "UIColor+Hex.h"

#define ThemeColor @"#8EAFD3"

@implementation YW_ThingPairTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)layoutSubviews
{
    [self.thingTypeLabel setTextColor:[UIColor blackColor]];
    self.thingTypeLabel.font = [UIFont systemFontOfSize:15];
    
    [self.productInfoLabel setTextColor:[UIColor blackColor]];
    self.productInfoLabel.font = [UIFont systemFontOfSize:15];
    
    self.pairBtn.layer.cornerRadius = 3;
    self.pairBtn.layer.borderWidth = 1;
    self.pairBtn.layer.borderColor = [UIColor colorWithHexString:ThemeColor].CGColor;
    
//    [self.pairBtn setBackgroundImage:[[YWCommonMethod sharedCommonMethod] imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.pairBtn setTitleColor:[UIColor colorWithHexString:ThemeColor] forState:UIControlStateNormal];
    
//    [self.pairBtn setBackgroundImage:[[YWCommonMethod sharedCommonMethod] imageWithColorOfHexString:ThemeColor] forState:UIControlStateHighlighted];
    [self.pairBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

-(void)setPairCellValue:(YW_PairCellModel *)model
{
    self.thingTypeLabel.text = model.thingType;
    self.productInfoLabel.text = model.productInfo;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)pairBtnClick:(id)sender {
    [self.pairBtn setTitle:@"Pairing" forState:UIControlStateNormal];
    if (self.pairPeripheralBlock) {
        self.pairPeripheralBlock();
    }
}
@end
