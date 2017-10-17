//
//  YW_SignUpSecondViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/2.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_SignUpSecondViewController.h"
#import "YWQuestionView.h"
#import "YWQuestionViewCell.h"

#define TextFieldWidth ScreenWitdh * 3 / 4
#define TextFieldHeight 50
#define TextFieldCornerRadius 5
#define QuestionTableViewHeight 180
#define firstQuestionTableViewCellID @"firstQuestionCell"
#define secondQuestionTableViewCellID @"secondQuestionCell"
#define thirdQuestionTableViewCellID @"thirdQuestionCell"
#define customQuestionTableViewCellID @"customQuestionCell"

@interface YW_SignUpSecondViewController () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    CGFloat moveHeight;
    BOOL keyBoardShow;
}

@property(strong, nonatomic) UITextField *firstQuestionTextField;
@property(strong, nonatomic) YWQuestionView *firstQuestionView;
@property(strong, nonatomic) UITextField *firstAnswerTextField;
@property(strong, nonatomic) UITextField *secondQuestionTextField;
@property(strong, nonatomic) YWQuestionView *secondQuestionView;
@property(strong, nonatomic) UITextField *secondAnswerTextField;
@property(strong, nonatomic) UITextField *thirdQuestionTextField;
@property(strong, nonatomic) YWQuestionView *thirdQuestionView;
@property(strong, nonatomic) UITextField *thirdAnswerTextField;
@property(strong, nonatomic) UIButton *finishedBtn;
@property(strong, nonatomic) UITableView *firstQuestionTableView;
@property(strong, nonatomic) UITableView *secondQuestionTableView;
@property(strong, nonatomic) UITableView *thirdQuestionTableView;
@property(assign, nonatomic) BOOL isHideFirstQuestion;
@property(assign, nonatomic) BOOL isHideSecondQuestion;
@property(assign, nonatomic) BOOL isHideThirdQuestion;
@property(strong, nonatomic) NSMutableArray *questionArray;

@end

@implementation YW_SignUpSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

#pragma mark -- 当View即将出现时
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    keyBoardShow = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- 当View即将消失时
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.firstAnswerTextField resignFirstResponder];
    [self.secondAnswerTextField resignFirstResponder];
    [self.thirdAnswerTextField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(NSMutableArray *)questionArray
{
    if (_questionArray == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"securityQuestion.plist" ofType:nil];
        NSArray *tempArr = [NSArray arrayWithContentsOfFile:path];
        
        _questionArray = [NSMutableArray array];
        for (NSString *str in tempArr) {
            [_questionArray addObject:str];
        }
    }
    return _questionArray;
}

-(void)setupView
{
    self.title = @"Sign Up";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _isHideFirstQuestion = YES;
    _isHideSecondQuestion = YES;
    _isHideThirdQuestion = YES;
    
    //    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectQuestion:)];
    //    tapGestureRecognizer.numberOfTapsRequired = 1;
    //    tapGestureRecognizer.delegate = self;
    
    UITextField *firstQuestionTextField = [[UITextField alloc] init];
    firstQuestionTextField.layer.borderWidth = 1;
    firstQuestionTextField.layer.borderColor = [UIColor colorWithHexString:@"D2D2D2"].CGColor;
    firstQuestionTextField.layer.cornerRadius = TextFieldCornerRadius;
    firstQuestionTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TextFieldWidth, 0)];
    firstQuestionTextField.leftView.userInteractionEnabled = NO;
    firstQuestionTextField.leftViewMode = UITextFieldViewModeAlways;
    firstQuestionTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    YWQuestionView *firstQuestionView = [[YWQuestionView alloc] initWithFrame:CGRectMake(0, 0, TextFieldWidth, TextFieldHeight)];
    firstQuestionView.tag = 101;
    firstQuestionView.userInteractionEnabled = YES;
    [firstQuestionView setQuestionLabelText:@"安全问题01"];
    //    [firstQuestionView addGestureRecognizer:tapGestureRecognizer];
    [firstQuestionView.questionBtn addTarget:self action:@selector(selectQuestion:) forControlEvents:UIControlEventTouchUpInside];
    [firstQuestionTextField addSubview:firstQuestionView];
    
    UITextField *firstAnswerTextField = [[UITextField alloc] init];
    firstAnswerTextField.layer.borderWidth = 1;
    firstAnswerTextField.layer.borderColor = [UIColor colorWithHexString:@"D2D2D2"].CGColor;
    firstAnswerTextField.layer.cornerRadius = TextFieldCornerRadius;
    firstAnswerTextField.font = [UIFont systemFontOfSize:15];
    firstAnswerTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
    firstAnswerTextField.leftView.userInteractionEnabled = NO;
    firstAnswerTextField.leftViewMode = UITextFieldViewModeAlways;
    firstAnswerTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UILabel *firstAnswerLabel = [[UILabel alloc] init];
    firstAnswerLabel.text = @"答案";
    firstAnswerLabel.textAlignment = NSTextAlignmentCenter;
    
    [firstAnswerTextField addSubview:firstAnswerLabel];
    
    UITextField *secondQuestionTextField = [[UITextField alloc] init];
    secondQuestionTextField.layer.borderWidth = 1;
    secondQuestionTextField.layer.borderColor = [UIColor colorWithHexString:@"D2D2D2"].CGColor;
    secondQuestionTextField.layer.cornerRadius = TextFieldCornerRadius;
    secondQuestionTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TextFieldWidth, 0)];
    secondQuestionTextField.leftView.userInteractionEnabled = YES;
    secondQuestionTextField.leftViewMode = UITextFieldViewModeAlways;
    secondQuestionTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    YWQuestionView *secondQuestionView = [[YWQuestionView alloc] initWithFrame:CGRectMake(0, 0, TextFieldWidth, TextFieldHeight)];
    secondQuestionView.tag = 102;
    secondQuestionView.userInteractionEnabled = YES;
    [secondQuestionView setQuestionLabelText:@"安全问题02"];
    //    [secondQuestionView addGestureRecognizer:tapGestureRecognizer];
    [secondQuestionView.questionBtn addTarget:self action:@selector(selectQuestion:) forControlEvents:UIControlEventTouchUpInside];
    [secondQuestionTextField addSubview:secondQuestionView];
    
    UITextField *secondAnswerTextField = [[UITextField alloc] init];
    secondAnswerTextField.layer.borderWidth = 1;
    secondAnswerTextField.layer.borderColor = [UIColor colorWithHexString:@"D2D2D2"].CGColor;
    secondAnswerTextField.layer.cornerRadius = TextFieldCornerRadius;
    secondAnswerTextField.font = [UIFont systemFontOfSize:15];
    secondAnswerTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
    secondAnswerTextField.leftView.userInteractionEnabled = NO;
    secondAnswerTextField.leftViewMode = UITextFieldViewModeAlways;
    secondAnswerTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UILabel *secondAnswerLabel = [[UILabel alloc] init];
    secondAnswerLabel.text = @"答案";
    secondAnswerLabel.textAlignment = NSTextAlignmentCenter;
    
    [secondAnswerTextField addSubview:secondAnswerLabel];
    
    UITextField *thirdQuestionTextField = [[UITextField alloc] init];
    thirdQuestionTextField.layer.borderWidth = 1;
    thirdQuestionTextField.layer.borderColor = [UIColor colorWithHexString:@"D2D2D2"].CGColor;
    thirdQuestionTextField.layer.cornerRadius = TextFieldCornerRadius;
    thirdQuestionTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TextFieldWidth, 0)];
    thirdQuestionTextField.leftView.userInteractionEnabled = YES;
    thirdQuestionTextField.leftViewMode = UITextFieldViewModeAlways;
    thirdQuestionTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    YWQuestionView *thirdQuestionView = [[YWQuestionView alloc] initWithFrame:CGRectMake(0, 0, TextFieldWidth, TextFieldHeight)];
    thirdQuestionView.tag = 103;
    thirdQuestionView.userInteractionEnabled = YES;
    [thirdQuestionView setQuestionLabelText:@"安全问题03"];
    //    [thirdQuestionView addGestureRecognizer:tapGestureRecognizer];
    [thirdQuestionView.questionBtn addTarget:self action:@selector(selectQuestion:) forControlEvents:UIControlEventTouchUpInside];
    [thirdQuestionTextField addSubview:thirdQuestionView];
    
    UITextField *thirdAnswerTextField = [[UITextField alloc] init];
    thirdAnswerTextField.layer.borderWidth = 1;
    thirdAnswerTextField.layer.borderColor = [UIColor colorWithHexString:@"D2D2D2"].CGColor;
    thirdAnswerTextField.layer.cornerRadius = TextFieldCornerRadius;
    thirdAnswerTextField.font = [UIFont systemFontOfSize:15];
    thirdAnswerTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
    thirdAnswerTextField.leftView.userInteractionEnabled = NO;
    thirdAnswerTextField.leftViewMode = UITextFieldViewModeAlways;
    thirdAnswerTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UILabel *thirdAnswerLabel = [[UILabel alloc] init];
    thirdAnswerLabel.text = @"答案";
    thirdAnswerLabel.textAlignment = NSTextAlignmentCenter;
    
    [thirdAnswerTextField addSubview:thirdAnswerLabel];
    
    UITableView *firstQuestionTableView = [[UITableView alloc] init];
    firstQuestionTableView.layer.borderWidth = 1.0;
    firstQuestionTableView.layer.borderColor = [UIColor colorWithHexString:CustomBorderColor].CGColor;
    firstQuestionTableView.backgroundColor = [UIColor whiteColor];
    firstQuestionTableView.delegate = self;
    firstQuestionTableView.dataSource = self;
    firstQuestionTableView.scrollEnabled = NO;
    firstQuestionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITableView *secondQuestionTableView = [[UITableView alloc] init];
    secondQuestionTableView.layer.borderWidth = 1.0;
    secondQuestionTableView.layer.borderColor = [UIColor colorWithHexString:CustomBorderColor].CGColor;
    secondQuestionTableView.backgroundColor = [UIColor whiteColor];
    secondQuestionTableView.delegate = self;
    secondQuestionTableView.dataSource = self;
    secondQuestionTableView.scrollEnabled = NO;
    secondQuestionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITableView *thirdQuestionTableView = [[UITableView alloc] init];
    thirdQuestionTableView.layer.borderWidth = 1.0;
    thirdQuestionTableView.layer.borderColor = [UIColor colorWithHexString:CustomBorderColor].CGColor;
    thirdQuestionTableView.backgroundColor = [UIColor whiteColor];
    thirdQuestionTableView.delegate = self;
    thirdQuestionTableView.dataSource = self;
    thirdQuestionTableView.scrollEnabled = NO;
    thirdQuestionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *finishedBtn = [UIButton createButtonWithFrame:CGRectMake(0, 0, 0, 0) Title:@"完成\nFinished" Target:self Selector:@selector(next:)];
    finishedBtn.backgroundColor = [UIColor colorWithHexString:@"FC4F52"];
    finishedBtn.titleLabel.numberOfLines = 0;
    finishedBtn.tintColor = [UIColor whiteColor];
    [finishedBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    finishedBtn.layer.cornerRadius = TextFieldCornerRadius;
    
    self.firstQuestionTextField = firstQuestionTextField;
    self.firstQuestionView = firstQuestionView;
    self.firstAnswerTextField = firstAnswerTextField;
    self.secondQuestionTextField = secondQuestionTextField;
    self.secondQuestionView = secondQuestionView;
    self.secondAnswerTextField = secondAnswerTextField;
    self.thirdQuestionTextField = thirdQuestionTextField;
    self.thirdQuestionView = thirdQuestionView;
    self.thirdAnswerTextField = thirdAnswerTextField;
    self.finishedBtn = finishedBtn;
    self.firstQuestionTableView = firstQuestionTableView;
    self.secondQuestionTableView = secondQuestionTableView;
    self.thirdQuestionTableView = thirdQuestionTableView;
    [self.view addSubview:self.firstQuestionTextField];
    [self.view addSubview:self.firstAnswerTextField];
    [self.view addSubview:self.secondQuestionTextField];
    [self.view addSubview:self.secondAnswerTextField];
    [self.view addSubview:self.thirdQuestionTextField];
    [self.view addSubview:self.thirdAnswerTextField];
    [self.view addSubview:self.finishedBtn];
    [self.view addSubview:self.firstQuestionTableView];
    [self.view addSubview:self.secondQuestionTableView];
    [self.view addSubview:self.thirdQuestionTableView];
    
    
    [firstQuestionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(TextFieldWidth);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.view.mas_top).offset(100);
    }];
    
    [firstAnswerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(firstQuestionTextField.mas_leading);
        make.top.equalTo(firstQuestionTextField.mas_bottom).offset(10);
        make.width.mas_equalTo(TextFieldWidth);
        make.height.mas_equalTo(TextFieldHeight);
    }];
    
    [firstAnswerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(firstAnswerTextField.mas_leading).offset(10);
        make.top.equalTo(firstAnswerTextField.mas_top);
        make.height.equalTo(firstAnswerTextField.mas_height);
    }];
    
    [secondQuestionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(TextFieldWidth);
        make.height.mas_equalTo(50);
        make.top.equalTo(firstAnswerTextField.mas_bottom).offset(10);
    }];
    
    [secondAnswerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(secondQuestionTextField.mas_leading);
        make.top.equalTo(secondQuestionTextField.mas_bottom).offset(10);
        make.width.mas_equalTo(TextFieldWidth);
        make.height.mas_equalTo(TextFieldHeight);
    }];
    
    [secondAnswerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(secondAnswerTextField.mas_leading).offset(10);
        make.top.equalTo(secondAnswerTextField.mas_top);
        make.height.equalTo(secondAnswerTextField.mas_height);
    }];
    
    [thirdQuestionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(TextFieldWidth);
        make.height.mas_equalTo(50);
        make.top.equalTo(secondAnswerTextField.mas_bottom).offset(10);
    }];
    
    [thirdAnswerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(thirdQuestionTextField.mas_leading);
        make.top.equalTo(thirdQuestionTextField.mas_bottom).offset(10);
        make.width.mas_equalTo(TextFieldWidth);
        make.height.mas_equalTo(TextFieldHeight);
    }];
    
    [thirdAnswerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(thirdAnswerTextField.mas_leading).offset(10);
        make.top.equalTo(thirdAnswerTextField.mas_top);
        make.height.equalTo(thirdAnswerTextField.mas_height);
    }];
    
    [finishedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TextFieldWidth);
        make.height.mas_equalTo(TextFieldHeight);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(thirdAnswerTextField.mas_bottom).offset(20);
    }];
    
    [firstQuestionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.firstQuestionTextField.mas_leading);
        make.trailing.equalTo(self.firstQuestionTextField.mas_trailing).offset(-TextFieldHeight + 1);
        make.top.equalTo(self.firstQuestionTextField.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    
    [secondQuestionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.secondQuestionTextField.mas_leading);
        make.trailing.equalTo(self.secondQuestionTextField.mas_trailing).offset(-TextFieldHeight + 1);
        make.top.equalTo(self.secondQuestionTextField.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    
    [thirdQuestionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.thirdQuestionTextField.mas_leading);
        make.trailing.equalTo(self.thirdQuestionTextField.mas_trailing).offset(-TextFieldHeight + 1);
        make.top.equalTo(self.thirdQuestionTextField.mas_bottom);
        make.height.mas_equalTo(0);
    }];
}

#pragma mark -- UITableViewDelegate | UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.firstQuestionTableView) {
        if (indexPath.row != 3) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:firstQuestionTableViewCellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:firstQuestionTableViewCellID];
                cell.textLabel.text = self.questionArray[indexPath.row];
            }
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customQuestionTableViewCellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:customQuestionTableViewCellID];
                cell.textLabel.text = @"Custom Question";
            }
            return cell;
        }
    }
    else if (tableView == self.secondQuestionTableView)
    {
        if (indexPath.row != 3) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:firstQuestionTableViewCellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:firstQuestionTableViewCellID];
                cell.textLabel.text = self.questionArray[indexPath.row + 3];
            }
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customQuestionTableViewCellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:customQuestionTableViewCellID];
                cell.textLabel.text = @"Custom Question";
            }
            return cell;
        }
    }
    else
    {
        if (indexPath.row != 3) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:firstQuestionTableViewCellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:firstQuestionTableViewCellID];
                cell.textLabel.text = self.questionArray[indexPath.row + 6];
            }
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customQuestionTableViewCellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:customQuestionTableViewCellID];
                cell.textLabel.text = @"Custom Question";
            }
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.firstQuestionTableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.firstQuestionView.questionLabel setText:cell.textLabel.text];
        _isHideFirstQuestion = !_isHideFirstQuestion;
    }
    else if (tableView == self.secondQuestionTableView)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.secondQuestionView.questionLabel setText:cell.textLabel.text];
        _isHideSecondQuestion = !_isHideSecondQuestion;
    }
    else
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.thirdQuestionView.questionLabel setText:cell.textLabel.text];
        _isHideThirdQuestion = !_isHideThirdQuestion;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SelectQuestion
-(void)selectQuestion:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    switch ([btn superview].tag) {
        case 101:
        {
            if (_isHideFirstQuestion) {
                [self showQuestionTableView:1];
            }
            else
            {
                [self hideQuestionTableView:1];
            }
            _isHideFirstQuestion = !_isHideFirstQuestion;
            break;
        }
        case 102:
        {
            if (_isHideSecondQuestion) {
                [self showQuestionTableView:2];
            }else
            {
                [self hideQuestionTableView:2];
            }
            _isHideSecondQuestion = !_isHideSecondQuestion;
            break;
        }
            
        case 103:
        {
            if (_isHideThirdQuestion) {
                [self showQuestionTableView:3];
            }
            else
            {
                [self hideQuestionTableView:3];
            }
            _isHideThirdQuestion = !_isHideThirdQuestion;
            break;
        }
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return QuestionTableViewHeight / 4;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)hideQuestionTableView:(int) index
{
    
    switch (index) {
        case 1:
        {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.firstQuestionTableView.frame;
                rect.size.height = 0;
                self.firstQuestionTableView.frame = rect;
            } completion:nil];
            break;
        }
        case 2:
        {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.secondQuestionTableView.frame;
                rect.size.height = 0;
                self.secondQuestionTableView.frame = rect;
            } completion:nil];
        }
        case 3:
        {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.thirdQuestionTableView.frame;
                rect.size.height = 0;
                self.thirdQuestionTableView.frame = rect;
            } completion:nil];
            break;
        }
        default:
            break;
    }
    
}

-(void)showQuestionTableView:(int) index
{
    switch (index) {
        case 1:
        {
            if (!_isHideSecondQuestion) {
                [self hideQuestionTableView:2];
                _isHideSecondQuestion = !_isHideSecondQuestion;
            }
            
            if (!_isHideThirdQuestion)
            {
                [self hideQuestionTableView:3];
                _isHideThirdQuestion = !_isHideThirdQuestion;
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.firstQuestionTableView.frame;
                rect.size.height = QuestionTableViewHeight;
                self.firstQuestionTableView.frame = rect;
            } completion:nil];
            break;
        }
        case 2:
        {
            if (!_isHideFirstQuestion) {
                [self hideQuestionTableView:1];
                _isHideFirstQuestion = !_isHideFirstQuestion;
            }
            
            if (!_isHideThirdQuestion)
            {
                [self hideQuestionTableView:3];
                _isHideThirdQuestion = !_isHideThirdQuestion;
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.secondQuestionTableView.frame;
                rect.size.height = QuestionTableViewHeight;
                self.secondQuestionTableView.frame = rect;
            } completion:nil];
            break;
        }
        case 3:
        {
            if (!_isHideFirstQuestion) {
                [self hideQuestionTableView:1];
                _isHideFirstQuestion = !_isHideFirstQuestion;
            }
            
            if (!_isHideSecondQuestion)
            {
                [self hideQuestionTableView:2];
                _isHideSecondQuestion = !_isHideSecondQuestion;
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.thirdQuestionTableView.frame;
                rect.size.height = QuestionTableViewHeight;
                self.thirdQuestionTableView.frame = rect;
            } completion:nil];
            break;
        }
        default:
            break;
    }
}

-(void)next:(id)sender
{
    [self alertMsg:@"注册成功" confimBlock:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    } cancleBlock:nil];
}

#pragma mark - 监听键盘弹出
-(void)keyBoardWillShow:(NSNotification *)notification
{
    if (keyBoardShow) {
        return;
    }
    
    keyBoardShow = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    
    CGFloat animationDurationValue = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGRect keyBoardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat finishedBtnMaxY = CGRectGetMaxY(self.finishedBtn.frame);
    
    moveHeight = finishedBtnMaxY - keyBoardFrame.origin.y + 90;
    [UIView animateWithDuration:animationDurationValue animations:^{
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= moveHeight;
        self.view.frame = viewFrame;
    }];
}

#pragma mark - 监听键盘隐藏
-(void)keyBoardWillHide:(NSNotification *)notification
{
    keyBoardShow = NO;
    
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.firstAnswerTextField resignFirstResponder];
    [self.secondAnswerTextField resignFirstResponder];
    [self.thirdAnswerTextField resignFirstResponder];
}

@end
