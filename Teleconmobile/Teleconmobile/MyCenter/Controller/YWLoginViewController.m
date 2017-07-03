//
//  YWLoginViewController.m
//  Teleconmobile
//
//  Created by YangWei on 17/6/26.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YWLoginViewController.h"
#import "YWHomeTabBarViewController.h"

#define TextFieldWidth ScreenWitdh * 3 / 4
#define TextFieldHeight 50
#define TextFieldCornerRadius 5

@interface YWLoginViewController ()

@property(strong, nonatomic) UITextField *phoneTextField;
@property(strong, nonatomic) UITextField *passwordTextField;
@property(strong, nonatomic) UIButton *loginBtn;

@end

@implementation YWLoginViewController

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
    phoneTextField.placeholder = @"PhoneNumber";
    phoneTextField.layer.borderWidth = 1;
    phoneTextField.layer.borderColor = [UIColor colorWithHexString:@"D2D2D2"].CGColor;
    phoneTextField.layer.cornerRadius = 5.0;
    phoneTextField.font = [UIFont systemFontOfSize:18];
    phoneTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85, 0)];
    phoneTextField.leftView.userInteractionEnabled = NO;
    phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = @"Mobile";
    phoneLabel.font = [UIFont systemFontOfSize:15];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    
    UITextField *passwordTextField = [[UITextField alloc] init];
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
    
    [phoneTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(TextFieldWidth);
        make.height.equalTo(50);
        make.top.equalTo(self.view.top).offset(120);
    }];
    
    [phoneLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(phoneTextField.leading).offset(10);
        make.top.equalTo(phoneTextField.top).offset(10);
        make.bottom.equalTo(phoneTextField.bottom).offset(-10);
        make.width.equalTo(70);
    }];
    
    [passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(phoneTextField.bottom).offset(10);
        make.width.equalTo(TextFieldWidth);
        make.height.equalTo(TextFieldHeight);
    }];
    
    [pwLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(passwordTextField.leading).offset(10);
        make.top.equalTo(passwordTextField.top).offset(10);
        make.bottom.equalTo(passwordTextField.bottom).offset(-10);
        make.width.equalTo(70);
    }];
    
    [loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(TextFieldWidth);
        make.height.equalTo(TextFieldHeight);
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(passwordTextField.bottom).offset(80);
    }];
    
}

-(void)login:(id)sender
{
    YWHomeTabBarViewController *homeTBVC = [[YWHomeTabBarViewController alloc] init];
    [homeTBVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self.navigationController presentViewController:homeTBVC animated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

@end
