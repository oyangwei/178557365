//
//  YWAreaCodeViewCell.h
//  Teleconmobile
//
//  Created by YangWei on 17/6/28.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWAreaCodeViewCell : UIView

@property(strong, nonatomic) UILabel *codeLable;
@property(strong, nonatomic) UILabel *areaLabel;

-(void)setCodeLabel:(NSString *)code areaLabel:(NSString *)area;

@end
