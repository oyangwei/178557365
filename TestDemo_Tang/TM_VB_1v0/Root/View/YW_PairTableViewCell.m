//
//  YW_PairTableViewCell.m
//  TestDemo_Tang
//
//  Created by Oyw on 2017/10/17.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_PairTableViewCell.h"

@implementation YW_PairTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSLog(@"%s, line = %d", __func__, __LINE__);
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pairTap:)];
    [self.pairView addGestureRecognizer:tapGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)pairTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
//    UIView *pairView = (UIView *)tapGestureRecognizer.view;
    
    [self setPairStat:YES];
    
    if (self.pairBlock) {
        self.pairBlock();
    }
}

-(void)setPairStat:(BOOL)isPairing
{
    if (isPairing) {
        self.pairIndicator.alpha = 1.0;
        self.pairLabel.alpha = 0.0;
        [self.pairIndicator startAnimating];
    }else
    {
        self.pairIndicator.alpha = 0.0;
        self.pairLabel.alpha = 1.0;
        self.pairLabel.text = @"Paired";
        [self.pairIndicator stopAnimating];
    }
}

@end
