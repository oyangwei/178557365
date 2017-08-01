//
//  YW_MenuSliderBar.h
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YW_MenuSliderBar : UIScrollView <UIScrollViewDelegate>

/** 屏幕可显示的最大数量 */
@property(assign, nonatomic) int maxShowNum;

-(void)setUpMenuWithTitleArr:(NSArray *)titleArr;

- (void)updateMenuWithTitleArr:(NSMutableArray *)titleArr;
@end
