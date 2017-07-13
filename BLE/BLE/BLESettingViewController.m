//
//  BLESettingViewController.m
//  BLE
//
//  Created by YangWei on 2017/7/13.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "BLESettingViewController.h"

@interface BLESettingViewController ()<UITextFieldDelegate>

@property(assign, nonatomic) int keyBoardHeight;
@property(assign, nonatomic) BOOL isAnimate;
@property(strong, nonatomic) NSUserDefaults *userDefault;

@end

@implementation BLESettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDefault = [NSUserDefaults standardUserDefaults];
    
    self.view.backgroundColor = [UIColor purpleColor];
    self.title = @"Setting";
    
    self.confirmBtn.layer.cornerRadius = 10;

    self.UUIDTextField01.keyboardType = UIKeyboardTypeASCIICapable;
    self.UUIDTextField02.keyboardType = UIKeyboardTypeASCIICapable;
    self.UUIDTextField03.keyboardType = UIKeyboardTypeASCIICapable;
    self.UUIDTextField04.keyboardType = UIKeyboardTypeASCIICapable;
    
    self.UUIDTextField01.delegate = self;
    self.UUIDTextField02.delegate = self;
    self.UUIDTextField03.delegate = self;
    self.UUIDTextField04.delegate = self;
    
    self.UUIDTextField01.text = [self.userDefault valueForKey:@"UUID01"];
    self.UUIDTextField02.text = [self.userDefault valueForKey:@"UUID02"];
    self.UUIDTextField03.text = [self.userDefault valueForKey:@"UUID03"];
    self.UUIDTextField04.text = [self.userDefault valueForKey:@"UUID04"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGFloat offsetToBottom = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height);
    if (offsetToBottom < self.keyBoardHeight) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = self.view.frame;
            rect.origin.y -= self.keyBoardHeight - 50;
            rect.size.height += self.keyBoardHeight - 50;
            self.view.frame = rect;
        }];
        self.isAnimate = YES;
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.isAnimate) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = self.view.frame;
            rect.origin.y += self.keyBoardHeight - 50;
            rect.size.height -= self.keyBoardHeight - 50;
            self.view.frame = rect;
        }];
        self.isAnimate = !self.isAnimate;
    }
}

- (IBAction)confirmClick:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:self.UUIDTextField01.text forKey:@"UUID01"];
    [[NSUserDefaults standardUserDefaults] setValue:self.UUIDTextField02.text forKey:@"UUID02"];
    [[NSUserDefaults standardUserDefaults] setValue:self.UUIDTextField03.text forKey:@"UUID03"];
    [[NSUserDefaults standardUserDefaults] setValue:self.UUIDTextField04.text forKey:@"UUID04"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    self.keyBoardHeight = keyboardRect.size.height;
}

-(void)keyboardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    self.keyBoardHeight = keyboardRect.size.height;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.UUIDTextField01 resignFirstResponder];
    [self.UUIDTextField02 resignFirstResponder];
    [self.UUIDTextField03 resignFirstResponder];
    [self.UUIDTextField04 resignFirstResponder];
}

@end
