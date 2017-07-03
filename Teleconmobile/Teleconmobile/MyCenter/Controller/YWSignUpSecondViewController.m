//
//  YWSignUpSecondViewController.m
//  Teleconmobile
//
//  Created by YangWei on 17/6/26.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YWSignUpSecondViewController.h"
#import "YWSignUpThirdViewCOntroller.h"

#define TextFieldWidth ScreenWitdh * 3 / 4
#define TextFieldHeight 50
#define TextFieldCornerRadius 5

@interface YWSignUpSecondViewController ()

@property(strong, nonatomic) UITextField *userNameTextField;
@property(strong, nonatomic) UITextField *passwordTextField;
@property(strong, nonatomic) UIButton *nextBtn;
@property(strong, nonatomic) UILabel *promptLabel;

@end

@implementation YWSignUpSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

#pragma mark -- 当View加载时
-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)setupView
{
    self.title = @"Sign Up";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *userNameTextField = [[UITextField alloc] init];
    userNameTextField.placeholder = @"Plese Create Account Name";
    userNameTextField.layer.borderWidth = 1;
    userNameTextField.layer.borderColor = [UIColor colorWithHexString:@"D2D2D2"].CGColor;
    userNameTextField.layer.cornerRadius = TextFieldCornerRadius;
    userNameTextField.font = [UIFont systemFontOfSize:18];
    userNameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    userNameTextField.leftView.userInteractionEnabled = NO;
    userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    userNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    UITextField *passwordTextField = [[UITextField alloc] init];
    passwordTextField.placeholder = @"Please Input Password";
    passwordTextField.layer.borderWidth = 1;
    passwordTextField.layer.borderColor = [UIColor colorWithHexString:@"D2D2D2"].CGColor;
    passwordTextField.layer.cornerRadius = TextFieldCornerRadius;
    passwordTextField.font = [UIFont systemFontOfSize:18];
    passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    passwordTextField.leftView.userInteractionEnabled = NO;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.secureTextEntry = YES;
    
    UIButton *nextBtn = [UIButton createButtonWithFrame:CGRectMake(0, 0, 0, 0) Title:@"下一步\nNext" Target:self Selector:@selector(next:)];
    nextBtn.backgroundColor = [UIColor colorWithHexString:@"FC4F52"];
    nextBtn.titleLabel.numberOfLines = 0;
    nextBtn.tintColor = [UIColor whiteColor];
    [nextBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    nextBtn.layer.cornerRadius = TextFieldCornerRadius;
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.text = @"还有一步\n1 Steps Left";
    promptLabel.textColor = [UIColor grayColor];
    promptLabel.layer.borderWidth = 0;
    promptLabel.font = [UIFont systemFontOfSize:12.0];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.numberOfLines = 0;
    
    self.userNameTextField = userNameTextField;
    self.passwordTextField = passwordTextField;
    self.nextBtn = nextBtn;
    self.promptLabel = promptLabel;
    [self.view addSubview:self.userNameTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.promptLabel];
    
    [userNameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(ScreenWitdh * 3 / 4);
        make.height.equalTo(50);
        make.top.equalTo(self.view.top).offset(120);
    }];
    
    [passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(userNameTextField.bottom).offset(10);
        make.width.equalTo(TextFieldWidth);
        make.height.equalTo(TextFieldHeight);
    }];
    
    [nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(TextFieldWidth);
        make.height.equalTo(TextFieldHeight);
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(passwordTextField.bottom).offset(80);
    }];
    
    [promptLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(nextBtn.leading);
        make.top.equalTo(nextBtn.bottom).offset(5);
        make.width.equalTo(TextFieldWidth);
        make.height.equalTo(TextFieldHeight - 20);
    }];
}

-(void)next:(id)sender
{
    YWSignUpThirdViewController *sutVC = [[YWSignUpThirdViewController alloc] init];
    [self.navigationController pushViewController:sutVC animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}


@end
