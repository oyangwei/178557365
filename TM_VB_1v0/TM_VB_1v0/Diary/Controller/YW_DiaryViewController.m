//
//  YW_DiaryViewController.m
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_DiaryViewController.h"
#import "MJCSegmentInterface.h"
#import "YW_MenuSliderBar.h"
#import "YW_NaviBarListViewController.h"

#define CurrentTitle @"TM_VB_1v0"

@interface YW_DiaryViewController () <MJCSlideSwitchViewDelegate, UIPopoverPresentationControllerDelegate>

/** 菜单栏按钮标题 */
@property(strong, nonatomic) NSMutableArray *menuTitleArr;

/** 弹出菜单栏 */
@property(strong, nonatomic) YW_NaviBarListViewController *listViewPopVC;

/** 搜索栏 */
@property(strong, nonatomic) UISearchBar *searchBar;

@end

@implementation YW_DiaryViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = CurrentTitle;
    
    self.automaticallyAdjustsScrollViewInsets = false;  //
    
    [self setupNavigationBar];  //设置导航栏
    
    [self setupMenuBar];  //初始化 MenuBar
    
    [self setUpSearBar];  //初始化搜索栏
    
    [self setUpTabBar];  //初始化标签栏
}

#pragma mark - 初始化 NavigationBar
- (void)setupNavigationBar
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 22)];
    [leftBtn setImage:[UIImage imageNamed:@"leftList"] forState:UIControlStateNormal];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 0)];
    [leftBtn addTarget:self action:@selector(showLeftList) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [rightBtn setImage:[UIImage imageNamed:@"rightList"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(showRightList) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftBarItem];
    
    UIBarButtonItem *rightBatItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightBatItem];
    
}

#pragma mark - 初始化 MenuBar
-(void)setupMenuBar
{
    _menuTitleArr = [NSMutableArray arrayWithObjects:@"选择", @"编辑", @"删除", @"标记", @"更多", @"更多", @"更多", nil];
    
    YW_MenuSliderBar *menuBar = [[YW_MenuSliderBar alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 44)];
    menuBar.maxShowNum = 4;
    [menuBar setUpMenuWithTitleArr:_menuTitleArr];
    [self.view addSubview:menuBar];
}

-(void)setUpSearBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 108, self.view.width, 44)];
    [self.view addSubview:self.searchBar];
}

- (void)setUpTabBar
{
    //标题数据数组
    NSArray *titlesArr = @[@"Chat",@"Life"];
    MJCSegmentInterface *lala = [[MJCSegmentInterface alloc]init];
    lala.delegate = self;
    lala.frame = CGRectMake(0,152,self.view.width, self.view.height - 152);
    lala.itemTextNormalColor = [UIColor redColor];
    lala.itemTextSelectedColor = [UIColor purpleColor];
    lala.isIndicatorFollow = YES;
    lala.itemTextFontSize = 13;
    [lala intoTitlesArray:titlesArr hostController:self];
    [self.view addSubview:lala];

    UIViewController *vc1 = [[UIViewController alloc]init];
    vc1.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100.0)/100.0 green:arc4random_uniform(100.0)/100.0 blue:arc4random_uniform(100.0)/100.0 alpha:1];
    UIViewController *vc2 = [[UIViewController alloc]init];
    vc2.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100.0)/100.0 green:arc4random_uniform(100.0)/100.0 blue:arc4random_uniform(100.0)/100.0 alpha:1];
    NSArray *vcarrr = @[vc1,vc2];
    [lala intoChildControllerArray:vcarrr];
    
}

- (void)mjc_ClickEvent:(MJCTabItem *)tabItem childViewController:(UIViewController *)childViewController segmentInterface:(MJCSegmentInterface *)segmentInterface;
{
    NSLog(@"%ld",tabItem.tag);
    NSLog(@"%@",childViewController);
    NSLog(@"%@",segmentInterface);
}

#pragma mark - 懒加载菜单标题栏
-(NSMutableArray *)menuTitleArr
{
    if (_menuTitleArr) {
        _menuTitleArr = [NSMutableArray array];
    }
    return _menuTitleArr;
}

#pragma mark - 显示左边栏
- (void)showLeftList
{
    NSArray *leftItems = [NSArray arrayWithObjects:@"Hide All", nil];
    
    CGFloat itemLineH = 1.5;
    
    self.listViewPopVC = [[YW_NaviBarListViewController alloc] init];
    self.listViewPopVC.titles = leftItems;
    self.listViewPopVC.labelLineH = itemLineH;
    
    //设置 VC 弹出方式
    self.listViewPopVC.modalPresentationStyle = UIModalPresentationPopover;
    //设置依附的按钮
    self.listViewPopVC.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;
    //可以指示小箭头颜色
    self.listViewPopVC.popoverPresentationController.backgroundColor = [UIColor whiteColor];
    
    //代理
    self.listViewPopVC.popoverPresentationController.delegate = self;
    [self presentViewController:self.listViewPopVC animated:YES completion:nil];
    
    self.listViewPopVC.titles = leftItems;
}

#pragma mark - 显示右边栏
- (void)showRightList
{
    NSMutableArray *rightItems = [NSMutableArray arrayWithObjects:@"Contacst", @"Things", nil];
    CGFloat itemLineH = 1.5;
    
    self.listViewPopVC = [[YW_NaviBarListViewController alloc] init];
    self.listViewPopVC.titles = rightItems;
    self.listViewPopVC.labelLineH = itemLineH;
    
    //设置 VC 弹出方式
    self.listViewPopVC.modalPresentationStyle = UIModalPresentationPopover;
    
    //设置依附的按钮
    self.listViewPopVC.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    //可以指示小箭头颜色
    self.listViewPopVC.popoverPresentationController.backgroundColor = [UIColor whiteColor];
    
    //代理
    self.listViewPopVC.popoverPresentationController.delegate = self;
    [self presentViewController:self.listViewPopVC animated:YES completion:nil];
    
    self.listViewPopVC.titles = rightItems;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;   //点击蒙版popover消失， 默认YES
}

#pragma mark - TouchBegan
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
}
@end
