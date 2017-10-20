//
//  YW_DeclareView.h
//  TestDemo_Tang
//
//  Created by Oyw on 2017/10/19.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CconfirmBlock)(void);
@interface YW_DeclareView : UIView

/** ConfirmBlock */
@property(copy, nonatomic) ConfirmBlock confirmBlock;

+(instancetype)declareView;

@end
