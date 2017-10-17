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

@interface YW_MyThingsTableViewController ()

@property (nonatomic , strong) NSMutableArray *rightItems;

@property (nonatomic , strong) NSMutableArray *leftItems;

@end

@implementation YW_MyThingsTableViewController

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
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YW_ThingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThingsCell"];
    
    cell.imgView.image = [UIImage imageNamed:@"avatar_login"];
    cell.nameLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
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
        __weak typeof(self) weakSelf = self;
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

@end
