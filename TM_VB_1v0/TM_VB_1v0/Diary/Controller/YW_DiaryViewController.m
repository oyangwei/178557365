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
#import "SPUtil.h"
#import "SPKitExample.h"
#import "MJCCommonTools.h"
#import "MJCTitlesView.h"

#define BottomTabBarHeight self.tabBar.frame.size.height

#define CurrentTitle @"TM_VB_1v0"
#define MenuBarHeight 44
#define SearchBarHeight 30
#define TabBarHeight 30
#define BarSpace 5
#define MaskWidth 20

@interface YW_DiaryViewController () <MJCSlideSwitchViewDelegate, UIPopoverPresentationControllerDelegate, UIScrollViewDelegate, UISearchBarDelegate, UITextFieldDelegate>

/** 菜单栏按钮标题 */
@property(strong, nonatomic) NSMutableArray *menuTitleArr;

/** 弹出菜单栏 */
@property(strong, nonatomic) YW_NaviBarListViewController *listViewPopVC;

/** MenuBar */
@property(strong, nonatomic) YW_MenuSliderBar *menuBar;

/** 菜单栏左边蒙版 */
@property(strong, nonatomic) UIImageView *menuLeftMask;
/** 菜单栏右边蒙版 */
@property(strong, nonatomic) UIImageView *menuRightMask;

/** 搜索栏 */
@property(strong, nonatomic) UISearchBar *searchBar;

/** 标签栏 */
@property(strong, nonatomic) MJCSegmentInterface *tabBar;
/** 标签栏左边蒙版 */
@property(strong, nonatomic) UIImageView *tabLeftMask;
/** 标签栏右边蒙版 */
@property(strong, nonatomic) UIImageView *tabRightMask;

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

#pragma mark - 初始化 MenuBar, SearchBar, TabBar
-(void)setupMenuBar
{
    _menuTitleArr = [NSMutableArray arrayWithObjects:@"选择", @"编辑", @"删除", @"标记", @"更多", @"更多", @"更多", nil];
    
    YW_MenuSliderBar *menuBar = [[YW_MenuSliderBar alloc] initWithFrame:CGRectMake(0, 64, self.view.width, MenuBarHeight)];
    menuBar.maxShowNum = 4;
    [menuBar setUpMenuWithTitleArr:_menuTitleArr];

    self.menuBar = menuBar;
    self.menuBar.delegate = self;
    [self.view addSubview:menuBar];
    
    UIImageView *menuLeftMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 20, MenuBarHeight)];
    menuLeftMask.backgroundColor = [UIColor whiteColor];
    menuLeftMask.layer.shadowOffset = CGSizeMake(3, 0);
    menuLeftMask.layer.shadowColor = [UIColor orangeColor].CGColor;
    menuLeftMask.layer.shadowOpacity = 1.0;
    menuLeftMask.layer.shadowRadius = 3;
    menuLeftMask.alpha = 0.6;
    
    UIImageView *menuRightMask = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - 20, 64, 20, MenuBarHeight)];
    [menuRightMask setImage:[UIImage imageNamed:@"right_more"]];
    menuRightMask.backgroundColor = [UIColor whiteColor];
    menuRightMask.layer.shadowOffset = CGSizeMake(-3, 0);
    menuRightMask.layer.shadowColor = [UIColor orangeColor].CGColor;
    menuRightMask.layer.shadowOpacity = 1.0;
    menuRightMask.layer.shadowRadius = 3;
    menuRightMask.alpha = 0.6;
    
    self.menuLeftMask = menuLeftMask;
    self.menuRightMask = menuRightMask;
    [self.view addSubview:menuLeftMask];
    [self.view addSubview:menuRightMask];
    
    [menuLeftMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.top.equalTo(menuBar.mas_top);
        make.width.mas_equalTo(MaskWidth);
        make.height.mas_equalTo(MenuBarHeight);
    }];
    
    [menuRightMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_trailing);
        make.width.mas_equalTo(MaskWidth);
        make.top.equalTo(menuBar.mas_top);
        make.height.mas_equalTo(MenuBarHeight);
    }];
}

-(void)setUpSearBar
{
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.layer.borderWidth = 1.0;
    self.searchBar.layer.borderColor = [UIColor grayColor].CGColor;
    self.searchBar.layer.cornerRadius = 10;
    
    [self.view addSubview:self.searchBar];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.menuLeftMask.mas_trailing);
        make.trailing.equalTo(self.menuRightMask.mas_leading);
        make.top.equalTo(self.menuBar.mas_bottom).offset(BarSpace);
        make.height.mas_equalTo(SearchBarHeight);
    }];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.tabBar setCurrentSelectedItem:3];
    [self.searchBar resignFirstResponder];
}


- (void)setUpTabBar
{
    //标题数据数组
    NSArray *titlesArr = @[@"Contact",@"Chat",@"Life", @"Search"];
    MJCSegmentInterface *lala = [[MJCSegmentInterface alloc]init];
    lala.delegate = self;
    
    lala.titlesViewFrame = CGRectMake(0, 0, self.view.width, TabBarHeight);
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
    
    UIViewController *vc3 = [[UIViewController alloc]init];
    vc3.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100.0)/100.0 green:arc4random_uniform(100.0)/100.0 blue:arc4random_uniform(100.0)/100.0 alpha:1];
    
    UIViewController *vc4 = [[UIViewController alloc]init];
    vc4.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100.0)/100.0 green:arc4random_uniform(100.0)/100.0 blue:arc4random_uniform(100.0)/100.0 alpha:1];
    
    NSArray *vcarrr = @[vc1,vc2,vc3,vc4];
    [lala intoChildControllerArray:vcarrr];
    
    lala.defaultItemNumber = 1;
    lala.defaultShowItemCount = 2;
    
    self.tabBar = lala;
    
    UIImageView *tabLeftMask = [[UIImageView alloc] init];
    [tabLeftMask setImage:[UIImage imageNamed:@"left_more"]];
    tabLeftMask.backgroundColor = [UIColor whiteColor];
    tabLeftMask.layer.shadowOffset = CGSizeMake(3, 0);
    tabLeftMask.layer.shadowColor = [UIColor orangeColor].CGColor;
    tabLeftMask.layer.shadowOpacity = 1.0;
    tabLeftMask.layer.shadowRadius = 3;
    tabLeftMask.alpha = 0.6;
    
    UIImageView *tabRightMask = [[UIImageView alloc] init];
    [tabRightMask setImage:[UIImage imageNamed:@"right_more"]];
    tabRightMask.backgroundColor = [UIColor whiteColor];
    tabRightMask.layer.shadowOffset = CGSizeMake(-3, 0);
    tabRightMask.layer.shadowColor = [UIColor orangeColor].CGColor;
    tabRightMask.layer.shadowOpacity = 1.0;
    tabRightMask.layer.shadowRadius = 3;
    tabRightMask.alpha = 0.6;
    
    self.tabLeftMask = tabLeftMask;
    self.tabRightMask = tabRightMask;
    [self.view addSubview:tabLeftMask];
    [self.view addSubview:tabRightMask];
    
    [lala mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(self.searchBar.mas_bottom).offset(BarSpace);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    
    [tabLeftMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.top.equalTo(lala.mas_top);
        make.width.mas_equalTo(MaskWidth);
        make.height.mas_equalTo(TabBarHeight);
    }];
    
    [tabRightMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_trailing);
        make.width.mas_equalTo(MaskWidth);
        make.top.equalTo(lala.mas_top);
        make.height.mas_equalTo(TabBarHeight);
    }];
    
}

- (void)mjc_ClickEvent:(MJCTabItem *)tabItem childViewController:(UIViewController *)childViewController segmentInterface:(MJCSegmentInterface *)segmentInterface;
{
    NSLog(@"%ld",tabItem.tag);
    NSLog(@"%@",childViewController);
    NSLog(@"%@",segmentInterface);
}

- (void)title_scrollView:(UIScrollView *)scrollView
{
    CGPoint tabBarOffset = scrollView.contentOffset;
    
//    self.tabLeftMask.backgroundColor = tabBarOffset.x > 0 ?[UIColor redColor]:[UIColor whiteColor];
    [self.tabLeftMask setImage:tabBarOffset.x > 0?[UIImage imageNamed:@"left_more"]:NULL];
    
//    self.tabRightMask.backgroundColor = tabBarOffset.x < scrollView.contentSize.width - scrollView.width ?[UIColor redColor]:[UIColor whiteColor];
    [self.tabRightMask setImage:tabBarOffset.x < scrollView.contentSize.width - scrollView.width ?[UIImage imageNamed:@"right_more"]:NULL];
}

#pragma mark - 懒加载菜单标题栏
-(NSMutableArray *)menuTitleArr
{
    if (_menuTitleArr) {
        _menuTitleArr = [NSMutableArray array];
    }
    return _menuTitleArr;
}

#pragma mark - NavigationBar 左右按钮事件
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView class] == [YW_MenuSliderBar class]) {
        CGPoint menuBarOffset = scrollView.contentOffset;
        
//        self.menuLeftMask.backgroundColor = menuBarOffset.x > 0 ?[UIColor redColor]:[UIColor whiteColor];
        [self.menuLeftMask setImage:menuBarOffset.x > 0?[UIImage imageNamed:@"left_more"]:NULL];
        
//        self.menuRightMask.backgroundColor = menuBarOffset.x < scrollView.contentSize.width - scrollView.width ?[UIColor redColor]:[UIColor whiteColor];
        [self.menuRightMask setImage:menuBarOffset.x < scrollView.contentSize.width - scrollView.width ?[UIImage imageNamed:@"right_more"]:NULL];
    }

}

#pragma mark - TouchBegan
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
}
@end
