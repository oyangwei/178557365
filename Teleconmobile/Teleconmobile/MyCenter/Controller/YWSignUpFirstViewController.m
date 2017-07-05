//
//  YWSignUpFirstViewController.m
//  Teleconmobile
//
//  Created by YangWei on 17/6/26.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YWSignUpFirstViewController.h"
#import "YWSignUpSecondViewController.h"

#import "YWAreaCodeView.h"
#import "YWAreaCodeViewCell.h"

#define TextFieldWidth ScreenWitdh * 3 / 4
#define TextFieldHeight 50
#define TextFieldCornerRadius 5
#define LeftTime 20

@interface YWSignUpFirstViewController () <UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property(strong, nonatomic) UITextField *areaCodeTextField;
@property(strong, nonatomic) YWAreaCodeView *areaCodeView;
@property(strong, nonatomic) UITextField *phoneTextField;
@property(strong, nonatomic) UITextField *codeTextField;
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

@implementation YWSignUpFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];
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

#pragma mark -- 当View加载时
-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    
    UIButton *getCodeBtn = [UIButton createButtonWithFrame:CGRectMake(0, 0, 0, 0) Title:@"获取验证码" Target:self Selector:@selector(getCode:)];
    getCodeBtn.backgroundColor = [UIColor colorWithHexString:@"#FC4F52"];
    getCodeBtn.tintColor = [UIColor whiteColor];
    getCodeBtn.layer.cornerRadius = TextFieldCornerRadius;
    
    UIButton *nextBtn = [UIButton createButtonWithFrame:CGRectMake(0, 0, 0, 0) Title:@"Next\n下一步" Target:self Selector:@selector(next:)];
    nextBtn.backgroundColor = [UIColor whiteColor];
    nextBtn.tintColor = [UIColor colorWithHexString:@"#FC4F52"];
    [nextBtn setUIButtonBorderColor:[UIColor colorWithHexString:@"FC4F52"].CGColor borderWidth:1.0 borderRadius:TextFieldCornerRadius];
    nextBtn.titleLabel.numberOfLines = 0;
    nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.text = @"还有两步\n2 Steps Left";
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
    self.codeTextField = codeTextField;
    self.getCodeBtn = getCodeBtn;
    self.nextBtn = nextBtn;
    self.promptLabel = promptLabel;
    self.areaCodePickerView = areaCodePickerView;
    
    [self.view addSubview:self.areaCodeTextField];
    [self.view addSubview:self.codeTextField];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.getCodeBtn];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.areaCodePickerView];
    
    [areaCodeTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(TextFieldWidth);
        make.height.equalTo(TextFieldHeight);
        make.top.equalTo(self.view.mas_top).offset(120);
    }];
    
    [areaCodeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(areaCodeTextField);
        make.leading.equalTo(areaCodeTextField);
        make.bottom.equalTo(areaCodeTextField);
        make.trailing.equalTo(areaCodeTextField);
    }];
    
    [phoneTextField makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(areaCodeTextField.mas_leading);
        make.top.equalTo(areaCodeTextField.mas_bottom).offset(10);
        make.width.equalTo(TextFieldWidth);
        make.height.equalTo(TextFieldHeight);
    }];
    
    [codeTextField makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(areaCodeTextField.mas_leading);
        make.top.equalTo(phoneTextField.mas_bottom).offset(10);
        make.width.equalTo(TextFieldWidth * 1 / 2);
        make.height.equalTo(TextFieldHeight);
    }];
    
    [getCodeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(areaCodeTextField.mas_trailing);
        make.leading.equalTo(codeTextField.mas_trailing).offset(10);
        make.top.equalTo(codeTextField.mas_top);
        make.height.equalTo(TextFieldHeight);
    }];
    
    [nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(areaCodeTextField.mas_leading);
        make.top.equalTo(codeTextField.mas_bottom).offset(20);
        make.width.equalTo(TextFieldWidth);
        make.height.equalTo(TextFieldHeight);
    }];
    
    [promptLabel makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(areaCodeTextField.mas_leading);
        make.top.equalTo(nextBtn.mas_bottom).offset(5);
        make.width.equalTo(TextFieldWidth);
        make.height.equalTo(TextFieldHeight - 20);
    }];
    
    [areaCodePickerView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.areaCodeTextField.mas_leading);
        make.trailing.equalTo(self.areaCodeTextField.mas_trailing).offset(-50);
        make.top.equalTo(self.areaCodeTextField.mas_bottom);
        make.height.equalTo(180);
    }];
}

#pragma mark -- 下拉选择国家区号
-(void)selectAreaCode:(UITapGestureRecognizer *)tap
{
    NSLog(@"%s %d", __func__, __LINE__);
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
    
    YWSignUpSecondViewController *susVC = [[YWSignUpSecondViewController alloc] init];
    [self.navigationController pushViewController:susVC animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    self.areaCodePickerView.alpha = 0;
}

@end
