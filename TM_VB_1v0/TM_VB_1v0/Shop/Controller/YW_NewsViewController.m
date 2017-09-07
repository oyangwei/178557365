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

#import "YW_NewsViewController.h"
#import "MJCSegmentInterface.h"
#import "YW_MenuSliderBar.h"
#import "YW_NaviBarListViewController.h"
#import "SPUtil.h"
#import "SPKitExample.h"
#import "MJCCommonTools.h"
#import "MJCTitlesView.h"
#import "YW_HistoryTableView.h"
#import "YW_MenuBarLabel.h"
#import "YW_SegmentInterface.h"
#import "YW_SuspendUIButton.h"
#import "YW_SubMenuViewController.h"
#import "YW_SubControllerMenuViewController.h"
#import "YW_SliderMenuTool.h"
#import "YW_MainMenuViewController.h"

#define BottomTabBarHeight self.tabBar.frame.size.height

static CGFloat viewOriginY = 64;

@interface YW_NewsViewController () <MJCSlideSwitchViewDelegate, UIScrollViewDelegate, UISearchBarDelegate, UITextFieldDelegate, SegmentInterfaceDelegate, UIGestureRecognizerDelegate>
{
    CGFloat keyBoardHeight; // 键盘高度
    int currentChildIndex;  // 当前标签视图序号
    UIControl *coverView;   // 蒙版
    NSString *pathStr;   //历史记录文件路径
    YW_HistoryTableView *historyTableView; // 历史记录
}

/** 菜单栏按钮标题 */
@property(strong, nonatomic) NSDictionary *menuTabArr;

/** 菜单按钮标题 */
@property(strong, nonatomic) NSMutableArray *menuArr;

/** MenuBar */
@property(strong, nonatomic) YW_MenuSliderBar *menuBar;

/** 搜索栏 */
@property(strong, nonatomic) UISearchBar *searchBar;

/** 标签栏 */
@property(strong, nonatomic) YW_SegmentInterface *tabViewController;

/** 标签子控制器标题 */
@property(strong, nonatomic) NSMutableArray *tabTitleArr;

/** 历史记录 */
@property(strong, nonatomic) NSMutableArray *historyRecord;

/** window */
@property (nonatomic, strong) UIWindow *window;

/** 悬浮按钮 */
@property (nonatomic, strong) YW_SuspendUIButton *suspendBtn;

@end

@implementation YW_NewsViewController

-(NSMutableArray *)menuArr:(NSArray *)array
{
    NSMutableArray *menuArr = [NSMutableArray array];
    [menuArr addObject:@"News"];
    [menuArr addObjectsFromArray:array];
    self.menuArr = menuArr;
    return menuArr;
}

#pragma mark - 懒加载菜单标题栏
-(NSDictionary *)menuTabArr
{
    if (!_menuTabArr) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"NewsMenuTab" ofType:@"plist"];
        _menuTabArr = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return _menuTabArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[YW_MenuSingleton shareMenuInstance] setViewTitle:@"News"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    pathStr = [[NSBundle mainBundle] pathForResource:@"historyRecord" ofType:@"plist"];
    
    [self setupNavigationBar];  //设置导航栏
    
    [self setUpSearchBar];  //初始化搜索栏
    
    [self setUpTabBar];  //初始化标签栏
    
    [self performSelector:@selector(creatSuspendBtn) withObject:nil afterDelay:1.0];
    
    UIScreenEdgePanGestureRecognizer *panEdgeGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithLeftGesture:)];
    panEdgeGestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:panEdgeGestureRecognizer];
    
    panEdgeGestureRecognizer.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.alpha = 0.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 初始化 NavigationBar
- (void)setupNavigationBar
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    
    if (!self.navigationController.navigationBar.translucent) {
        viewOriginY = 0;
    }
    
    //自定义一个NaVIgationBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(showMainMenu) forControlEvents:UIControlEventTouchUpInside];
    
    YW_MenuSliderBar *menuBar = [[YW_MenuSliderBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, MenuBarHeight)];
    menuBar.maxShowNum = 3;
    [menuBar setUpMenuWithTitleArr:[self menuArr:[self.menuTabArr objectForKey:@"Title01"]]];
    menuBar.backgroundColor = [UIColor clearColor];
    
    self.menuBar = menuBar;
    self.menuBar.delegate = self;
    
    menuBar.clickItemBlock = ^(YW_MenuBarLabel *label) {
        [self clickMenuItem:label];
    };
    
    self.navigationItem.titleView = menuBar;
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBarItem];
    
}


-(void)clickMenuItem:(YW_MenuBarLabel *)label
{
    [[YW_MenuSingleton shareMenuInstance] setMenuTitle:label.text];
    if ([self.tabTitleArr[currentChildIndex] isEqualToString:@"Title01"]) {
        int index = (int)[[self menuArr:[self.menuTabArr objectForKey:@"Title01"]] indexOfObject:label.text];
        switch (index) {
            case 0:
                [self showSlideMenu:YW_ShowMenuFromLeft withViewController:[YW_SubMenuViewController class]];
                break;
            case 1:
                [self showSlideMenu:YW_ShowMenuFromRight withViewController:[YW_SubControllerMenuViewController class]];
                break;
            case 2:
                [self showSlideMenu:YW_ShowMenuFromRight withViewController:[YW_SubControllerMenuViewController class]];
                break;
            case 3:
                //                [self showSlideMenu:YW_ShowMenuFromRight withViewController:[YW_SubControllerMenuViewController class]];
                break;
            default:
                break;
        }
    }
    
    if ([self.tabTitleArr[currentChildIndex] isEqualToString:@"Title02"]) {
        int index = (int)[[self menuArr:[self.menuTabArr objectForKey:@"Title02"]] indexOfObject:label.text];
        switch (index) {
            case 0:
                [self showSlideMenu:YW_ShowMenuFromLeft withViewController:[YW_SubMenuViewController class]];
                break;
            case 1:
                [self showSlideMenu:YW_ShowMenuFromRight withViewController:[YW_SubControllerMenuViewController class]];
                break;
            case 2:
                [self showSlideMenu:YW_ShowMenuFromRight withViewController:[YW_SubControllerMenuViewController class]];
                break;
            case 3:
                //                [self showSlideMenu:YW_ShowMenuFromRight withViewController:[YW_SubControllerMenuViewController class]];
                break;
            default:
                break;
        }
    }
    
    if ([self.tabTitleArr[currentChildIndex] isEqualToString:@"Title03"]) {
        int index = (int)[[self menuArr:[self.menuTabArr objectForKey:@"Title03"]] indexOfObject:label.text];
        switch (index) {
            case 0:
                [self showSlideMenu:YW_ShowMenuFromLeft withViewController:[YW_SubMenuViewController class]];
                break;
            case 1:
                [self showSlideMenu:YW_ShowMenuFromRight withViewController:[YW_SubControllerMenuViewController class]];
                break;
            case 2:
                [self showSlideMenu:YW_ShowMenuFromRight withViewController:[YW_SubControllerMenuViewController class]];
                break;
            case 3:
                //                [self showSlideMenu:YW_ShowMenuFromRight withViewController:[YW_SubControllerMenuViewController class]];
                break;
            default:
                break;
        }
    }
}

#pragma mark - 初始化搜索栏
-(void)setUpSearchBar
{
    UIView *serarchBarView = [[UIView alloc] init];
    serarchBarView.backgroundColor  = [UIColor colorWithHexString:ThemeColor];
    serarchBarView.userInteractionEnabled = YES;
    
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.imageView.contentMode = UIViewContentModeScaleToFill;
    [backBtn setImage:[UIImage imageNamed:BackBtnImageName] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:BackBtnImageName] forState:UIControlStateHighlighted];
    //    [backBtn addTarget:self action:@selector(selector) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *goBtn = [[UIButton alloc] init];
    goBtn.imageView.contentMode = UIViewContentModeScaleToFill;
    [goBtn setImage:[UIImage imageNamed:GoBtnImageName] forState:UIControlStateNormal];
    [goBtn setImage:[UIImage imageNamed:GoBtnImageName] forState:UIControlStateHighlighted];
    //    [backBtn addTarget:self action:@selector(selector) forControlEvents:UIControlEventTouchUpInside];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.searchBar setSearchFieldBackgroundImage:[MJCCommonTools jc_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    self.searchBar.searchTextPositionAdjustment = UIOffsetMake(10, 0);
    self.searchBar.barTintColor = [UIColor clearColor];
    //    self.searchBar.layer.borderWidth = 1.0;
    //    self.searchBar.layer.borderColor = [UIColor grayColor].CGColor;
    //    self.searchBar.layer.cornerRadius = 10;
    self.searchBar.returnKeyType = UIReturnKeySearch;
    
    [serarchBarView addSubview:backBtn];
    [serarchBarView addSubview:goBtn];
    [serarchBarView addSubview:self.searchBar];
    [self.view addSubview:serarchBarView];
    
    [serarchBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_equalTo(SearchBarHeight);
    }];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(serarchBarView.mas_leading).offset(10);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
        make.centerY.equalTo(serarchBarView.mas_centerY);
    }];
    
    [goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(backBtn.mas_trailing).offset(15);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
        make.centerY.equalTo(serarchBarView.mas_centerY);
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(goBtn.mas_trailing).offset(15);
        make.trailing.equalTo(self.view.mas_trailing).offset(-10);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(serarchBarView.mas_centerY);
    }];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.backgroundColor = [UIColor whiteColor];
    [self.searchBar setSearchFieldBackgroundImage:[MJCCommonTools jc_imageWithColor:[UIColor colorWithHexString:SearBarNormalBackgourdColor]] forState:UIControlStateNormal];
    [self.menuBar updateMenuWithTitleArr:[self menuArr:[self.menuTabArr objectForKey:@"Title03"]]];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (![self.searchBar.text isEqualToString:@""]) {
        self.searchBar.backgroundColor = [UIColor colorWithHexString:SearBarSelectedBackgroudColor];
        [self.searchBar setSearchFieldBackgroundImage:[MJCCommonTools jc_imageWithColor:[UIColor colorWithHexString:SearBarSelectedBackgroudColor]] forState:UIControlStateNormal];
    }
    [self.menuBar updateMenuWithTitleArr:[self menuArr:[self.menuTabArr objectForKey:self.tabTitleArr[currentChildIndex]]]];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self WriteToPlistFile:self.searchBar.text];
    [self removeCoverView];
    [self.tabViewController setCurrentSelectedItemNum:3];
    [self.searchBar resignFirstResponder];
}

#pragma mark - 初始化子控制器栏
- (void)setUpTabBar
{
    CGFloat lalaY = SearchBarHeight + viewOriginY;
    CGFloat lalaW = ScreenWitdh;
    CGFloat lalaH = viewOriginY == 0 ? ScreenHeight - lalaY - 64 : ScreenHeight - lalaY ;
    
    self.tabTitleArr = [NSMutableArray arrayWithObjects:@"Title01", @"Title02", @"Title03", nil];
    
    YW_SegmentInterface *interface = [[YW_SegmentInterface alloc] initWithFrame:CGRectMake(0, lalaY, lalaW, lalaH)];
    
    interface.delegate = self;
    interface.showItemCount = 1;
    interface.defaultSelectNum = 0;
    currentChildIndex = 0;
    
    interface.itemNormalTextColor = [UIColor whiteColor];
    interface.itemSelectedTextColor = [UIColor whiteColor];
    
    interface.itemNormalBackgroudColor = [UIColor colorWithHexString:@"#8EAFD3"];
    interface.itemSelectedBackgroudColor = [UIColor colorWithHexString:ThemeColor];
    
    UIViewController *vc1 = [[UIViewController alloc]init];
    vc1.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100.0)/100.0 green:arc4random_uniform(100.0)/100.0 blue:arc4random_uniform(100.0)/100.0 alpha:1];
    
    UIViewController *vc2 = [[UIViewController alloc]init];
    vc2.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100.0)/100.0 green:arc4random_uniform(100.0)/100.0 blue:arc4random_uniform(100.0)/100.0 alpha:1];
    
    UIViewController *vc3 = [[UIViewController alloc]init];
    vc3.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100.0)/100.0 green:arc4random_uniform(100.0)/100.0 blue:arc4random_uniform(100.0)/100.0 alpha:1];
    
    NSArray *vcarrr = @[vc1,vc2,vc3];
    
    [[YW_MenuSingleton shareMenuInstance] setMenuControllersTitlesArr:self.tabTitleArr];
    
    [interface intoTitlesArray:self.tabTitleArr hostController:self];
    
    [interface intoChildControllerArray:[NSMutableArray arrayWithArray:vcarrr] isInsert:NO];
    
    self.tabViewController = interface;
    [self.view addSubview:interface];
}

#pragma mark - SegmentInterfaceDelegate
-(void)yw_ClickEvent:(YW_TabItem *)tabItem childViewController:(UIViewController *)childViewController segmentInterface:(YW_SegmentInterface *)segmentInterface
{
    currentChildIndex = (int)[self.tabTitleArr indexOfObject:tabItem.titlesLable.text];
    [self.menuBar updateMenuWithTitleArr:[self menuArr:[self.menuTabArr objectForKey:tabItem.titlesLable.text]]];
}

-(void)childVC_scrollView:(UIScrollView *)scrollView
{
    CGFloat value = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (currentChildIndex == (int)value) {
        return;
    }
    currentChildIndex = value;
    
    [self.menuBar updateMenuWithTitleArr:[self menuArr:[self.menuTabArr objectForKey:self.tabTitleArr[currentChildIndex]]]];
}

#pragma mark - NavigationBar 左右按钮事件
- (void)showMainMenu
{
    [YW_SliderMenuTool showMenuWithRootViewController:self withToViewController:[YW_MainMenuViewController class]];
}

- (void)showSlideMenu:(YW_ShowMenuStyles)showMenuStyle withViewController:(Class)class
{
    if (showMenuStyle != YW_ShowMenuFromLeft && showMenuStyle != YW_ShowMenuFromRight) {
        showMenuStyle = YW_ShowMenuFromLeft;
    }
    
    switch (showMenuStyle) {
        case YW_ShowMenuFromLeft:
        {
            [YW_SliderMenuTool showMenuWithRootViewController:self withToViewController:class];
            break;
        }
        case YW_ShowMenuFromRight:
        {
            [YW_SliderMenuTool showFunctionMenuWithRootViewController:self withToViewController:class];
            break;
        }
        default:
            break;
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
    
    [_window resignKeyWindow];
    _window  = nil;
    
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

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL result = NO;
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        result = YES;
    }
    return result;
}

-(void)moveViewWithLeftGesture:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self showMainMenu];
    }
}

#pragma mark - 创建悬浮按钮
-(void)creatSuspendBtn{
    //悬浮按钮
    _suspendBtn = [[YW_SuspendUIButton alloc] initWithFrame:CGRectMake(0,0, 80, 80)];
    _suspendBtn.backgroundColor = [UIColor colorWithHexString:ThemeColor];
    [_suspendBtn setTitle:@"Menu" forState:UIControlStateNormal];
    //    [_button addTarget:self action:@selector(suspendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _suspendBtn.rootView = self.view.superview;
    
    //悬浮按钮所处的顶端UIWindow
    _window = [[UIWindow alloc] initWithFrame:CGRectMake(ScreenWitdh - 90, ScreenHeight - 90, 80, 80)];
    //使得新建window在最顶端
    _window.windowLevel = UIWindowLevelAlert + 1;
    _window.backgroundColor = [UIColor clearColor];
    _window.layer.cornerRadius = 40;
    _window.layer.masksToBounds = YES;
    [_window addSubview:_suspendBtn];
    //显示window
    [_window makeKeyAndVisible];
}

#pragma mark - 设置当前选择的子控制器
-(void)setCurrentSelectedViewController:(NSInteger)currentItemNum
{
    [self.tabViewController setCurrentSelectedItemNum:(int)currentItemNum];
}

@end
