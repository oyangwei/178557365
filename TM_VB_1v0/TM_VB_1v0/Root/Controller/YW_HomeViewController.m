//
//  YW_HomeViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/22.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_HomeViewController.h"
#import "YW_IconButton.h"
#import "YW_MenuSliderBar.h"
#import "YW_DiaryViewController.h"
#import "YW_NavigationController.h"

#define ButtonViewLeftMargin 30      // 存放按钮容器距离左边间距
#define ButtonColumnMarginSpace 35         // 按钮列间距
#define ButtonRowMarginSpace 30         // 按钮行间距
#define ColumnNumber 3                  // 列数
#define IconButtonLabelHeight 25     // 图标按钮文字高度
#define BottomMenuViewHeight 49     // 底部菜单高度

@interface YW_HomeViewController ()

@end

@implementation YW_HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setUIViewBackgroud:self.view name:@"home_bg"];
    
    [self setupContentView];
    
    [self setupBottomMenuView];
}

-(void)setupContentView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ButtonViewLeftMargin, 64, self.view.width - 2 * ButtonViewLeftMargin, self.view.height - BottomMenuViewHeight - 104)];
    [self.view addSubview:view];
    
    NSArray *iconTitles = [NSArray arrayWithObjects:@"Diary", @"Activity", @"Me", @"News", nil];
    
    // 计算按钮的Y坐标 (从下往上排列)
//    CGFloat buttonW = (view.width - (ColumnNumber - 1) * ButtonColumnMarginSpace) / ColumnNumber;
  //  CGFloat buttonH = buttonW + IconButtonLabelHeight;
 //   CGFloat buttonX = 0;
 //  CGFloat buttonY = view.height - buttonW;
    
    // 计算按钮的Y坐标(从上往下排列)
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    CGFloat buttonW = (view.width - (ColumnNumber - 1) * ButtonColumnMarginSpace) / ColumnNumber;
    CGFloat buttonH = buttonW + IconButtonLabelHeight;
    
    NSInteger rowNumber = iconTitles.count % ColumnNumber ? (NSInteger)(iconTitles.count / ColumnNumber) + 1 : (NSInteger)(iconTitles.count / ColumnNumber);   //计算行数
    
    for (int i = 0; i < rowNumber; i ++) {
        buttonY = buttonH * i + i * ButtonRowMarginSpace;  //计算按钮的Y坐标 (从上往下排列)
        
     //   buttonY = view.height - (buttonH * (i + 1) + i * ButtonRowMarginSpace);  //计算按钮的Y坐标(从下往上排列)
        
        CGFloat rowMaxCount = ColumnNumber;
        if (i == rowNumber - 1) {
            rowMaxCount = iconTitles.count % ColumnNumber;  //计算当前行存放的Button最大数量
        }
        
        for (int j = 0; j < rowMaxCount; j ++) {
            buttonX = buttonW * j + ButtonRowMarginSpace * j;
            
            YW_IconButton *button = [[YW_IconButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
            button.tag = 100 + i;
            button.alpha = 0.7;
            [button setImage:[UIImage imageNamed:@"testBg"] forState:UIControlStateNormal];
            [button setTitle:iconTitles[i * ColumnNumber + j] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:button];
        }
    }
}

-(void)setupBottomMenuView
{
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - BottomMenuViewHeight, self.view.width, BottomMenuViewHeight)];
    menuView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    UIButton *mainBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BottomMenuViewHeight, BottomMenuViewHeight)];
    [mainBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [mainBtn addTarget:self action:@selector(mainClick:) forControlEvents:UIControlEventTouchUpInside];

    YW_MenuSliderBar *sliderMenu = [[YW_MenuSliderBar alloc] initWithFrame:CGRectMake(BottomMenuViewHeight, 0, menuView.width - mainBtn.width, BottomMenuViewHeight)];
    sliderMenu.maxShowNum = 3;
    
    [sliderMenu setUpMenuWithTitleArr:[NSMutableArray arrayWithObjects:@"Diary", @"Activity", @"Me", @"Discovery", @"More", nil]];
    
    [menuView addSubview:sliderMenu];
    [menuView addSubview:mainBtn];
    
    [self.view addSubview:menuView];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)buttonClick:(UIButton *)button
{
    switch (button.tag - 100) {
        case 0:
        {
            YW_DiaryViewController *diaryVC = [[YW_DiaryViewController alloc] init];
            YW_NavigationController *nVC = [[YW_NavigationController alloc] initWithRootViewController:diaryVC];
            
                self.view.window.rootViewController = nVC;
            break;
        }
        default:
            break;
    }
}

-(void)mainClick:(UIButton *)button
{
    NSLog(@"%s, line = %d", __func__, __LINE__);
}

-(void)shakeAnimation:(UIButton *)button
{
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    CGFloat angle = M_PI / 36;
    NSArray *values = @[@(angle), @(-angle), @(angle)];
    [shake setValues:values];
    [shake setRepeatCount:100];
    [shake setDuration:0.5];
    
    [button.imageView.layer addAnimation:shake forKey:nil];
    [button.imageView startAnimating];
    
}


@end