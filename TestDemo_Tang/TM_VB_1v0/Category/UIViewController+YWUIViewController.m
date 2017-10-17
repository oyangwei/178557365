//
//  UIViewController+YWUIViewController.m
//  Teleconmobile
//
//  Created by YangWei on 17/6/26.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "UIViewController+YWUIViewController.h"

@implementation UIViewController (YWUIViewController)

-(void)setUIViewBackgroud:(UIView *)uiview name:(NSString *)name
{
    CGSize s = uiview.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [uiview.layer renderInContext:UIGraphicsGetCurrentContext()];
    [[UIImage imageNamed:name] drawInRect:uiview.bounds];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    uiview.backgroundColor = [UIColor colorWithPatternImage:image];
}

-(void)alertMsg:(NSString *)msg confimBlock:(ConfirmBlock)confirBlock{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirBlock) {
            confirBlock();
        }
    }];
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)alertMsg:(NSString *)msg confimBlock:(ConfirmBlock)confirBlock cancleBlock:(CancleBlock)cancleBlock{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirBlock) {
            confirBlock();
        }
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cancleBlock) {
            cancleBlock();
        }
    }];
    [alertVC addAction:cancleAction];
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end

