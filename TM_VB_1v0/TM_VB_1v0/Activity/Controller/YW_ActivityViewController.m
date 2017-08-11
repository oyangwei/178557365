//
//  YW_ActivityViewController.m
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_ActivityViewController.h"

#import "MJCSegmentInterface.h"
#import "YW_MenuSliderBar.h"
#import "YW_NaviBarListViewController.h"
#import "SPUtil.h"
#import "SPKitExample.h"
#import "MJCCommonTools.h"
#import "MJCTitlesView.h"
#import "YW_HistoryTableView.h"
#import "YW_ActivityRecentViewController.h"

#define BottomTabBarHeight 49
#define EditBtnHeight 44

#define CurrentTitle @"<<     Acitivity     >>"

@interface YW_ActivityViewController () <MJCSlideSwitchViewDelegate, UIPopoverPresentationControllerDelegate, UIScrollViewDelegate, UISearchBarDelegate, UITextFieldDelegate>
{
    CGFloat keyBoardHeight; // 键盘高度
    int currentChildIndex;  // 当前标签视图序号
    UIControl *coverView;   // 蒙版
    NSString *pathStr;   //历史记录文件路径
    YW_HistoryTableView *historyTableView; // 历史记录
}

/** 菜单栏按钮标题 */
@property(strong, nonatomic) NSDictionary *menuTabArr;

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

/** 搜索栏附着视图 */
@property(strong, nonatomic) UIView *inputAccessoryView;

/** 标签栏 */
@property(strong, nonatomic) MJCSegmentInterface *tabBar;
/** 标签栏左边蒙版 */
@property(strong, nonatomic) UIImageView *tabLeftMask;
/** 标签栏右边蒙版 */
@property(strong, nonatomic) UIImageView *tabRightMask;
/** 标签子控制器标题 */
@property(strong, nonatomic) NSArray *tabTitleArr;

/** 编辑确认按钮 */
@property(strong, nonatomic) UIButton *deleteBtn;

/** 取消确认按钮 */
@property(strong, nonatomic) UIButton *cancleBtn;

/** 历史记录 */
@property(strong, nonatomic) NSMutableArray *historyRecord;

@property(strong, nonatomic) YW_ActivityRecentViewController *activityRecentVC;

@end

@implementation YW_ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = CurrentTitle;
    
    self.automaticallyAdjustsScrollViewInsets = false;
    pathStr = [[NSBundle mainBundle] pathForResource:@"historyRecord" ofType:@"plist"];
    
    [self setupNavigationBar];  //设置导航栏
    
    [self setupMenuBar];  //初始化 MenuBar
    
    [self setUpSearchBar];  //初始化搜索栏
    
    [self setUpTabBar];  //初始化标签栏
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 初始化 NavigationBar
- (void)setupNavigationBar
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 22)];
    [leftBtn setSelected:NO];
    [leftBtn setImage:[UIImage imageNamed:@"fold"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"expand"] forState:UIControlStateSelected];
    //    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 0)];
    [leftBtn addTarget:self action:@selector(showLeftList:) forControlEvents:UIControlEventTouchUpInside];
    
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
    YW_MenuSliderBar *menuBar = [[YW_MenuSliderBar alloc] initWithFrame:CGRectMake(0, 64, self.view.width, MenuBarHeight)];
    menuBar.maxShowNum = 4;
    [menuBar setUpMenuWithTitleArr:[self.menuTabArr objectForKey:@"Recent"]];
    
    self.menuBar = menuBar;
    self.menuBar.delegate = self;
    [self.view addSubview:menuBar];
    
    UIImageView *menuLeftMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MaskWidth, MenuBarHeight)];
    menuLeftMask.backgroundColor = [UIColor whiteColor];
    menuLeftMask.contentMode = UIViewContentModeScaleAspectFit;
    menuLeftMask.alpha = 0.6;
    
    UIImageView *menuRightMask = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - MaskWidth, 64, MaskWidth, MenuBarHeight)];
    [menuRightMask setImage:[UIImage imageNamed:RightMenuMaskArrow]];
    menuRightMask.backgroundColor = [UIColor whiteColor];
    menuRightMask.contentMode = UIViewContentModeScaleAspectFit;
    menuRightMask.alpha = 0.6;
    
    self.menuLeftMask = menuLeftMask;
    self.menuRightMask = menuRightMask;
    [self.view addSubview:menuLeftMask];
    [self.view addSubview:menuRightMask];
    
    __weak typeof(self) weakSelf = self;
    menuBar.clickItemBlock = ^(YW_MenuBarLabel *label) {
        if ([weakSelf.menuBar.currentTab isEqualToString:@"Recent"] && [label.text isEqualToString:@"Edit"]) {
            [weakSelf RecentEdit:label];
        }
    };
    
}

-(void)setUpSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake( MaskWidth, 64 + MenuBarHeight + BarSpace, self.view.width - 2 * MaskWidth, SearchBarHeight)];
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.searchBar setSearchFieldBackgroundImage:[MJCCommonTools jc_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    self.searchBar.searchTextPositionAdjustment = UIOffsetMake(10, 0);
    self.searchBar.barTintColor = [UIColor clearColor];
    self.searchBar.layer.borderWidth = 1.0;
    self.searchBar.layer.borderColor = [UIColor grayColor].CGColor;
    self.searchBar.layer.cornerRadius = 10;
    self.searchBar.returnKeyType = UIReturnKeySearch;
    
    [self.view addSubview:self.searchBar];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.backgroundColor = [UIColor whiteColor];
    [self.searchBar setSearchFieldBackgroundImage:[MJCCommonTools jc_imageWithColor:[UIColor colorWithHexString:SearBarNormalBackgourdColor]] forState:UIControlStateNormal];
    [self.menuBar updateMenuWithTitleArr:[_menuTabArr objectForKey:@"Search"]];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (![self.searchBar.text isEqualToString:@""]) {
        self.searchBar.backgroundColor = [UIColor colorWithHexString:SearBarSelectedBackgroudColor];
        [self.searchBar setSearchFieldBackgroundImage:[MJCCommonTools jc_imageWithColor:[UIColor colorWithHexString:SearBarSelectedBackgroudColor]] forState:UIControlStateNormal];
    }
    [self.menuBar updateMenuWithTitleArr:[_menuTabArr objectForKey:self.tabTitleArr[currentChildIndex]]];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self WriteToPlistFile:self.searchBar.text];
    [self removeCoverView];
    [self.tabBar setCurrentSelectedItem:3];
    [self.searchBar resignFirstResponder];
}


- (void)setUpTabBar
{
    CGFloat lalaY = MenuBarHeight + SearchBarHeight + BarSpace * 2 + 64;
    CGFloat lalaW = self.view.width;
    CGFloat lalaH = self.view.height - (lalaY + 49);
    
    self.tabTitleArr = [NSArray arrayWithObjects:@"Contact", @"Recent", @"Life", @"Search", nil];
    
    //标题数据数组
    MJCSegmentInterface *lala = [[MJCSegmentInterface alloc]initWithFrame:CGRectMake(0, lalaY, lalaW, lalaH)];
    lala.delegate = self;
    lala.isChildScollEnabled = YES;
    lala.indicatorHidden = YES;
    lala.itemBackSelectedImage = [MJCCommonTools jc_imageWithColor:[UIColor colorWithHexString:@"#FF6666"]];
    
    lala.titlesViewFrame = CGRectMake( MaskWidth, 0, self.view.width - 2 * MaskWidth, TabBarHeight);
    lala.itemTextNormalColor = [UIColor colorWithHexString:@"#FF6666"];
    lala.itemTextSelectedColor = [UIColor whiteColor];
    lala.itemTextFontSize = 13;
    lala.defaultShowItemCount = 2;
    [lala intoTitlesArray:self.tabTitleArr hostController:self];
    [self.view addSubview:lala];
    
    self.activityRecentVC = [[YW_ActivityRecentViewController alloc]init];
    
    UIViewController *vc2 = [[UIViewController alloc]init];
    vc2.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100.0)/100.0 green:arc4random_uniform(100.0)/100.0 blue:arc4random_uniform(100.0)/100.0 alpha:1];
    
    UIViewController *vc3 = [[UIViewController alloc]init];
    vc3.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100.0)/100.0 green:arc4random_uniform(100.0)/100.0 blue:arc4random_uniform(100.0)/100.0 alpha:1];
    
    UIViewController *vc4 = [[UIViewController alloc]init];
    vc4.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100.0)/100.0 green:arc4random_uniform(100.0)/100.0 blue:arc4random_uniform(100.0)/100.0 alpha:1];
    
    NSArray *vcarrr = @[vc2,self.activityRecentVC,vc3,vc4];
    [lala intoChildControllerArray:vcarrr];
    
    lala.defaultItemNumber = 1;
    currentChildIndex = 1;
    lala.defaultShowItemCount = 2;
    
    self.tabBar = lala;
    
    UIImageView *tabLeftMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, lalaY, MaskWidth, TabBarHeight)];
    [tabLeftMask setImage:[UIImage imageNamed:LeftTabMaskArrow]];
    tabLeftMask.backgroundColor = [UIColor whiteColor];
    tabLeftMask.contentMode = UIViewContentModeScaleAspectFit;
    tabLeftMask.alpha = 0.6;
    
    UIImageView *tabRightMask = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - MaskWidth, lalaY, MaskWidth, TabBarHeight)];
    [tabRightMask setImage:[UIImage imageNamed:RightTabMaskArrow]];
    tabRightMask.backgroundColor = [UIColor whiteColor];
    tabRightMask.contentMode = UIViewContentModeScaleAspectFit;
    tabRightMask.alpha = 0.6;
    
    self.tabLeftMask = tabLeftMask;
    self.tabRightMask = tabRightMask;
    [self.view addSubview:tabLeftMask];
    [self.view addSubview:tabRightMask];
    
}

- (void)mjc_ClickEvent:(MJCTabItem *)tabItem childViewController:(UIViewController *)childViewController segmentInterface:(MJCSegmentInterface *)segmentInterface;
{
    NSLog(@"%@", tabItem.titlesLable.text);
    currentChildIndex = (int)[self.tabTitleArr indexOfObject:tabItem.titlesLable.text];
    [self.menuBar updateMenuWithTitleArr:[_menuTabArr objectForKey:tabItem.titlesLable.text]];
}

- (void)title_scrollView:(UIScrollView *)scrollView
{
    CGPoint tabBarOffset = scrollView.contentOffset;
    
    //    self.tabLeftMask.backgroundColor = tabBarOffset.x > 0 ?[UIColor redColor]:[UIColor whiteColor];
    [self.tabLeftMask setImage:tabBarOffset.x > 0?[UIImage imageNamed:LeftTabMaskArrow]:NULL];
    
    //    self.tabRightMask.backgroundColor = tabBarOffset.x < scrollView.contentSize.width - scrollView.width ?[UIColor redColor]:[UIColor whiteColor];
    [self.tabRightMask setImage:tabBarOffset.x < scrollView.contentSize.width - scrollView.width ?[UIImage imageNamed:RightTabMaskArrow]:NULL];
}

-(void)childVC_scrollView:(UIScrollView *)scrollView
{
    CGFloat value = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (currentChildIndex == (int)value) {
        return;
    }
    currentChildIndex = value;
    
    [self.menuBar updateMenuWithTitleArr:[_menuTabArr objectForKey:self.tabTitleArr[currentChildIndex]]];
    
}

#pragma mark - 懒加载菜单标题栏
-(NSDictionary *)menuTabArr
{
    if (!_menuTabArr) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ActivityMenuTab" ofType:@"plist"];
        _menuTabArr = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return _menuTabArr;
}

#pragma mark - NavigationBar 左右按钮事件
- (void)showLeftList:(UIButton *)btn
{
    [self removeCoverView];
    
    if (!btn.isSelected) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect menuBarRect = self.menuBar.frame;
            menuBarRect.origin.y -= MenuBarHeight + SearchBarHeight + BarSpace * 2;
            self.menuBar.frame = menuBarRect;
            
            CGRect menuLeftMaskRect = self.menuLeftMask.frame;
            menuLeftMaskRect.origin.y -= MenuBarHeight + SearchBarHeight + BarSpace * 2;
            self.menuLeftMask.frame = menuLeftMaskRect;
            
            CGRect menuRightMaskRect = self.menuRightMask.frame;
            menuRightMaskRect.origin.y -= MenuBarHeight + SearchBarHeight + BarSpace * 2;
            self.menuRightMask.frame = menuRightMaskRect;
            
            CGRect searchBarRect = self.searchBar.frame;
            searchBarRect.origin.y -= MenuBarHeight + SearchBarHeight + BarSpace;
            self.searchBar.frame = searchBarRect;
            
            CGRect tabBarRect = self.tabBar.frame;
            tabBarRect.origin.y = 64;
            tabBarRect.size.height = self.view.height - 64 - 49;
            self.tabBar.frame = tabBarRect;
            
            CGRect tabLeftMaskRect = self.tabLeftMask.frame;
            tabLeftMaskRect.origin.y = 64;
            self.tabLeftMask.frame = tabLeftMaskRect;
            
            CGRect tabRightMaskRect = self.tabRightMask.frame;
            tabRightMaskRect.origin.y = 64;
            self.tabRightMask.frame = tabRightMaskRect;
            
            [btn setSelected:YES];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect menuBarRect = self.menuBar.frame;
            menuBarRect.origin.y = 64;
            self.menuBar.frame = menuBarRect;
            
            CGRect menuLeftMaskRect = self.menuLeftMask.frame;
            menuLeftMaskRect.origin.y = 64;
            self.menuLeftMask.frame = menuLeftMaskRect;
            
            CGRect menuRightMaskRect = self.menuRightMask.frame;
            menuRightMaskRect.origin.y = 64;
            self.menuRightMask.frame = menuRightMaskRect;
            
            CGRect searchBarRect = self.searchBar.frame;
            searchBarRect.origin.y = 64 + MenuBarHeight + BarSpace;
            self.searchBar.frame = searchBarRect;
            
            CGRect tabBarRect = self.tabBar.frame;
            tabBarRect.origin.y = 64 + MenuBarHeight + SearchBarHeight + 2 * BarSpace;
            self.tabBar.frame = tabBarRect;
            
            CGRect tabLeftMaskRect = self.tabLeftMask.frame;
            tabLeftMaskRect.origin.y = 64 + MenuBarHeight + SearchBarHeight + 2 * BarSpace;
            self.tabLeftMask.frame = tabLeftMaskRect;
            
            CGRect tabRightMaskRect = self.tabRightMask.frame;
            tabRightMaskRect.origin.y = 64 + MenuBarHeight + SearchBarHeight + 2 * BarSpace;
            self.tabRightMask.frame = tabRightMaskRect;
            
            [btn setSelected:NO];
        } completion:^(BOOL finished) {
            CGRect tabBarRect = self.tabBar.frame;
            tabBarRect.size.height = self.view.height - 64 - 49 - MenuBarHeight - SearchBarHeight - 2 * BarSpace;
            self.tabBar.frame = tabBarRect;
        }];
    }
}

- (void)showRightList
{
    
    [self removeCoverView];
    
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
    
    __weak typeof(self) weakSelf = self;
    
    self.listViewPopVC.listItemBlock = ^(NSInteger index){
        NSLog(@"index : %ld", (long)index);
        [weakSelf.listViewPopVC dismissViewControllerAnimated:YES completion:nil];
    };
}

#pragma mark - MenuBar 点击事件
- (void)RecentEdit:(id)sender
{
    [self.activityRecentVC setEditing:YES cancle:YES];
    
    if (!self.deleteBtn || !self.cancleBtn) {
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width / 2, EditBtnHeight)];
        cancleBtn.tag = 101;
        cancleBtn.backgroundColor = [UIColor grayColor];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancleBtn setTitle:@"Cancle" forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(RecenttEditBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width / 2, self.view.height - BottomTabBarHeight, self.view.width / 2, EditBtnHeight)];
        deleteBtn.tag = 102;
        deleteBtn.backgroundColor = [UIColor redColor];
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(RecenttEditBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        self.deleteBtn = deleteBtn;
        self.cancleBtn = cancleBtn;
        [self.view addSubview:self.deleteBtn];
        [self.view addSubview:self.cancleBtn];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect deleteFrame = self.deleteBtn.frame;
        deleteFrame.origin.y = self.view.height - BottomTabBarHeight - EditBtnHeight;
        self.deleteBtn.frame = deleteFrame;
        
        CGRect cancleFrame = self.cancleBtn.frame;
        cancleFrame.origin.y = self.view.height - BottomTabBarHeight - EditBtnHeight;
        self.cancleBtn.frame = cancleFrame;
    }];
}

-(void)RecenttEditBtn:(UIButton *)btn
{
    switch (btn.tag) {
        case 101:
        {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect deleteFrame = self.deleteBtn.frame;
                deleteFrame.origin.y = self.view.height;
                self.deleteBtn.frame = deleteFrame;
                
                CGRect cancleFrame = self.cancleBtn.frame;
                cancleFrame.origin.y = self.view.height;
                self.cancleBtn.frame = cancleFrame;
            }];
            
            [self.activityRecentVC setEditing:NO cancle:YES];
            break;
        }
        case 102:
        {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect deleteFrame = self.deleteBtn.frame;
                deleteFrame.origin.y = self.view.height;
                self.deleteBtn.frame = deleteFrame;
                
                CGRect cancleFrame = self.cancleBtn.frame;
                cancleFrame.origin.y = self.view.height;
                self.cancleBtn.frame = cancleFrame;
            }];
            [self.activityRecentVC setEditing:NO cancle:NO];
            break;
        }
        default:
            break;
    }
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
        [self.menuLeftMask setImage:menuBarOffset.x > 0?[UIImage imageNamed:LeftMenuMaskArrow]:NULL];
        
        //        self.menuRightMask.backgroundColor = menuBarOffset.x < scrollView.contentSize.width - scrollView.width ?[UIColor redColor]:[UIColor whiteColor];
        [self.menuRightMask setImage:menuBarOffset.x < scrollView.contentSize.width - scrollView.width ?[UIImage imageNamed:RightMenuMaskArrow]:NULL];
    }
}

-(void)keyBoardWillShow:(NSNotification *)notification
{
    if (coverView) {
        return;
    }
    
    CGRect rect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    coverView = [[UIControl alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, self.view.height - rect.size.height - 64 - MenuBarHeight - SearchBarHeight - BarSpace)];
    coverView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
    [coverView addTarget:self action:@selector(removeCoverView) forControlEvents:UIControlEventTouchUpInside];
    
    historyTableView = [[YW_HistoryTableView alloc] initWithFrame:CGRectMake( MaskWidth + 30, 64 + MenuBarHeight + SearchBarHeight + BarSpace, self.view.width - MaskWidth * 2 - 30, (self.historyRecord.count + 1) * 30)];
    __weak typeof(self) weakSelf = self;
    historyTableView.historyRecord = self.historyRecord;
    historyTableView.clearBlock = ^(){
        [weakSelf ClearPlistFile];
    };
    historyTableView.cellBlock = ^(NSString *text){
        weakSelf.searchBar.text = text;
    };
    
    NSArray *windowArray = [[UIApplication sharedApplication] windows];
    for(UIWindow *subWindow in windowArray)
    {
        // 键盘实际上是除了keyWindow之外的第二个window
        if(subWindow != [[UIApplication sharedApplication] keyWindow])
        {
            [subWindow addSubview:coverView];
            [subWindow addSubview:historyTableView];
        }
    }
    
    //    2.键盘弹出的时间
    CGFloat duration=[notification.userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //    3.执行动画
    [UIView animateWithDuration:duration animations:^{
        CGRect coverViewFrame = coverView.frame;
        coverViewFrame.origin.y = 64 + MenuBarHeight + SearchBarHeight + BarSpace;
        coverView.frame = coverViewFrame;
        
        CGRect historyTableViewFrame = historyTableView.frame;
        historyTableViewFrame.size.height = (self.historyRecord.count + 1) * 30;
        historyTableView.frame = historyTableViewFrame;
    }];
    
}

-(void)keyBoardWillChange:(NSNotification *)notification
{
    if (!coverView) {
        return;
    }
    
    CGRect rect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat duration=[notification.userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //    3.执行动画
    [UIView animateWithDuration:duration animations:^{
        CGRect coverViewFrame = coverView.frame;
        coverViewFrame.size.height = self.view.height - rect.size.height - 64 - MenuBarHeight - SearchBarHeight - BarSpace;
        coverView.frame = coverViewFrame;
    }];
    
}

-(void)keyBoardWillHide:(NSNotification *)notification
{
    [self removeCoverView];
}

#pragma mark - 移除监听事件
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 移除遮罩层
- (void)removeCoverView
{
    if(nil != coverView.superview)
    {
        [coverView removeFromSuperview];
        [historyTableView removeFromSuperview];
        coverView = nil;
        historyTableView = nil;
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark - 历史记录
-(NSMutableArray *)historyRecord
{
    if (!_historyRecord) {
        _historyRecord = [NSMutableArray arrayWithContentsOfFile:pathStr];
    }
    return _historyRecord;
}

#pragma mark - WritePlist文件
- (void)WriteToPlistFile:(NSString *)text
{
    if (_historyRecord.count == 3) {
        [_historyRecord removeLastObject];
    }
    
    BOOL isExit = false;
    for (NSString *string in _historyRecord) {
        if ([string isEqualToString:text]) {
            isExit = YES;
            break;
        }
    }
    
    if (isExit) {
        return;
    }
    
    [_historyRecord addObject:text];
    
    [_historyRecord writeToFile:pathStr atomically:YES];
    
}

#pragma mark - WritePlist文件
- (void)ClearPlistFile
{
    _historyRecord = [NSMutableArray array];
    
    [_historyRecord writeToFile:pathStr atomically:YES];
    
    if (historyTableView) {
        [historyTableView removeFromSuperview];
    }
    
    historyTableView = [[YW_HistoryTableView alloc] initWithFrame:CGRectMake( MaskWidth + 30, 64 + MenuBarHeight + SearchBarHeight + BarSpace, self.view.width - MaskWidth * 2 - 30, (self.historyRecord.count + 1) * 30)];
    __weak typeof(self) weakSelf = self;
    historyTableView.historyRecord = self.historyRecord;
    historyTableView.clearBlock = ^(){
        [weakSelf ClearPlistFile];
    };
    
    historyTableView.cellBlock = ^(NSString *text){
        weakSelf.searchBar.text = text;
    };
    
    NSArray *windowArray = [[UIApplication sharedApplication] windows];
    for(UIWindow *subWindow in windowArray)
    {
        // 键盘实际上是除了keyWindow之外的第二个window
        if(subWindow != [[UIApplication sharedApplication] keyWindow])
        {
            [subWindow addSubview:historyTableView];
        }
    }
    
}

#pragma mark - TouchBegan
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeCoverView];
}
@end

