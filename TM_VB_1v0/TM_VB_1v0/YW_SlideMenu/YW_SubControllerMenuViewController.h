//
//  YW_SubControllerMenuViewController.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/16.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YW_MainMenuItem.h"

typedef void (^ItemClickBlcok)(NSString *itemTitle);

@interface YW_SubControllerMenuViewController : UIViewController

/** ItemClickBlcok */
@property(copy, nonatomic) ItemClickBlcok itemClickBlcok;

@end
