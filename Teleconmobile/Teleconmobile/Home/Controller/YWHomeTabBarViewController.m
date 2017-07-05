//
//  YWHomeTabBarViewController.m
//  Teleconmobile
//
//  Created by YangWei on 17/6/29.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YWHomeTabBarViewController.h"
#import "YWNavigationViewController.h"
#import "YWContactsViewController.h"
#import "YWContigViewController.h"
#import "YWThingsViewController.h"
#import "YWMeViewController.h"
#import "UIImage+YWUIImage.h"
#import "YWConversationListViewController+UIViewControllerPreviewing.h"
#import "SPKitExample.h"

@interface YWHomeTabBarViewController ()

@end

@implementation YWHomeTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];

    YWConversationListViewController *conversationListController = [[SPKitExample sharedInstance].ywIMKit makeConversationListViewController];
    
    [[SPKitExample sharedInstance] exampleCustomizeConversationCellWithConversationListController:conversationListController];
    
    __weak __typeof(conversationListController) weakConversationListController = conversationListController;
    conversationListController.didSelectItemBlock = ^(YWConversation *aConversation)
    {
        [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithConversation:aConversation fromNavigationController:weakConversationListController.navigationController];
    };
    
    
    
    [self setupChildVC:conversationListController title:@"Message" image:@"message_1" selectImage:@"message_2"];
    [self setupChildVC:[[YWContactsViewController alloc] init] title:@"Contact" image:@"contact_1" selectImage:@"contact_2"];
    [self setupChildVC:[[YWContigViewController alloc] init] title:@"Contig" image:@"wifi_1" selectImage:@"wifi_2"];
    [self setupChildVC:[[YWThingsViewController alloc] init] title:@"Things" image:@"programme_2" selectImage:@"programme_2"];
    [self setupChildVC:[[YWMeViewController alloc] init] title:@"Me" image:@"me_1" selectImage:@"me_2"];
}

-(void)setupChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectedImage
{
    vc.title = title;
    
    vc.tabBarItem.image = [[UIImage reSizeImage:[UIImage imageNamed:image] toSize:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc.tabBarItem setSelectedImage:[[UIImage reSizeImage:[UIImage imageNamed:selectedImage] toSize:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100.0)/100.0 green:arc4random_uniform(100.0)/100.0 blue:arc4random_uniform(100.0)/100.0 alpha:1];
    YWNavigationViewController *nVC = [[YWNavigationViewController alloc] initWithRootViewController:vc];
    [self addChildViewController:nVC];
}

@end
