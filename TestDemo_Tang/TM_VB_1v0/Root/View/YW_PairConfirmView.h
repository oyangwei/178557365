//
//  YW_PairConfirmView.h
//  TestDemo_Tang
//
//  Created by Oyw on 2017/10/18.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmBlock)(void);

@interface YW_PairConfirmView : UIView

@property (weak, nonatomic) IBOutlet UIView *modelNoView;

@property (weak, nonatomic) IBOutlet UILabel *modelNoLabel;

@property (weak, nonatomic) IBOutlet UITextField *renameTextFiled;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

- (IBAction)confirmClick:(id)sender;

@property (copy, nonatomic) ConfirmBlock confirmBlock;

@end
