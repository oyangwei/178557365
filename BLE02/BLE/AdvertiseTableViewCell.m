//
//  AdvertiseTableViewCell.m
//  BLE
//
//  Created by YangWei on 2017/7/12.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "AdvertiseTableViewCell.h"

@implementation AdvertiseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)initWithModel:(Advertise *)ad
{
    self.packet.text = [@"BroadcastPacket :" stringByAppendingString:[ad.packet isEqual:@""]?@"nil":ad.packet.description];
    self.name.text = [@"Name :" stringByAppendingString:ad.name == nil?@"nil":ad.name];
    
    self.RSSI.text = [@"RSSI :" stringByAppendingString:ad.RSSI == nil?@"nil":[NSString stringWithFormat:@"%@", ad.RSSI]];
    
    [self layoutIfNeeded];
    
    self.cellHeight = CGRectGetMaxY(self.RSSI.frame) + 50;
    
}

@end
