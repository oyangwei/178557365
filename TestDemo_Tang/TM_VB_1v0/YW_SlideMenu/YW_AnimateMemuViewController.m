//
//  YW_AnimateMemuViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/16.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_AnimateMemuViewController.h"
#import "YW_SliderMenuTool.h"
#import "YW_MainMenuViewController.h"

static CGFloat const animationTime = 0.4;

@interface YW_AnimateMemuViewController ()

/** Backgroud View */
@property(strong, nonatomic) UIView *bgView;

/** MenuVC */
@property(strong, nonatomic) UIViewController *menuVC;

/** hasShow */
@property(assign, nonatomic) BOOL hasShow;

@end

@implementation YW_AnimateMemuViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //第一次进来，隐藏状态栏
    if (!self.hasShow) {
        self.hasShow = YES;
//        self.hideStatusBar = YES;
//        [UIView animateWithDuration:animationTime animations:^{
//            [self setNeedsStatusBarAppearanceUpdate];
//            self.rootViewController.navigationController.navigationBar.frame = CGRectMake(0, 0, ScreenWitdh, 64);
//        }];
        
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
    
    UIPanGestureRecognizer *leftPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithLeftGesture:)];
    
    UIPanGestureRecognizer *rightPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithRightGesture:)];
    
    // 添加控制器
    if (self.destClass == nil) return;
    
    UIViewController *menuVC = [[self.destClass alloc] init];
    CGFloat width = ScreenWitdh - 50;
    if (ScreenWitdh > 375) {
        width -= 50;
    } else if (ScreenWitdh > 320) {
        width = width - 25;
    }
    
    if (self.showMenuStyle == YW_ShowMenuFromLeft) {
        [self.view addGestureRecognizer:leftPanGestureRecognizer];
        menuVC.view.frame = CGRectMake( -width, 0, width, ScreenHeight);
    }else{
        [self.view addGestureRecognizer:rightPanGestureRecognizer];
        menuVC.view.frame = CGRectMake( ScreenWitdh, 0, width, ScreenHeight);
    }
    
    [self.view addSubview:menuVC.view];
    [self addChildViewController:menuVC];
    self.menuVC = menuVC;
}

-(void)showMenu
{
    self.view.userInteractionEnabled = NO;
    switch (self.showMenuStyle) {
        case YW_ShowMenuFromLeft:
        {
            //根据当前x，计算显示时间
            CGFloat time = fabs(self.menuVC.view.frame.origin.x / self.menuVC.view.frame.size.width) * animationTime;
            [UIView animateWithDuration:time animations:^{
                self.menuVC.view.frame= CGRectMake(0, 0, self.menuVC.view.frame.size.width, ScreenHeight);
                self.bgView.alpha = 0.5;
            }completion:^(BOOL finished) {
                self.view.userInteractionEnabled = YES;
            }];
            break;
        }
        case YW_ShowMenuFromRight:
        {
            //根据当前x，计算显示时间
            CGFloat time = fabs(1 - (ScreenWitdh - self.menuVC.view.frame.origin.x) / self.menuVC.view.frame.size.width) * animationTime;
            [UIView animateWithDuration:time animations:^{
                self.menuVC.view.frame= CGRectMake(ScreenWitdh - self.menuVC.view.frame.size.width, 0, self.menuVC.view.frame.size.width, ScreenHeight);
                self.bgView.alpha = 0.5;
            }completion:^(BOOL finished) {
                self.view.userInteractionEnabled = YES;
            }];
            break;
        }
        default:
            self.view.userInteractionEnabled = YES;
            break;
    }
}

-(void)closeMenu
{
    self.view.userInteractionEnabled = YES;
    
    switch (self.showMenuStyle) {
        case YW_ShowMenuFromLeft:
        {
            //根据当前x，计算隐藏时间
            CGFloat time = (1 - fabs(self.menuVC.view.frame.origin.x / self.menuVC.view.frame.size.width)) * animationTime;
            [UIView animateWithDuration:time animations:^{
                self.menuVC.view.frame = CGRectMake(-self.menuVC.view.frame.size.width, 0, self.menuVC.view.frame.size.width, ScreenHeight);
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
            break;
        }
        case YW_ShowMenuFromRight:
        {
            //根据当前x，计算隐藏时间
            CGFloat time = fabs((ScreenWitdh - self.menuVC.view.x) / self.menuVC.view.frame.size.width) * animationTime;
            [UIView animateWithDuration:time animations:^{
                self.menuVC.view.frame = CGRectMake(ScreenWitdh, 0, self.menuVC.view.frame.size.width, ScreenHeight);
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
            break;
        }
        default:
            break;
    }
}

-(void)moveViewWithLeftGesture:(UIPanGestureRecognizer *)panGestureRecognizer
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
        if (self.menuVC.view.frame.origin.x > - self.menuVC.view.frame.size.width + ScreenWitdh / 2) {
            [self showMenu];
        } else {
            [self closeMenu];
        }
    }
}

- (void)moveViewWithRightGesture:(UIPanGestureRecognizer *)panGestureRecognizer
{
    static CGFloat startX;
    static CGFloat endX;
    CGPoint touchPoint = [panGestureRecognizer locationInView:[[UIApplication sharedApplication] keyWindow]];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        startX = touchPoint.x;
        endX = touchPoint.x;
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat menuVC_X = touchPoint.x;
        //如果控制器的x大于屏幕宽度，则直接返回
        if (menuVC_X >= ScreenWitdh) {
            menuVC_X = ScreenWitdh;
        }
        if (menuVC_X <= ScreenWitdh - self.menuVC.view.frame.size.width) {
            menuVC_X = ScreenWitdh - self.menuVC.view.frame.size.width;
        }
        
        //计算bgView的透明度
        self.bgView.alpha =  ((ScreenWitdh - menuVC_X) / self.menuVC.view.frame.size.width) * 0.5;
        
        [self.menuVC.view setFrame:CGRectMake(menuVC_X, 0, self.menuVC.view.frame.size.width, self.menuVC.view.frame.size.height)];
    }
    
    // 手势结束
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // 结束为止超时屏幕一半
        if (self.menuVC.view.frame.origin.x < ScreenWitdh / 2) {
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
