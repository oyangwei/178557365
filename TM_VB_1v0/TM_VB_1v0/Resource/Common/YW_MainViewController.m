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
#import "YW_MainMenuViewController.h"
#import "YW_SuspendUIButton.h"

#define BottomMenuViewHeight 49     // 底部菜单高度

@interface YW_MainViewController () <UIDragButtonDelegate>

/** 菜单栏 */
@property(strong, nonatomic) YW_MenuSliderBar *sliderMenu;

/** window */
@property (nonatomic, strong) UIWindow *window;

/** 悬浮按钮 */
@property (nonatomic, strong) YW_SuspendUIButton *suspendBtn;

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
    
    [self performSelector:@selector(creatSuspendBtn) withObject:nil afterDelay:1.0];
//    if () {
//        <#statements#>
//    }
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
        if ([button.titleLabel.text isEqualToString:[YW_NaviSingleton shareInstance].mainTitle]) {   //判断当前是否为Diary、Activity...
            YW_HomeViewController *homeVC = [[YW_HomeViewController alloc] init];
            [self setupViewController:homeVC];
        }
        [self clearNVCData:button.titleLabel.text];
    };
    
    __weak typeof(self) weakSelf = self;
    sliderMenu.clickItemBlock = ^(YW_MenuButton *button) {
        weakSelf.menuView.backgroundColor = [UIColor colorWithHexString:ThemeColor];
        if ([button.titleLabel.text isEqualToString:@"Diary"]) {
            [[YW_NaviSingleton shareInstance] setMainTitle:@"Diary"];
            YW_NavigationController *diaryNVC = [YW_NaviSingleton shareInstance].diaryNVC;
            if (!diaryNVC) {   //第一次进入,创建新的diaryVC
                YW_DiaryViewController *diaryVC = [[YW_DiaryViewController alloc] init];
                diaryNVC = [[YW_NavigationController alloc] initWithRootViewController:diaryVC];
                [[YW_NaviSingleton shareInstance] setDiaryNVC:diaryNVC];
                [weakSelf setupViewController:diaryNVC];
            }else
            {
                // 1、判断当前界面是哪个界面
                
                if ([self.childViewControllers[0] isKindOfClass:[YW_HomeViewController class]]){
//                判断 [YW_NaviSingleton shareInstance].diaryNVC 是哪个导航控制器
//                直接跳到 [YW_NaviSingleton shareInstance].diaryNVC
                    
                    [weakSelf setupViewController:diaryNVC];
                }else if ([self.childViewControllers[0] isKindOfClass:[YW_NavigationController class]])
                {
                    YW_NavigationController *nvc = self.childViewControllers[0];
                    if ([nvc.childViewControllers[0] isKindOfClass:[YW_DiaryViewController class]]) {
                        //判断最后一次访问的是chat还是contact
                        NSString *lastVCTitle = [YW_DiaryVCSingleton shareInstance].lastVCTitle;
                        if ([lastVCTitle isEqualToString:@"Chat"]) {
                            YW_NavigationController *chatNVC = [YW_DiaryVCSingleton shareInstance].chatVC;
                            [[YW_NaviSingleton shareInstance] setDiaryNVC:chatNVC];
                            [chatNVC popToViewController:chatNVC.topViewController animated:YES];
                            [weakSelf setupViewController:chatNVC];
                        }else if ([lastVCTitle isEqualToString:@"Contact"])
                        {
                            YW_NavigationController *contactNVC = [YW_DiaryVCSingleton shareInstance].contactVC;
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
            }
        }else if ([button.titleLabel.text isEqualToString:@"Activity"])
        {
            [[YW_NaviSingleton shareInstance] setMainTitle:@"Activity"];
            YW_NavigationController *activityNVC = [YW_NaviSingleton shareInstance].activityNVC;
            if (!activityNVC) {   //第一次进入,创建新的activityVC
                YW_ActivityViewController *activityVC = [[YW_ActivityViewController alloc] init];
                activityNVC = [[YW_NavigationController alloc] initWithRootViewController:activityVC];
                [[YW_NaviSingleton shareInstance] setActivityNVC:activityNVC];
                [weakSelf setupViewController:activityNVC];
            }else
            {
                // 1、判断当前界面是哪个界面
                
                if ([self.childViewControllers[0] isKindOfClass:[YW_HomeViewController class]]){
                    // 判断 [YW_NaviSingleton shareInstance].activityNVC 是哪个导航控制器
                    // 直接跳到 [YW_NaviSingleton shareInstance].activityNVC
                    
                    [weakSelf setupViewController:activityNVC];
                }else if ([self.childViewControllers[0] isKindOfClass:[YW_NavigationController class]])
                {
                    YW_NavigationController *nvc = self.childViewControllers[0];
                    if ([nvc.childViewControllers[0] isKindOfClass:[YW_ActivityViewController class]]) {
                        NSLog(@"--%@", nvc.childViewControllers[0]);
                        //判断最后一次访问的是chat还是contact
                        NSString *lastVCTitle = [YW_ActivityVCSingleton shareInstance].lastVCTitle;
                        if ([lastVCTitle isEqualToString:@"Shares"]) {
                            YW_NavigationController *shareNVC = [YW_ActivityVCSingleton shareInstance].shareVC;
                            [[YW_NaviSingleton shareInstance] setActivityNVC:shareNVC];
                            [shareNVC popToViewController:shareNVC.topViewController animated:YES];
                            [weakSelf setupViewController:shareNVC];
                        }else if ([lastVCTitle isEqualToString:@"Things"])
                        {
                            YW_NavigationController *thingsNVC = [YW_ActivityVCSingleton shareInstance].thingsVC;
                            [[YW_NaviSingleton shareInstance] setActivityNVC:thingsNVC];
                            [thingsNVC popToViewController:thingsNVC.topViewController animated:YES];
                            [weakSelf setupViewController:thingsNVC];
                        }
                    }else  //否则就处在Activity的子功能菜单中,回到YW_ActivityViewController界面
                    {
                        YW_ActivityViewController *activityVC = [[YW_ActivityViewController alloc] init];
                        activityVC.rootVC = weakSelf;
                        activityNVC = [[YW_NavigationController alloc] initWithRootViewController:activityVC];
                        [[YW_NaviSingleton shareInstance] setActivityNVC:activityNVC];
                        [weakSelf setupViewController:activityNVC];
                    }
                }
            }
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
    self.menuView = menuView;
    
    [self.view addSubview:menuView];
}

-(void)mainClick:(UIButton *)button
{
    if ([[YW_NaviSingleton shareInstance].mainTitle isEqualToString:@"home"]) {
        [YW_SliderMenuTool showMenuWithRootViewController:self withToViewController:[YW_MainMenuViewController class]];
    }else
    {
        self.menuView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [self.sliderMenu setCurrentTab:@"home"];
        [[YW_NaviSingleton shareInstance] setMainTitle:@"home"];
        YW_HomeViewController *homeVc = [[YW_HomeViewController alloc] init];
        [self setupViewController:homeVc];
    }
}

-(void)insertMenuButton:(NSString *)title
{
    if (!title || [title isEqualToString:@"home"]) {
        return;
    }
    
    if (![title isEqualToString:@"Diary"] && ![title isEqualToString:@"Activity"] && ![title isEqualToString:@"News"] && ![title isEqualToString:@"Me"]) {
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
        [[YW_DiaryVCSingleton shareInstance] setChatVC:nil];
        [[YW_DiaryVCSingleton shareInstance] setContactVC:nil];
        [[YW_DiaryVCSingleton shareInstance] setLastVCTitle:nil];
    }else if ([title isEqualToString:@"Activity"]) {
        [[YW_NaviSingleton shareInstance] setActivityNVC:nil];
        [[YW_ActivityVCSingleton shareInstance] setThingsVC:nil];
        [[YW_ActivityVCSingleton shareInstance] setShareVC:nil];
        [[YW_ActivityVCSingleton shareInstance] setHotListVC:nil];
        [[YW_ActivityVCSingleton shareInstance] setActiveVC:nil];
        [[YW_ActivityVCSingleton shareInstance] setLastVCTitle:nil];
    }else if ([title isEqualToString:@"News"]) {
        [[YW_NaviSingleton shareInstance] setNewsNVC:nil];
    }else if ([title isEqualToString:@"Me"]) {
        [[YW_NaviSingleton shareInstance] setDiaryNVC:nil];
    }
}

#pragma mark - 创建悬浮按钮
-(void)creatSuspendBtn{
    //悬浮按钮
    _suspendBtn = [[YW_SuspendUIButton alloc] initWithFrame:CGRectMake(0,0, 80, 80)];
//    _suspendBtn.btnDelegate = self;
    
    _suspendBtn.rootView = self.view.superview;
    
    //悬浮按钮所处的顶端UIWindow
    _window = [[UIWindow alloc] initWithFrame:CGRectMake(ScreenWitdh - 90, ScreenHeight - 90, 80, 80)];
    //使得新建window在最顶端
    _window.windowLevel = UIWindowLevelAlert;
    _window.backgroundColor = [UIColor clearColor];
    _window.hidden = NO;
    _window.layer.cornerRadius = 40;
    _window.layer.masksToBounds = YES;
    [_window addSubview:_suspendBtn];
    //显示window
//    [_window makeKeyAndVisible];
}


-(void)dragButtonClicked:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.menuView.frame;
        frame.size.height = 0;
        self.menuView.frame = frame;
    }];
}

@end
