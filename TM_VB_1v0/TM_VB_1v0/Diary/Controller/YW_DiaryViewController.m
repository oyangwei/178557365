//
//  YW_DiaryViewController.m
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_DiaryViewController.h"
#import "YW_IconButton.h"
#import "YW_MenuSliderBar.h"
#import "YW_HomeViewController.h"
#import "YW_MenuButton.h"
#import "YW_MeViewController.h"
#import "YW_NewsViewController.h"
#import "YW_ActivityViewController.h"
#import "YW_NavigationController.h"
#import "SPKitExample.h"
#import "YW_ContactListViewController.h"
#import "YW_SubControllerMenuViewController.h"

#define ButtonViewLeftMargin 30      // 存放按钮容器距离左边间距
#define ButtonColumnMarginSpace 35         // 按钮列间距
#define ButtonRowMarginSpace 30         // 按钮行间距
#define ColumnNumber 3                  // 列数
#define IconButtonLabelHeight 25     // 图标按钮文字高度
#define BottomMenuViewHeight 49     // 底部菜单高度


static NSString *const currentTitle = @"Diary";

@interface YW_DiaryViewController () <YWMenuButtonDelegate>

/** UIView */
@property(strong, nonatomic) UIView *mainView;

/** UIWindows */
@property(strong, nonatomic) UIWindow *window;

/** UIView */
@property(strong, nonatomic) UIView *menuView;

@end

@implementation YW_DiaryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    [[YW_DiaryVCSingleton shareInstance] setLastVCTitle:@"Diary"];
    
    [[YW_NaviSingleton shareInstance] setDiaryNVC:(YW_NavigationController *)self.navigationController];  //记录当前控制器
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:ViewBgColor]];
    
    self.title = currentTitle;
    
    [self.rootVC insertMenuButton:currentTitle];  //插入底部菜单标签
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.height -= 64;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIcon" target:self action:@selector(showSubMenu)];
    
    [self setupContentView];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)setupContentView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ButtonViewLeftMargin, 20, self.view.width - 2 * ButtonViewLeftMargin, self.view.height - BottomMenuViewHeight - 104)];
    self.mainView = view;
    [self.view addSubview:view];
    
    NSArray *iconTitles = [NSArray arrayWithObjects:@"Chat", @"Contact", nil];
    NSArray *iconImages = [NSArray arrayWithObjects:@"chat", @"contact", nil];
    
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
        if (i == rowNumber - 1 && iconTitles.count % ColumnNumber != 0) {
            rowMaxCount = iconTitles.count % ColumnNumber;  //计算当前行存放的Button最大数量
        }
        
        for (int j = 0; j < rowMaxCount; j ++) {
            buttonX = buttonW * j + ButtonRowMarginSpace * j;
            
            YW_IconButton *button = [[YW_IconButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
            button.alpha = 0.7;
            [button setImage:[UIImage imageNamed:iconImages[i * ColumnNumber + j]] forState:UIControlStateNormal];
            [button setTitle:iconTitles[i * ColumnNumber + j] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:ViewTitleColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:button];
        }
    }
}

-(void)showSubMenu
{
    [YW_SliderMenuTool showFunctionMenuWithRootViewController:self withToViewController:[YW_SubControllerMenuViewController class]];
    
     NSLog(@"--%s, line = %d", __func__, __LINE__);
}

-(void)buttonClick:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"Chat"]) {
        
        YW_NavigationController *nVC = [YW_DiaryVCSingleton shareInstance].chatVC;
        if (!nVC) {   //第一次进入,创建新的chatVC
            YWConversationListViewController *conversationListController = [[SPKitExample sharedInstance].ywIMKit makeConversationListViewController];
            [[SPKitExample sharedInstance] exampleCustomizeConversationCellWithConversationListController:conversationListController];
            
            __weak __typeof(conversationListController) weakConversationListController = conversationListController;
            conversationListController.didSelectItemBlock = ^(YWConversation *aConversation) {
//                [[YW_NaviSingleton shareInstance] setDiaryNVC:(YW_NavigationController *)weakConversationListController.navigationController];   //进入Chat之后，记录一下]
                if ([aConversation isKindOfClass:[YWCustomConversation class]]) {
                    YWCustomConversation *customConversation = (YWCustomConversation *)aConversation;
                    [customConversation markConversationAsRead];
                    
                    if ([customConversation.conversationId isEqualToString:SPTribeSystemConversationID]) {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tribe" bundle:nil];
                        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SPTribeSystemConversationViewController"];
                        [weakConversationListController.navigationController pushViewController:controller animated:YES];
                    }
                    else if ([customConversation.conversationId isEqualToString:kSPCustomConversationIdForFAQ]) {
                        YWWebViewController *controller = [YWWebViewController makeControllerWithUrlString:@"https://bbs.aliyun.com/searcher.php?step=2&method=AND&type=thread&verify=d26d3c6e63c0b37d&sch_area=1&fid=285&sch_time=all&keyword=汇总" andImkit:[SPKitExample sharedInstance].ywIMKit];
                        [controller setHidesBottomBarWhenPushed:YES];
                        [controller setTitle:@"云旺iOS精华问题"];
                        [weakConversationListController.navigationController pushViewController:controller animated:YES];
                    }
                    else {
                        YWWebViewController *controller = [YWWebViewController makeControllerWithUrlString:@"https://im.taobao.com/" andImkit:[SPKitExample sharedInstance].ywIMKit];
                        [controller setHidesBottomBarWhenPushed:YES];
                        [controller setTitle:@"功能介绍"];
                        [weakConversationListController.navigationController pushViewController:controller animated:YES];
                    }
                }
                else {
                    [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithConversation:aConversation
                                                                                fromNavigationController:weakConversationListController.navigationController];
                }
            };
            
            conversationListController.didDeleteItemBlock = ^ (YWConversation *aConversation) {
                if ([aConversation.conversationId isEqualToString:SPTribeSystemConversationID]) {
                    [[[SPKitExample sharedInstance].ywIMKit.IMCore getConversationService] removeConversationByConversationId:[SPKitExample sharedInstance].tribeSystemConversation.conversationId error:NULL];
                }
            };
            
            [conversationListController setViewDidAppearBlock:^(BOOL aAnimated) {
                [[YW_DiaryVCSingleton shareInstance] setLastVCTitle:@"Chat"];
                [[YW_NaviSingleton shareInstance] setDiaryNVC:(YW_NavigationController *)weakConversationListController.navigationController];   //进入Chat之后，记录一下]
                [[YW_DiaryVCSingleton shareInstance] setChatVC:(YW_NavigationController *)weakConversationListController.navigationController];   //进入到chat之后，记录一下
//                weakConversationListController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIcon" target:weakConversationListController action:@selector(showSubMenu)];
            }];
        
            YW_NavigationController *chatNVC = [[YW_NavigationController alloc] initWithRootViewController:conversationListController];
            [self.rootVC setupViewController:chatNVC];
        }else  //第二次进入，直接进入到上一次离开的界面
        {
            [nVC popToViewController:nVC.topViewController animated:YES];
            [self.rootVC setupViewController:nVC];
        }
    }
    else if([button.titleLabel.text isEqualToString:@"Contact"])
    {
        YW_NavigationController *contactNVC = [YW_DiaryVCSingleton shareInstance].contactVC;
        if (!contactNVC) {  //第一次进入
            YW_ContactListViewController *contactVC = [[YW_ContactListViewController alloc] init];
            contactNVC = [[YW_NavigationController alloc] initWithRootViewController:contactVC];
        }
        else
        {
            [contactNVC popToViewController:contactNVC.topViewController animated:YES];
        }
        [self.rootVC setupViewController:contactNVC];
    }
}

-(void)mainClick:(UIButton *)button
{
    YW_HomeViewController *homeVC = [[YW_HomeViewController alloc] init];
    self.view.window.rootViewController = homeVC;
}

@end
