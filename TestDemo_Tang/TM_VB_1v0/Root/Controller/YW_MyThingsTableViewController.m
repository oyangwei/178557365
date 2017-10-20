//
//  YW_MyThingsTableViewController.m
//  TestDemo_Tang
//
//  Created by Oyw on 2017/10/16.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_MyThingsTableViewController.h"
#import "YW_BaseNavigationController.h"
#import "YW_RootViewController.h"
#import "YW_ThingsTableViewCell.h"
#import "YCXMenu.h"
#import "YW_PairViewController.h"
#import "YW_ThingsSingleTon.h"
#import "YW_ThingsModel.h"
#import "YW_ThingControllViewController.h"
#import "YW_PairConfirmView.h"

@interface YW_MyThingsTableViewController ()

@property (nonatomic , strong) NSMutableArray *rightItems;

@property (nonatomic , strong) NSMutableArray *leftItems;

@property (nonatomic , strong) NSMutableArray *things;

/** AlertUIWindow */
@property(strong, nonatomic) UIWindow *alertWindow;

/** YW_PairConfirmView */
@property(strong, nonatomic) YW_PairConfirmView *confirmView;


@end

@implementation YW_MyThingsTableViewController

-(NSMutableArray *)things
{
    if (!_things) {
        _things = [YW_ThingsSingleTon shareInstance].thingsArray;
    }
    return _things;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillAppear) name:YCXMenuWillAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidAppear) name:YCXMenuDidAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillDisappear) name:YCXMenuWillDisappearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidDisappear) name:YCXMenuDidDisappearNotification object:nil];
    
    [self setupNav];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YW_ThingsTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"ThingsCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)menuWillAppear {
    NSLog(@"menu will appear");
}

- (void)menuDidAppear {
    NSLog(@"menu did appear");
}

- (void)menuWillDisappear {
    NSLog(@"menu will disappear");
}

- (void)menuDidDisappear {
    NSLog(@"menu did disappear");
}

-(void)setupNav
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:ThemeColor]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"list" highImage:@"list_click" target:self action:@selector(showLeftMenu)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"add" highImage:@"add_click" target:self action:@selector(showRightMenu)];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.things.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YW_ThingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThingsCell"];
    YW_ThingsModel *model = self.things[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:model.iconName];
    cell.nameLabel.text = model.productName;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YW_ThingsModel *model = self.things[indexPath.row];
    YW_ThingControllViewController *thingControlVC = [[YW_ThingControllViewController alloc] init];
    thingControlVC.titleName = model.productName;
    [self.navigationController pushViewController:thingControlVC animated:YES];
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *renameAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Rename" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"Rename : %ld", indexPath.row);
        [self alertPairConfirmView:(int)indexPath.row];
    }];
    
    UITableViewRowAction *deletedAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"Delete : %ld", indexPath.row);
        
        [self.things removeObjectAtIndex:indexPath.row];
        [[YW_ThingsSingleTon shareInstance] setThingsArray:self.things];
        [self.tableView reloadData];
    }];
    deletedAction.backgroundColor = [UIColor colorWithHexString:ThemeColor];
    
    return @[deletedAction, renameAction];
}

-(void)showLeftMenu
{
    [YCXMenu setTintColor:[UIColor colorWithHexString:ThemeColor]];
    [YCXMenu setSelectedColor:[UIColor colorWithHexString:ViewBgColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
//        __weak typeof(self) weakSelf = self;
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(10, 0, 50, 0) menuItems:self.leftItems selected:^(NSInteger index, YCXMenuItem *item) {
            if (index == 0) {
                YW_RootViewController *rootVC = [[YW_RootViewController alloc] init];
                YW_BaseNavigationController *navigationVC = [[YW_BaseNavigationController alloc] initWithRootViewController:rootVC];
            
                UIWindow *window = [UIApplication alloc].keyWindow;
                [window setRootViewController:navigationVC];
            }else
            {
                
            }
        }];
    }
}

-(void)showRightMenu
{
    [YCXMenu setTintColor:[UIColor colorWithHexString:ThemeColor]];
    [YCXMenu setSelectedColor:[UIColor colorWithHexString:ViewBgColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
//        __weak typeof(self) weakSelf = self;
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 0, 50, 0) menuItems:self.rightItems selected:^(NSInteger index, YCXMenuItem *item) {
            if (index == 0) {
                YW_PairViewController *pairVC = [[YW_PairViewController alloc] init];
                [self.navigationController pushViewController:pairVC animated:YES];
            }else
            {
                
            }
        }];
    }
}

#pragma mark - setter/getter
- (NSMutableArray *)rightItems {
    if (!_rightItems) {
        
        // set title
        YCXMenuItem *scanAdd = [YCXMenuItem menuTitle:@"Add By Scan" WithIcon:nil];
        scanAdd.foreColor = [UIColor whiteColor];
        scanAdd.titleFont = [UIFont boldSystemFontOfSize:17.0f];
        scanAdd.alignment = NSTextAlignmentCenter;
        
        YCXMenuItem *inputAdd = [YCXMenuItem menuTitle:@"Add By Input" WithIcon:nil];
        inputAdd.foreColor = [UIColor whiteColor];
        inputAdd.titleFont = [UIFont boldSystemFontOfSize:17.0f];
        inputAdd.alignment = NSTextAlignmentCenter;
        
        //set item
        _rightItems = [@[
                    [YCXMenuItem menuItem:@"Add By Scan"
                                    image:nil
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"Add By Input"
                                    image:nil
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}],
                    ] mutableCopy];
    }
    return _rightItems;
}

#pragma mark - setter/getter
- (NSMutableArray *)leftItems {
    if (!_leftItems) {
        
        // set title
//        YCXMenuItem *logout = [YCXMenuItem menuTitle:@"Log Out" WithIcon:nil];
//        logoutAdd.foreColor = [UIColor whiteColor];
//        logoutAdd.titleFont = [UIFont boldSystemFontOfSize:17.0f];
//        logoutAdd.alignment = NSTextAlignmentCenter;
//
//        YCXMenuItem *news = [YCXMenuItem menuTitle:@"VioBee News" WithIcon:nil];
//        news.foreColor = [UIColor whiteColor];
//        news.titleFont = [UIFont boldSystemFontOfSize:17.0f];
//        news.alignment = NSTextAlignmentCenter;
        
        //set item
        _leftItems = [@[
                         [YCXMenuItem menuItem:@"Log Out"
                                         image:nil
                                           tag:100
                                      userInfo:@{@"title":@"Menu"}],
                         [YCXMenuItem menuItem:@"VioBee News"
                                         image:nil
                                           tag:101
                                      userInfo:@{@"title":@"Menu"}],
                         ] mutableCopy];
    }
    return _leftItems;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([YCXMenu isShow]) {
        [YCXMenu dismissMenu];
    }
}

-(void)alertPairConfirmView:(int)row
{
    NSLog(@"%s, line = %d", __func__, __LINE__);
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow = window;
    window.backgroundColor = [UIColor clearColor];
    window.windowLevel = UIWindowLevelAlert;
    window.hidden = NO;
    
    UIView *bgView = [[UIView alloc] initWithFrame:window.frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.3;
    [window addSubview:bgView];
    
    __weak typeof(NSMutableArray *) thingsArr = [YW_ThingsSingleTon shareInstance].thingsArray;
    __weak typeof(YW_ThingsModel *) model = self.things[row];
    
    YW_PairConfirmView *confirmView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YW_PairConfirmView class]) owner:self options:nil] lastObject];
    confirmView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height/ 2 - 80);
    confirmView.modelNoLabel.text = model.productName;
    [confirmView.renameTextFiled becomeFirstResponder];
    self.confirmView = confirmView;
    __weak typeof(self) weakSelf = self;
    __block typeof(YW_PairConfirmView *) weakConfirmView = confirmView;
    confirmView.confirmBlock = ^{
        NSString *newModelNo;
        if (![weakConfirmView.renameTextFiled.text isEqualToString:@""]) {
            newModelNo = weakConfirmView.renameTextFiled.text;
        }else
        {
            newModelNo = weakConfirmView.modelNoLabel.text;
        }
        
        weakSelf.alertWindow.hidden = YES;
        model.productName = newModelNo;
        
        [thingsArr replaceObjectAtIndex:row withObject:model];
        [[YW_ThingsSingleTon shareInstance] setThingsArray:thingsArr];
        weakSelf.things = thingsArr;
        [weakConfirmView.renameTextFiled resignFirstResponder];
        [weakSelf.tableView reloadData];
    };
    
    [UIView animateWithDuration:0.5 animations:^{
        [window addSubview:confirmView];
    } ];
}

@end
