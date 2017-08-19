//
//  YW_TabItem.h
//  YW_SlideInterface
//
//  Created by Oyw on 2017/8/11.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YW_TabItem : UIView

@property (nonatomic,weak) UILabel *titlesLable;

/** item文字 */
@property(strong, nonatomic) NSString *itemText;

/** item文字颜色 */
@property(strong, nonatomic) UIColor *itemTitleNormalColor;

/** item选中文字颜色 */
@property(strong, nonatomic) UIColor *itemTitleSelectedColor;

@end
