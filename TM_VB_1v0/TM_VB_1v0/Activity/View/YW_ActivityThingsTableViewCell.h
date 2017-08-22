//
//  YW_ActivityThingsTableViewCell.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/9.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YW_ActivityThingsTableViewCell : UITableViewCell

-(void)configureWithAvatar:(UIImage *)image title:(NSString *)title;

/** 标识符 */
@property(strong, nonatomic) NSString *identifier;

@end
