//
//  YW_ThingPairTableViewCell.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/13.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YW_PairCellModel.h"

typedef void (^PairPeripheralBlock)();

@interface YW_ThingPairTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *thingTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *productInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *pairBtn;

/** PairPeripheralBlock 外设Block */
@property(copy, nonatomic) PairPeripheralBlock pairPeripheralBlock;

- (IBAction)pairBtnClick:(id)sender;

- (void)setPairCellValue:(YW_PairCellModel *)model;

@end
