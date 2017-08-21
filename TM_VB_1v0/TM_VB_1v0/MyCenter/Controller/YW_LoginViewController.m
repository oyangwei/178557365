//
//  YW_LoginViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/2.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_LoginViewController.h"
#import "YW_NavigationController.h"
#import "YW_DiaryViewController.h"
#import "SPUtil.h"
#import "SPKitExample.h"

#define TextFieldWidth ScreenWitdh * 3 / 4
#define TextFieldHeight 50
#define TextFieldCornerRadius 5

@interface YW_LoginViewController ()<UIActionSheetDelegate>

@property(strong, nonatomic) UITextField *phoneTextField;
@property(strong, nonatomic) UITextField *passwordTextField;
@property(strong, nonatomic) UIButton *loginBtn;

@end

@implementation YW_LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)setupView
{
    self.title = @"Log In";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *phoneTextField = [[UITextField alloc] init];
    phoneTextField.text = @"visitor12";
    phoneTextField.placeholder = @"PhoneNumber";
    phoneTextField.layer.borderWidth = 1;
    phoneTextField.layer.borderColor = [UIColor colorWithHexString:@"D2D2D2"].CGColor;
    phoneTextField.layer.cornerRadius = 5.0;
    phoneTextField.font = [UIFont systemFontOfSize:18];
    phoneTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85, 0)];
    phoneTextField.leftView.userInteractionEnabled = NO;
    phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = @"Mobile";
    phoneLabel.font = [UIFont systemFontOfSize:15];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    
    UITextField *passwordTextField = [[UITextField alloc] init];
    passwordTextField.text = @"taobao1234";
    passwordTextField.placeholder = @"Password";
    passwordTextField.layer.borderWidth = 1;
    passwordTextField.layer.borderColor = [UIColor colorWithHexString:@"D2D2D2"].CGColor;
    passwordTextField.layer.cornerRadius = 5.0;
    passwordTextField.font = [UIFont systemFontOfSize:18];
    passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85, 0)];
    passwordTextField.leftView.userInteractionEnabled = NO;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.secureTextEntry = YES;
    
    UIButton *loginBtn = [UIButton createButtonWithFrame:CGRectMake(0, 0, 0, 0) Title:@"登录\nLog In" Target:self Selector:@selector(login:)];
    loginBtn.backgroundColor = [UIColor colorWithHexString:@"FC4F52"];
    loginBtn.titleLabel.numberOfLines = 0;
    loginBtn.tintColor = [UIColor whiteColor];
    [loginBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    loginBtn.layer.cornerRadius = 10;
    
    UILabel *pwLabel = [[UILabel alloc] init];
    pwLabel.text = @"Password";
    pwLabel.font = [UIFont systemFontOfSize:15];
    pwLabel.textAlignment = NSTextAlignmentCenter;
    
    [phoneTextField addSubview:phoneLabel];
    [passwordTextField addSubview:pwLabel];
    
    self.phoneTextField = phoneTextField;
    self.passwordTextField = passwordTextField;
    self.loginBtn = loginBtn;
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginBtn];
    
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(TextFieldWidth);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.view.mas_top).offset(120);
    }];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(phoneTextField.mas_leading).offset(10);
        make.top.equalTo(phoneTextField.mas_top).offset(10);
        make.bottom.equalTo(phoneTextField.mas_bottom).offset(-10);
        make.width.mas_equalTo(70);
    }];
    
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(phoneTextField.mas_bottom).offset(10);
        make.width.mas_equalTo(TextFieldWidth);
        make.height.mas_equalTo(TextFieldHeight);
    }];
    
    [pwLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(passwordTextField.mas_leading).offset(10);
        make.top.equalTo(passwordTextField.mas_top).offset(10);
        make.bottom.equalTo(passwordTextField.mas_bottom).offset(-10);
        make.width.mas_equalTo(70);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TextFieldWidth);
        make.height.mas_equalTo(TextFieldHeight);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(passwordTextField.mas_bottom).offset(80);
    }];
    
}

-(void)login:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    [[SPUtil sharedInstance] setWaitingIndicatorShown:YES withKey:self.description];
    
    NSLog(@"%@ %@", self.phoneTextField.text, self.passwordTextField.text);
    
    [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:self.phoneTextField.text passWord:self.passwordTextField.text preloginedBlock:^{
        [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:weakSelf.description];
        [weakSelf _pushMainControllerAnimated:YES];
    } successBlock:^{
        [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:weakSelf.description];
        [weakSelf _pushMainControllerAnimated:YES];
    } failedBlock:^(NSError *aError) {
        NSLog(@"aError : %@", aError);
        if (aError.code == YWLoginErrorCodePasswordError || aError.code == YWLoginErrorCodePasswordInvalid || aError.code == YWLoginErrorCodeUserNotExsit) {
            [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:weakSelf.description];
            
            NSLog(@"%@", aError);
        }
    }];
}

-(void)_pushMainControllerAnimated:(BOOL)aAnimated
{
    YW_DiaryViewController *diaryVC = [[YW_DiaryViewController alloc] init];
    YW_NavigationController *nVC = [[YW_NavigationController alloc] initWithRootViewController:diaryVC];
    [UIView transitionWithView:self.view.window duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.view.window.rootViewController = nVC;
    } completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

@end
