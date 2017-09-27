//
//  YW_BaseViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/27.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_BaseViewController.h"
#import "YW_MenuSliderBar.h"

#define BottomMenuViewHeight 49     // 底部菜单高度

@interface YW_BaseViewController ()

@end

@implementation YW_BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"%s, line = %d", __func__, __LINE__);
    
    self.view.frame = CGRectMake(0, 0, ScreenWitdh, ScreenHeight);
    
//    [self setupBottomMenuView];
}

-(void)setupBottomMenuView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //        window.windowLevel =
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - BottomMenuViewHeight, ScreenWitdh, BottomMenuViewHeight)];
    menuView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    UIButton *mainBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BottomMenuViewHeight, BottomMenuViewHeight)];
    [mainBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    
    YW_MenuSliderBar *sliderMenu = [YW_MenuSingleton shareMenuInstance].sliderBar;
    
    if (![YW_MenuSingleton shareMenuInstance].sliderBar) {
        sliderMenu = [[YW_MenuSliderBar alloc] initWithFrame:CGRectMake(BottomMenuViewHeight, 0, menuView.width - mainBtn.width, BottomMenuViewHeight)];
        sliderMenu.maxShowNum = 3;
        
        [sliderMenu setUpMenuWithTitleArr:nil];    //初始化SliderBar
        
        //        [sliderMenu setUpMenuWithTitleArr:[NSMutableArray arrayWithObjects:@"Diary", @"Activity", @"News", @"Me", nil]];    //初始化SliderBar
        
        [YW_MenuSingleton initWithSlider:sliderMenu];
        
    }
    [[YW_MenuSingleton shareMenuInstance] setSliderBar:sliderMenu];
    [menuView addSubview:[YW_MenuSingleton shareMenuInstance].sliderBar];
    [menuView addSubview:mainBtn];
    
    [window addSubview:menuView];
}

@end
