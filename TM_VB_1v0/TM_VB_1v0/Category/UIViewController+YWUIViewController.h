//
//  UIViewController+YWUIViewController.h
//  Teleconmobile
//
//  Created by YangWei on 17/6/26.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ConfirmBlock)(void);
typedef void (^CancleBlock)(void);

@interface UIViewController (YWUIViewController)

-(void)setUIViewBackgroud:(UIView *)uiview name:(NSString *)name;

-(void)alertMsg:(NSString *)msg confimBlock:(ConfirmBlock)confirBlock;  //只有确定按钮的提示框

-(void)alertMsg:(NSString *)msg confimBlock:(ConfirmBlock)confirBlock cancleBlock:(CancleBlock)cancleBlock;    //弹出提示框

@end
