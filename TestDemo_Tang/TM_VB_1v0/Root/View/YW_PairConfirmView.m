//
//  YW_PairConfirmView.m
//  TestDemo_Tang
//
//  Created by Oyw on 2017/10/18.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_PairConfirmView.h"

@interface YW_PairConfirmView() <UITextFieldDelegate>

@end

@implementation YW_PairConfirmView

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHexString:ThemeColor].CGColor;
    
    self.modelNoView.layer.cornerRadius = 10;
    self.modelNoView.layer.borderWidth = 1;
    self.modelNoView.layer.borderColor = [UIColor colorWithHexString:ThemeColor].CGColor;
    
    self.renameTextFiled.delegate = self;
    [self.renameTextFiled becomeFirstResponder];
    self.renameTextFiled.layer.cornerRadius = 10;
    self.renameTextFiled.layer.borderWidth = 1;
    self.renameTextFiled.layer.borderColor = [UIColor colorWithHexString:ThemeColor].CGColor;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.renameTextFiled.backgroundColor = [UIColor whiteColor];
    self.renameTextFiled.leftView = leftView;
    self.renameTextFiled.leftViewMode = UITextFieldViewModeAlways;
    self.renameTextFiled.delegate = self;
    self.renameTextFiled.returnKeyType = UIReturnKeyDone;
    
    self.confirmBtn.layer.cornerRadius = 10;
    self.confirmBtn.layer.borderWidth = 1;
    self.confirmBtn.layer.borderColor = [UIColor colorWithHexString:ThemeColor].CGColor;
    
}

- (IBAction)confirmClick:(id)sender {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    return YES;
}

@end
