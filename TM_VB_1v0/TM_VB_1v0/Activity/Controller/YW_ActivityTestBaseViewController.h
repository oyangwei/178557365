//
//  YW_ActivityTestBaseViewController.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/30.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FullScreenPattern)(BOOL isFullScreen);

@interface YW_ActivityTestBaseViewController : UIViewController

/** 进入或退出全屏调用 */
@property(copy, nonatomic) FullScreenPattern fullScreenPattern;

@end
