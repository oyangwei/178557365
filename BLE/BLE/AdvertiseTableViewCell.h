//
//  AdvertiseTableViewCell.h
//  BLE
//
//  Created by YangWei on 2017/7/12.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Advertise.h"

@interface AdvertiseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *packet;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *RSSI;

@property(assign, nonatomic) CGFloat cellHeight;

-(void)initWithModel:(Advertise *)ad;

@end
