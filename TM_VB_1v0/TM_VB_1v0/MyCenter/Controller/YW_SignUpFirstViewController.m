//
//  YW_SignUpFirstViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/2.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_SignUpFirstViewController.h"
#import "YW_SignUpSecondViewController.h"

#import "YWAreaCodeView.h"
#import "YWAreaCodeViewCell.h"
#import "YWCommonMethod.h"

#define TextFieldWidth ScreenWitdh * 3 / 4
#define TextFieldHeight 50
#define TextFieldCornerRadius 5
#define LeftTime 20

@interface YW_SignUpFirstViewController () <UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    CGFloat moveHeight;
}

@property(strong, nonatomic) UITextField *areaCodeTextField;
@property(strong, nonatomic) YWAreaCodeView *areaCodeView;
@property(strong, nonatomic) UITextField *phoneTextField;
@property(strong, nonatomic) UITextField *codeTextField;
@property(strong, nonatomic) UITextField *userNameTextField;
@property(strong, nonatomic) UITextField *passwordTextField;
@property(strong, nonatomic) UIButton *getCodeBtn;
@property(strong, nonatomic) UIButton *nextBtn;
@property(strong, nonatomic) UILabel *promptLabel;
@property(strong, nonatomic) NSTimer *timer;
@property(assign, nonatomic) int leftTime;
@property(strong, nonatomic) NSString *Sid;  //会话id
@property(assign, nonatomic) BOOL getCodeSeccess; //获取验证码是否成功
@property(strong, nonatomic) UIPickerView *areaCodePickerView;  //创建国家区号滚动框
@property(strong, nonatomic) NSMutableArray *areaCodeArray;


@end

@implementation YW_SignUpFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(NSMutableArray *)areaCodeArray
{
    if (_areaCodeArray == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"areaCode.plist" ofType:nil];
        NSArray *tempArr = [NSArray arrayWithContentsOfFile:path];
        
        _areaCodeArray = [NSMutableArray array];
        for (NSDictionary *dic in tempArr) {
            [_areaCodeArray addObject:dic];
        }
    }
    return _areaCodeArray;
}

#pragma mark -- 当View即将出现时
-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

#pragma mark -- 当View即将消失时
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



#pragma mark -- 初始化界面
-(void)setupView
{
    self.title = @"Sing Up";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *areaCodeTextField = [[UITextField alloc] init];
    areaCodeTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    areaCodeTextField.leftView.userInteractionEnabled = NO;
    areaCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    areaCodeTextField.layer.borderWidth = 1;
    areaCodeTextField.layer.borderColor = [UIColor colorWithHexString:@"#D2D2D2"].CGColor;
    areaCodeTextField.layer.cornerRadius = TextFieldCornerRadius;
    
    YWAreaCodeView *areaCodeView = [[YWAreaCodeView alloc] init];
    [areaCodeView setCodeLabel:@"+86" areaLabel:@"中国"];
    areaCodeView.userInteractionEnabled = YES;
    [areaCodeTextField addSubview:areaCodeView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAreaCode:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.delegate = self;
    [areaCodeView addGestureRecognizer:tapGestureRecognizer];
    
    UITextField *phoneTextField = [[UITextField alloc] init];
    phoneTextField.placeholder = @"Mobile Phone";
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    phoneTextField.leftView.userInteractionEnabled = NO;
    phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    phoneTextField.layer.borderWidth = 1;
    phoneTextField.layer.borderColor = [UIColor colorWithHexString:@"#D2D2D2"].CGColor;
    phoneTextField.layer.cornerRadius = TextFieldCornerRadius;
    
    UITextField *codeTextField = [[UITextField alloc] init];
    codeTextField.placeholder = @"Code";
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    codeTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    codeTextField.leftView.userInteractionEnabled = NO;
    codeTextField.leftViewMode = UITextFieldViewModeAlways;
    codeTextField.layer.borderWidth = 1;
    codeTextField.layer.borderColor = [UIColor colorWithHexString:@"#D2D2D2"].CGColor;
    codeTextField.layer.cornerRadius = TextFieldCornerRadius;
    
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
    
    UIButton *getCodeBtn = [UIButton createButtonWithFrame:CGRectMake(0, 0, 0, 0) Title:@"获取验证码" Target:self Selector:@selector(getCode:)];
    getCodeBtn.backgroundColor = [UIColor colorWithHexString:ThemeColor];
    getCodeBtn.tintColor = [UIColor whiteColor];
    getCodeBtn.layer.cornerRadius = TextFieldCornerRadius;
    
    UIButton *nextBtn = [UIButton createButtonWithFrame:CGRectMake(0, 0, 0, 0) Title:@"Next\n下一步" Target:self Selector:@selector(next:)];
    nextBtn.backgroundColor = [UIColor whiteColor];
    nextBtn.tintColor = [UIColor colorWithHexString:ThemeColor];
    [nextBtn setUIButtonBorderColor:[UIColor colorWithHexString:ThemeColor].CGColor borderWidth:1.0 borderRadius:TextFieldCornerRadius];
    nextBtn.titleLabel.numberOfLines = 0;
    nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.text = @"还有一步\n1 Steps Left";
    promptLabel.textColor = [UIColor grayColor];
    promptLabel.layer.borderWidth = 0;
    promptLabel.font = [UIFont systemFontOfSize:12.0];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.numberOfLines = 0;
    
    /**
     * 创建国家区号滚动框
     */
    UIPickerView *areaCodePickerView = [[UIPickerView alloc] init];
    areaCodePickerView.alpha = 0.0;
    areaCodePickerView.layer.borderWidth = 1.0;
    areaCodePickerView.layer.borderColor = [UIColor colorWithHexString:CustomBorderColor].CGColor;
    areaCodePickerView.backgroundColor = [UIColor whiteColor];
    areaCodePickerView.delegate = self;
    areaCodePickerView.dataSource = self;
    
    self.areaCodeTextField = areaCodeTextField;
    self.areaCodeView = areaCodeView;
    self.phoneTextField = phoneTextField;
    self.userNameTextField = userNameTextField;
    self.passwordTextField = passwordTextField;
    self.codeTextField = codeTextField;
    self.getCodeBtn = getCodeBtn;
    self.nextBtn = nextBtn;
    self.promptLabel = promptLabel;
    self.areaCodePickerView = areaCodePickerView;
    
    [self.view addSubview:self.areaCodeTextField];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.userNameTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.codeTextField];
    [self.view addSubview:self.getCodeBtn];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.areaCodePickerView];
    
    [areaCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(TextFieldWidth);
        make.height.mas_equalTo(TextFieldHeight);
        make.top.equalTo(self.view.mas_top).offset(120);
    }];
    
    [areaCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(areaCodeTextField);
        make.leading.equalTo(areaCodeTextField);
        make.bottom.equalTo(areaCodeTextField);
        make.trailing.equalTo(areaCodeTextField);
    }];
    
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(areaCodeTextField.mas_leading);
        make.top.equalTo(areaCodeTextField.mas_bottom).offset(10);
        make.width.mas_equalTo(TextFieldWidth);
        make.height.mas_equalTo(TextFieldHeight);
    }];
    
    [userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(phoneTextField.mas_leading);
        make.top.equalTo(phoneTextField.mas_bottom).offset(10);
        make.width.mas_equalTo(TextFieldWidth);
        make.height.mas_equalTo(TextFieldHeight);
    }];
    
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(userNameTextField.mas_leading);
        make.top.equalTo(userNameTextField.mas_bottom).offset(10);
        make.width.mas_equalTo(TextFieldWidth);
        make.height.mas_equalTo(TextFieldHeight);
    }];
    
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(areaCodeTextField.mas_leading);
        make.top.equalTo(passwordTextField.mas_bottom).offset(10);
        make.width.mas_equalTo(TextFieldWidth * 1 / 2);
        make.height.mas_equalTo(TextFieldHeight);
    }];
    
    [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(areaCodeTextField.mas_trailing);
        make.leading.equalTo(codeTextField.mas_trailing).offset(10);
        make.top.equalTo(codeTextField.mas_top);
        make.height.mas_equalTo(TextFieldHeight);
    }];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(areaCodeTextField.mas_leading);
        make.top.equalTo(codeTextField.mas_bottom).offset(20);
        make.width.mas_equalTo(TextFieldWidth);
        make.height.mas_equalTo(TextFieldHeight);
    }];
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(areaCodeTextField.mas_leading);
        make.top.equalTo(nextBtn.mas_bottom).offset(5);
        make.width.mas_equalTo(TextFieldWidth);
        make.height.mas_equalTo(TextFieldHeight - 20);
    }];
    
    [areaCodePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.areaCodeTextField.mas_leading);
        make.trailing.equalTo(self.areaCodeTextField.mas_trailing).offset(-50);
        make.top.equalTo(self.areaCodeTextField.mas_bottom);
        make.height.mas_equalTo(180);
    }];
}

#pragma mark -- 下拉选择国家区号
-(void)selectAreaCode:(UITapGestureRecognizer *)tap
{
    self.areaCodePickerView.alpha = 1.0;
}

#pragma mark -- 获取验证码
-(void)getCode:(id)sender
{
    if (![[YWCommonMethod sharedCommonMethod] validMobile:self.phoneTextField.text]) {
        [self alertMsg:@"手机号无效" confimBlock:nil];
        return;
    }
    
    self.leftTime = LeftTime;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (self.leftTime > 0) {
            self.leftTime--;
            [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ds", self.leftTime] forState:UIControlStateNormal];
            [self.getCodeBtn setEnabled:NO];
        }
        else
        {
            [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.getCodeBtn setEnabled:YES];
            if ([self.timer isValid]) {
                [self.timer invalidate];
                return;
            }
        }
    }];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: self.phoneTextField.text, @"phone", @"86", @"zipCode", nil];
    
    [YWNetworkingMamager postWithURLString:GetCodeURL parameters:parameters progress:nil success:^(NSDictionary *data) {
        self.Sid = data[@"sid"];
        self.getCodeSeccess = true;
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [self alertMsg:@"获取验证码失败" confimBlock:nil];
    }];
}

#pragma mark -- UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.areaCodeArray.count;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    YWAreaCodeViewCell *areaCodeView = [[YWAreaCodeViewCell alloc] init];
    if (!view) {
        view = areaCodeView;
    }
    
    NSDictionary *dicData = self.areaCodeArray[row];
    [areaCodeView setCodeLabel:dicData[@"code"] areaLabel:dicData[@"area"]];
    
    return view;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary * dicData = _areaCodeArray[row];
    [self.areaCodeView setCodeLabel:dicData[@"code"] areaLabel:dicData[@"area"]];
    self.areaCodePickerView.alpha = 0;
}

//判断手机号码格式是否正确
-(void)next:(id)sender
{
    //    if (!self.getCodeSeccess) {
    //        [self alertMsg:@"获取验证码失败" confimBlock:nil];
    //        return;
    //    }
    //    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: self.codeTextField.text, @"SMSCode", self.Sid, @"Sid", nil];
    //
    //    [YWNetworkingMamager postWithURLString:CheckCodeURL parameters:parameters progress:nil success:^(NSDictionary *data) {
    //        NSLog(@"%@", data);
    //        if ([data[@"result"] isEqualToString:@"0"]) {
    //            [self alertMsg:@"验证成功" confimBlock:^{
    //                YWSignUpSecondViewController *susVC = [[YWSignUpSecondViewController alloc] init];
    //                [self.navigationController pushViewController:susVC animated:YES];
    //            }];
    //        }
    //    } failure:^(NSError *error) {
    //        NSLog(@"%@", error);
    //        [self alertMsg:@"获取验证码失败" confimBlock:nil];
    //    }];
    
    YW_SignUpSecondViewController *susVC = [[YW_SignUpSecondViewController alloc] init];
    [self.navigationController pushViewController:susVC animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    self.areaCodePickerView.alpha = 0;
}
#pragma mark - 监听键盘弹出
-(void)keyBoardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    CGFloat animationDurationValue = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGRect keyBoardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat nextBtnMaxY = CGRectGetMaxY(self.nextBtn.frame);
    
    if (keyBoardFrame.origin.y <= nextBtnMaxY) {
        moveHeight = nextBtnMaxY - keyBoardFrame.origin.y + 10;
        [UIView animateWithDuration:animationDurationValue animations:^{
            CGRect viewFrame = self.view.frame;
            viewFrame.origin.y -= moveHeight;
            self.view.frame = viewFrame;
        }];
    }
}

#pragma mark - 监听键盘隐藏
-(void)keyBoardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    CGFloat animationDurationValue = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (moveHeight) {
        [UIView animateWithDuration:animationDurationValue animations:^{
            CGRect viewFrame = self.view.frame;
            viewFrame.origin.y += moveHeight;
            self.view.frame = viewFrame;
        }];
    }
}


@end
