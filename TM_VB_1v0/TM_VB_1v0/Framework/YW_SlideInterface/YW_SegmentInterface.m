//
//  YW_SegmentInterface.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/11.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_SegmentInterface.h"

@interface YW_SegmentInterface()

/** TitleScrollView */
@property(strong, nonatomic) UIScrollView *titleScrollView;

/** ChileControllerScrollView */
@property(strong, nonatomic) UIScrollView *childScrollView;

@end

@implementation YW_SegmentInterface

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

@end
