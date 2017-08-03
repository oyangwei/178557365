//
//  YW_MeViewController.m
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

//
//  YW_ShopViewController.m
//  TM_VB_1v0
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_MeViewController.h"
#import "MJCSegmentInterface.h"
#import "YW_MenuSliderBar.h"
#import "YW_NaviBarListViewController.h"
#import "SPUtil.h"
#import "SPKitExample.h"
#import "MJCCommonTools.h"
#import "MJCTitlesView.h"
#import "YW_HistoryTableView.h"

#define BottomTabBarHeight self.tabBar.frame.size.height

#define CurrentTitle @"<<     Me     >>"
#define MenuBarHeight 44
#define SearchBarHeight 30
#define TabBarHeight 30
#define BarSpace 5
#define MaskWidth 20

@interface YW_MeViewController () <MJCSlideSwitchViewDelegate, UIPopoverPresentationControllerDelegate, UIScrollViewDelegate, UISearchBarDelegate, UITextFieldDelegate>
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

/** 历史记录 */
@property(strong, nonatomic) NSMutableArray *historyRecord;

@end

@implementation YW_MeViewController

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
    [leftBtn setImage:[UIImage imageNamed:@"leftList"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"rightList"] forState:UIControlStateNormal];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 0)];
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
    [menuBar setUpMenuWithTitleArr:[self.menuTabArr objectForKey:@"Chat"]];
    
    self.menuBar = menuBar;
    self.menuBar.delegate = self;
    [self.view addSubview:menuBar];
    
    UIImageView *menuLeftMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MaskWidth, MenuBarHeight)];
    menuLeftMask.backgroundColor = [UIColor whiteColor];
    menuLeftMask.layer.shadowOffset = CGSizeMake(3, 0);
    menuLeftMask.layer.shadowColor = [UIColor orangeColor].CGColor;
    menuLeftMask.layer.shadowOpacity = 1.0;
    menuLeftMask.layer.shadowRadius = 3;
    menuLeftMask.alpha = 0.6;
    
    UIImageView *menuRightMask = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - MaskWidth, 64, MaskWidth, MenuBarHeight)];
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
    [self.menuBar updateMenuWithTitleArr:[_menuTabArr objectForKey:@"Search"]];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
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
    
    self.tabTitleArr = [NSArray arrayWithObjects:@"Contact", @"Chat", @"Life", @"Search", nil];
    
    //标题数据数组
    MJCSegmentInterface *lala = [[MJCSegmentInterface alloc]initWithFrame:CGRectMake(0, lalaY, lalaW, lalaH)];
    lala.delegate = self;
    
    lala.titlesViewFrame = CGRectMake(0, 0, self.view.width, TabBarHeight);
    lala.itemTextNormalColor = [UIColor redColor];
    lala.itemTextSelectedColor = [UIColor purpleColor];
    lala.isIndicatorFollow = YES;
    lala.itemTextFontSize = 13;
    [lala intoTitlesArray:self.tabTitleArr hostController:self];
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
    currentChildIndex = 1;
    lala.defaultShowItemCount = 2;
    
    self.tabBar = lala;
    
    UIImageView *tabLeftMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, lalaY, MaskWidth, TabBarHeight)];
    [tabLeftMask setImage:[UIImage imageNamed:@"left_more"]];
    tabLeftMask.backgroundColor = [UIColor whiteColor];
    tabLeftMask.layer.shadowOffset = CGSizeMake(3, 0);
    tabLeftMask.layer.shadowColor = [UIColor orangeColor].CGColor;
    tabLeftMask.layer.shadowOpacity = 1.0;
    tabLeftMask.layer.shadowRadius = 3;
    tabLeftMask.alpha = 0.6;
    
    UIImageView *tabRightMask = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - MaskWidth, lalaY, MaskWidth, TabBarHeight)];
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
    [self.tabLeftMask setImage:tabBarOffset.x > 0?[UIImage imageNamed:@"left_more"]:NULL];
    
    //    self.tabRightMask.backgroundColor = tabBarOffset.x < scrollView.contentSize.width - scrollView.width ?[UIColor redColor]:[UIColor whiteColor];
    [self.tabRightMask setImage:tabBarOffset.x < scrollView.contentSize.width - scrollView.width ?[UIImage imageNamed:@"right_more"]:NULL];
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
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MenuTab" ofType:@"plist"];
        _menuTabArr = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSLog(@"%@", _menuTabArr);
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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
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
