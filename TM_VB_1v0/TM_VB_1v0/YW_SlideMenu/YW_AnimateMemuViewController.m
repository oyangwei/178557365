//
//  YW_MemuViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/16.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_MemuViewController.h"
#import "YW_SliderMenuTool.h"
#import "YW_ActivityViewController.h"

static CGFloat const animationTime = 0.4;

@interface YW_MemuViewController ()

/** Backgroud View */
@property(strong, nonatomic) UIView *bgView;

/** MenuVC */
@property(strong, nonatomic) UIViewController *menuVC;

/** hasShow */
@property(assign, nonatomic) BOOL hasShow;

@end

@implementation YW_MemuViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //第一次进来，隐藏状态栏
    if (!self.hasShow) {
        self.hasShow = YES;
        self.hideStatusBar = YES;
        [UIView animateWithDuration:animationTime animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
            self.rootViewController.navigationController.navigationBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        }];
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self showMenu];
    }
}

//控制状态栏
-(BOOL)prefersStatusBarHidden
{
    return self.hideStatusBar;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    // 半透明遮罩
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.frame = [UIScreen mainScreen].bounds;
    bgView.alpha = 0;
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu)];
    [bgView addGestureRecognizer:tapGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    // 添加控制器
    UIViewController *menuVC = [[UIViewController alloc] init];
    menuVC.view.backgroundColor = [UIColor redColor];
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 50;
    if ([UIScreen mainScreen].bounds.size.width > 375) {
        width -= 50;
    } else if ([UIScreen mainScreen].bounds.size.width > 320) {
        width = width - 25;
    }
    menuVC.view.frame = CGRectMake(-width, 0, width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:menuVC.view];
    [self addChildViewController:menuVC];
    self.menuVC = menuVC;
}

-(void)showMenu
{
    self.view.userInteractionEnabled = NO;
    
    //根据当前x，计算显示时间
    CGFloat time = fabs(self.menuVC.view.frame.origin.x / self.menuVC.view.frame.size.width) * animationTime;
    [UIView animateWithDuration:time animations:^{
        self.menuVC.view.frame= CGRectMake(0, 0, self.menuVC.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        self.bgView.alpha = 0.5;
    }completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
}

-(void)closeMenu
{
    self.view.userInteractionEnabled = YES;
    
    //根据当前x，计算隐藏时间
    CGFloat time = (1 - fabs(self.menuVC.view.frame.origin.x / self.menuVC.view.frame.size.width)) * animationTime;
    [UIView animateWithDuration:time animations:^{
        self.menuVC.view.frame = CGRectMake(-self.menuVC.view.frame.size.width, 0, self.menuVC.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        self.bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hideStatusBar = NO;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            [UIView animateWithDuration:animationTime animations:^{
                [self setNeedsFocusUpdate];
            }];
        }
        
        [YW_SliderMenuTool hide];
    }];
}

-(void)moveViewWithGesture:(UIPanGestureRecognizer *)panGestureRecognizer
{
    static CGFloat startX;
    static CGFloat endX;
    static CGFloat durationX;
    CGPoint touchPoint = [panGestureRecognizer locationInView:[[UIApplication sharedApplication] keyWindow]];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        startX = touchPoint.x;
        endX = touchPoint.x;
    }
    
    //手势改变
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat currentX = touchPoint.x;
        durationX = currentX - endX;
        endX = currentX;
        CGFloat menuVC_X = durationX + self.menuVC.view.frame.origin.x;
        //如果控制器的x小于宽度直接返回
        if (menuVC_X <= -self.menuVC.view.frame.size.width) {
            menuVC_X = -self.menuVC.view.frame.size.width;
        }
        
        //如果控制器的x大于0直接返回
        if (menuVC_X >= 0) {
            menuVC_X = 0;
        }
        
        //计算bgView的透明度
        self.bgView.alpha = (1 + menuVC_X / self.menuVC.view.frame.size.width) * 0.5;
        //设置左边控制器的frame
        [self.menuVC.view setFrame:CGRectMake(menuVC_X, 0, self.menuVC.view.frame.size.width, self.menuVC.view.frame.size.height)];
        
    }
    
    // 手势结束
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // 结束为止超时屏幕一半
        if (self.menuVC.view.frame.origin.x > - self.menuVC.view.frame.size.width + [UIScreen mainScreen].bounds.size.width / 2) {
            [self showMenu];
        } else {
            [self closeMenu];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
