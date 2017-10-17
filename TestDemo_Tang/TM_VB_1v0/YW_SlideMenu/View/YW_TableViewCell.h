//
//  YW_TableViewCell.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/16.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YW_MainMenuItem.h"

@interface YW_TableViewCell : UITableViewCell

/** Item */
@property(strong, nonatomic) YW_MainMenuItem *item;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
