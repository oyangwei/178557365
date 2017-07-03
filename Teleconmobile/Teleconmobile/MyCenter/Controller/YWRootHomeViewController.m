//
//  YWRootHomeViewController.m
//  Teleconmobile
//
//  Created by YangWei on 17/6/26.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YWRootHomeViewController.h"
#import "YWLoginViewController.h"
#import "YWSignUpFirstViewController.h"

@interface YWRootHomeViewController ()

@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIButton *signBtn;

@end

@implementation YWRootHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewController];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)setupViewController
{
    [self setUIViewBackgroud:self.view name:@"login_bg"];
    
    CGRect loginBtnRect = CGRectMake(ScreenWitdh/2 - 50, ScreenHeight/2 - 60, 100, 50);
    UIButton *loginBtn = [UIButton createButtonWithFrame:loginBtnRect Title:@"Log In\n登陆" Target:self Selector:@selector(login:)];
    loginBtn.tintColor = [UIColor whiteColor];
    [loginBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [loginBtn setUIButtonBorderColor:[UIColor whiteColor].CGColor borderWidth:1.0 borderRadius:5.0];
    loginBtn.titleLabel.numberOfLines = 0;

    CGRect signBtnRect = CGRectMake(ScreenWitdh/2 - 50, ScreenHeight/2 + 10, 100, 50);
    UIButton *signBtn = [UIButton createButtonWithFrame:signBtnRect Title:@"Sign Up\n注册" Target:self Selector:@selector(signUp:)];
    signBtn.tintColor = [UIColor whiteColor];
    [signBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [signBtn setUIButtonBorderColor:[UIColor whiteColor].CGColor borderWidth:1.0 borderRadius:5.0];
    signBtn.titleLabel.numberOfLines = 0;
    
    self.loginBtn = loginBtn;
    self.signBtn = signBtn;
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.signBtn];
    
    [signBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(100);
        make.height.equalTo(50);
        make.bottom.equalTo(self.view.centerY).offset(-20);
    }];
    
    [loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(signBtn.width);
        make.height.equalTo(signBtn.height);
        make.bottom.equalTo(signBtn.top).equalTo(-20);
    }];
}

-(void)login:(id)sender
{
    YWLoginViewController *loginVC = [[YWLoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)signUp:(id)sender
{
    YWSignUpFirstViewController *sufVC = [[YWSignUpFirstViewController alloc] init];
    [self.navigationController pushViewController:sufVC animated:YES];
}

@end
