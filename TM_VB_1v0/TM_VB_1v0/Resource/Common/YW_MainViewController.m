//
//  YW_MainViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/27.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_MainViewController.h"
#import "YW_MenuSliderBar.h"
#import "YW_MoreViewController.h"
#import "YW_HomeViewController.h"
#import "YW_MenuButton.h"
#import "YW_DiaryViewController.h"
#import "YW_ActivityViewController.h"
#import "YW_NewsViewController.h"
#import "YW_MeViewController.h"
#import "SPKitExample.h"

#define BottomMenuViewHeight 49     // 底部菜单高度

@interface YW_MainViewController ()
{
    BOOL isDiaryVC;
}

/** 菜单栏 */
@property(strong, nonatomic) YW_MenuSliderBar *sliderMenu;

/** 当前界面 */
@property(strong, nonatomic) NSString *currentTitle;

@end

@implementation YW_MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUIViewBackgroud:self.view name:@"home_bg"];
    
    YW_HomeViewController *homeVc = [[YW_HomeViewController alloc] init];
    
    [self setupViewController:homeVc];
    
    [self setupBottomMenuView];
}

-(void)setupViewController:(UIViewController *)vc
{
    if (self.childViewControllers.count > 0) {
        for (int i = 0; i < self.childViewControllers.count; i ++ ) {
            [self.childViewControllers[i].view removeFromSuperview];
            [self.childViewControllers[i] removeFromParentViewController];
        }
    }
    
    [self addChildViewController:vc];
    
    vc.view.frame = CGRectMake(0, 0, ScreenWitdh, ScreenHeight - 49);
    
    [self.view addSubview:vc.view];
}

-(void)setupBottomMenuView
{
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - BottomMenuViewHeight, ScreenWitdh, BottomMenuViewHeight)];
    menuView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    UIButton *mainBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BottomMenuViewHeight, BottomMenuViewHeight)];
    [mainBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [mainBtn addTarget:self action:@selector(mainClick:) forControlEvents:UIControlEventTouchUpInside];
    
    YW_MenuSliderBar *sliderMenu = [[YW_MenuSliderBar alloc] initWithFrame:CGRectMake(BottomMenuViewHeight, 0, menuView.width - mainBtn.width, BottomMenuViewHeight)];
    sliderMenu.maxShowNum = 3;
    [sliderMenu setUpMenuWithTitleArr:nil];    //初始化SliderBar
        
//    [sliderMenu setUpMenuWithTitleArr:[NSMutableArray arrayWithObjects:@"Diary", @"Activity", @"News", @"Me", nil]];    //初始化SliderBar
    
    sliderMenu.clickCloseBlock = ^(YW_MenuButton *button) {
        if ([button.titleLabel.text isEqualToString:self.currentTitle]) {
            YW_HomeViewController *homeVC = [[YW_HomeViewController alloc] init];
            [self setupViewController:homeVC];
        }
        [self clearNVCData:button.titleLabel.text];
    };
    
    __weak typeof(self) weakSelf = self;
    sliderMenu.clickItemBlock = ^(YW_MenuButton *button) {
        if ([button.titleLabel.text isEqualToString:@"Diary"]) {
            YW_NavigationController *diaryNVC = [YW_NaviSingleton shareInstance].diaryNVC;
            if (!diaryNVC) {   //第一次进入,创建新的diaryVC
                YW_DiaryViewController *diaryVC = [[YW_DiaryViewController alloc] init];
                diaryNVC = [[YW_NavigationController alloc] initWithRootViewController:diaryVC];
                [[YW_NaviSingleton shareInstance] setDiaryNVC:diaryNVC];
                [weakSelf setupViewController:diaryNVC];
            }else
            {
                NSLog(@"--%@", self.childViewControllers[0]);
                // 伪代码
                // 1、判断当前界面是哪个界面
                
                if ([self.childViewControllers[0] isKindOfClass:[YW_HomeViewController class]]){
//                判断 [YW_NaviSingleton shareInstance].diaryNVC 是哪个导航控制器
//                直接跳到 [YW_NaviSingleton shareInstance].diaryNVC
                    
                    [weakSelf setupViewController:diaryNVC];
                }else if ([self.childViewControllers[0] isKindOfClass:[YW_NavigationController class]])
                {
                    YW_NavigationController *nvc = self.childViewControllers[0];
                    if ([nvc.childViewControllers[0] isKindOfClass:[YW_DiaryViewController class]]) {
                        NSLog(@"--%@", nvc.childViewControllers[0]);
                        //判断最后一次访问的是chat还是contact
                        NSString *lastVCTitle = [YW_DiaryVCSingleton shareInstance].lastVCTitle;
                        if ([lastVCTitle isEqualToString:@"Chat"]) {
                            YW_NavigationController *chatNVC = [YW_DiaryVCSingleton shareInstance].chatVC;
                            [[YW_NaviSingleton shareInstance] setDiaryNVC:chatNVC];
                            [chatNVC popToViewController:chatNVC.topViewController animated:YES];
                            [weakSelf setupViewController:chatNVC];
                        }else if ([lastVCTitle isEqualToString:@"Contact"])
                        {
                            YW_NavigationController *contactNVC = [YW_DiaryVCSingleton shareInstance].chatVC;
                            [[YW_NaviSingleton shareInstance] setDiaryNVC:contactNVC];
                            [contactNVC popToViewController:contactNVC.topViewController animated:YES];
                            [weakSelf setupViewController:contactNVC];
                        }
                    }else  //否则就处在Diary的子功能菜单中,回到YW_DiaryViewController界面
                    {
                        YW_DiaryViewController *diaryVC = [[YW_DiaryViewController alloc] init];
                        diaryVC.rootVC = weakSelf;
                        diaryNVC = [[YW_NavigationController alloc] initWithRootViewController:diaryVC];
                        [[YW_NaviSingleton shareInstance] setDiaryNVC:diaryNVC];
                        [weakSelf setupViewController:diaryNVC];
                    }
                }
                
                //判断当前所在Diary功能的哪个界面
//                if ([diaryNVC.childViewControllers[0] isKindOfClass:[YW_DiaryViewController class]]) {
//                    NSString *lastVCTitle = [YW_DiaryVCSingleton shareInstance].lastVCTitle;
//                    
//                    NSLog(@"%s, line = %d, %@, %@", __func__, __LINE__, lastVCTitle, diaryNVC);
//                    if ([lastVCTitle isEqualToString:@"Chat"]) {
//                        YW_NavigationController *chatNVC = [YW_DiaryVCSingleton shareInstance].chatVC;
//                        [[YW_NaviSingleton shareInstance] setDiaryNVC:chatNVC];
//                        [chatNVC popToViewController:chatNVC.topViewController animated:YES];
//                        [weakSelf setupViewController:chatNVC];
//                    }else if ([lastVCTitle isEqualToString:@"Contact"])
//                    {
//                        YW_NavigationController *contactNVC = [YW_DiaryVCSingleton shareInstance].chatVC;
//                        [[YW_NaviSingleton shareInstance] setDiaryNVC:contactNVC];
//                        [contactNVC popToViewController:contactNVC.topViewController animated:YES];
//                        [weakSelf setupViewController:contactNVC];
//                    }else
//                    {
//                        [weakSelf setupViewController:diaryNVC];
//                    }
//                }else if ([diaryNVC.childViewControllers[0] isKindOfClass:[YWConversationListViewController class]]) {
//                    
//                    if ([self.currentTitle isEqualToString:@"home"]) {    //判断当前界面是否处在 Home界面
//                        self.currentTitle = @"lastDiaryVC";
//                        [weakSelf setupViewController:diaryNVC];
//                    }else
//                    {
//                        YW_DiaryViewController *diaryVC = [[YW_DiaryViewController alloc] init];
//                        diaryVC.rootVC = weakSelf;
//                        diaryNVC = [[YW_NavigationController alloc] initWithRootViewController:diaryVC];
//                        [[YW_NaviSingleton shareInstance] setDiaryNVC:diaryNVC];
//                        [weakSelf setupViewController:diaryNVC];
//                    }
//                }
            }
        }else if ([button.titleLabel.text isEqualToString:@"Activity"])
        {
            YW_ActivityViewController *activityVC = [[YW_ActivityViewController alloc] init];
            YW_NavigationController *nVC = [[YW_NavigationController alloc] initWithRootViewController:activityVC];
            
            [weakSelf setupViewController:nVC];
        }else if ([button.titleLabel.text isEqualToString:@"News"])
        {
            YW_NavigationController *nVC = [YW_NaviSingleton shareInstance].newsNVC;
            if (!nVC) {   //第一次进入,创建新的newsVC
                YW_NewsViewController *newsVC = [[YW_NewsViewController alloc] init];
                nVC = [[YW_NavigationController alloc] initWithRootViewController:newsVC];
                [[YW_NaviSingleton shareInstance] setNewsNVC:nVC];
            }
            NSInteger index = nVC.childViewControllers.count - 1;
            [nVC popToViewController:nVC.childViewControllers[index] animated:YES];
            
            [weakSelf setupViewController:nVC];
        }else if ([button.titleLabel.text isEqualToString:@"Me"])
        {
            YW_MeViewController *meVC = [[YW_MeViewController alloc] init];
            YW_NavigationController *nVC = [[YW_NavigationController alloc] initWithRootViewController:meVC];
            
            [weakSelf setupViewController:nVC];
        }
    };

    [menuView addSubview:sliderMenu];
    [menuView addSubview:mainBtn];
    
    self.sliderMenu = sliderMenu;
    
    [self.view addSubview:menuView];
}

-(void)mainClick:(UIButton *)button
{
    YW_HomeViewController *homeVc = [[YW_HomeViewController alloc] init];
    
    [self setupViewController:homeVc];
    
    [self.sliderMenu setCurrentTab:@"home"];
}

-(void)insertMenuButton:(NSString *)title
{
    self.currentTitle = title;
    
    if (!title || [title isEqualToString:@"home"]) {
        return;
    }
    
    BOOL isExitBtn = false;
    for (YW_MenuButton *button in self.sliderMenu.buttons) {
        if ([button.titleLabel.text isEqualToString:title]) {
            isExitBtn = YES;
            break;
        }
    }
    
    if (!isExitBtn) {
        [self.sliderMenu insertMenuWithTitle:title];
    }
    
    [self.sliderMenu setCurrentTab:title];
}

-(void)clearNVCData:(NSString *)title
{
    if ([title isEqualToString:@"Diary"]) {
        [[YW_NaviSingleton shareInstance] setDiaryNVC:nil];
    }else if ([title isEqualToString:@"Activity"]) {
        [[YW_NaviSingleton shareInstance] setDiaryNVC:nil];
    }else if ([title isEqualToString:@"News"]) {
        [[YW_NaviSingleton shareInstance] setNewsNVC:nil];
    }else if ([title isEqualToString:@"Me"]) {
        [[YW_NaviSingleton shareInstance] setDiaryNVC:nil];
    }
}

@end
