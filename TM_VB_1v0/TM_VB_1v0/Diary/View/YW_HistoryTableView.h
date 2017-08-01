//
//  YW_HistoryTableView.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/1.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellBlock)(NSString *);
typedef void(^ClearBlock)();

@interface YW_HistoryTableView : UIView

/** CellBlock */
@property(copy, nonatomic) CellBlock cellBlock;

/** ClearBlock */
@property(copy, nonatomic) ClearBlock clearBlock;

/** 历史记录 */
@property(strong, nonatomic) NSMutableArray *historyRecord;

@end

