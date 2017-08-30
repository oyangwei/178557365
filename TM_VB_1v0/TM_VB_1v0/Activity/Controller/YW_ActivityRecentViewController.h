//
//  YW_ActivityRecentViewController.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/9.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActivityItemSelectedDelegate <NSObject>

@required
-(void)activityItemSelected:(NSString *)title;

@optional
-(void)activityItemSelected:(NSString *)title itemNum:(int)num;

@end

@interface YW_ActivityRecentViewController : UIViewController

/** 点击事件的代理 */
@property(weak, nonatomic) id<ActivityItemSelectedDelegate> delegate;

-(void)setEditing:(BOOL)editing cancle:(BOOL)cancle;

@end
