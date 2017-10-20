//
//  YW_RootViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/2.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_RootViewController.h"
#import "YW_LoginViewController.h"
#import "YW_SignUpFirstViewController.h"

#define btnWidth 150
#define btnHeight 60

@interface YW_RootViewController ()

@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIButton *signBtn;

@end

@implementation YW_RootViewController

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
//    [self setUIViewBackgroud:self.view name:@"login_bg"];
    
    UIImageView *bgImage = [[UIImageView alloc] init];
    bgImage.userInteractionEnabled = YES;
    [bgImage setImage:[UIImage imageNamed:@"login_bg"]];
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    
    CGRect loginBtnRect = CGRectMake(ScreenWitdh/2 - btnWidth, ScreenHeight/2 - btnHeight, btnWidth, btnHeight);
    UIButton *loginBtn = [UIButton createButtonWithFrame:loginBtnRect Title:@"Log In\n登陆" Target:self Selector:@selector(login:)];
    loginBtn.tintColor = [UIColor whiteColor];
    loginBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [loginBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [loginBtn setUIButtonBorderColor:[UIColor whiteColor].CGColor borderWidth:1.0 borderRadius:5.0];
    loginBtn.titleLabel.numberOfLines = 0;
    
    CGRect signBtnRect = CGRectMake(ScreenWitdh/2 - btnHeight, ScreenHeight/2 + 10, btnWidth, btnHeight);
    UIButton *signBtn = [UIButton createButtonWithFrame:signBtnRect Title:@"Sign Up\n注册" Target:self Selector:@selector(signUp:)];
    signBtn.tintColor = [UIColor whiteColor];
    [signBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [signBtn setUIButtonBorderColor:[UIColor whiteColor].CGColor borderWidth:1.0 borderRadius:5.0];
    signBtn.titleLabel.numberOfLines = 0;
    
    self.loginBtn = loginBtn;
    self.signBtn = signBtn;
    [self.view addSubview:bgImage];
    [bgImage addSubview:self.loginBtn];
    [bgImage addSubview:self.signBtn];
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(self.view.mas_top);
        make.leading.equalTo(self.view.mas_leading);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImage.mas_centerX);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(btnHeight);
        make.bottom.equalTo(bgImage.mas_centerY).offset(-20);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImage.mas_centerX);
        make.width.equalTo(signBtn.mas_width);
        make.height.equalTo(signBtn.mas_height);
        make.bottom.equalTo(signBtn.mas_top).offset(-20);
    }];
    
}

-(void)login:(id)sender
{
    YW_LoginViewController *loginVC = [[YW_LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)signUp:(id)sender
{
    YW_SignUpFirstViewController *suSVC = [[YW_SignUpFirstViewController alloc] init];
    [self.navigationController pushViewController:suSVC animated:YES];
}

@end
