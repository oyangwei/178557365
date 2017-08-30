//
//  YW_ActivityRecentTableViewCell.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/9.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YW_ActivityRecentTableViewCell : UITableViewCell

/** 标题 */
@property(strong, nonatomic) NSString *title;

-(void)configureWithAvatar:(UIImage *)image title:(NSString *)title;

/** 标识符 */
@property(strong, nonatomic) NSString *identifier;

@end
