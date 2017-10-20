//
//  YW_PairTableViewCell.h
//  TestDemo_Tang
//
//  Created by Oyw on 2017/10/17.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PairBlock)(void);

@interface YW_PairTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *pairView;

@property (weak, nonatomic) IBOutlet UILabel *pairLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *pairIndicator;

/** PairBlock */
@property(copy, nonatomic) PairBlock pairBlock;

-(void)setPairStat:(BOOL)isPairing;

@end
