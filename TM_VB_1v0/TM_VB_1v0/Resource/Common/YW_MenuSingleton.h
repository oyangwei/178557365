//
//  YW_MenuSingleton.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YW_MenuSliderBar;

@interface YW_MenuSingleton : NSObject <NSCopying, NSMutableCopying>

/** Current View Title */
@property(strong, nonatomic) YW_MenuSliderBar *sliderBar;

/** 菜单项 */
@property(strong, nonatomic) NSMutableArray *menuControllersTitlesArr;

+(instancetype)shareMenuInstance;

+(instancetype)initWithSlider:(YW_MenuSliderBar *)sliderBar;

@end
