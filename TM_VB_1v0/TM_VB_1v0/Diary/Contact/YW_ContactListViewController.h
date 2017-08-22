//
//  YW_ContactListViewController.h
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/7.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SPUtil.h"
#import "SPKitExample.h"

@protocol ConversationListVCDelegate <NSObject>

@required
@optional
-(void)didSelectCellWithViewController:(YWConversationViewController *)aConversation;

@end

@interface YW_ContactListViewController : UIViewController

/** ConversationListVCDelegate */
@property(assign, nonatomic) id<ConversationListVCDelegate> delegate;

@end
