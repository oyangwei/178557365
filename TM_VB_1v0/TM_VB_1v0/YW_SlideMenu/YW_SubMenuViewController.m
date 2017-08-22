//
//  YW_SubMenuViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/16.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_SubMenuViewController.h"
#import "YW_MainMenuItem.h"
#import "YW_TableViewCell.h"
#import "YW_AnimateMemuViewController.h"
#import "YW_NavigationController.h"
#import "YW_DiaryViewController.h"
#import "YW_ActivityViewController.h"
#import "YW_DiscoveryViewController.h"
#import "YW_NewsViewController.h"
#import "YW_MeViewController.h"
#import "YW_SliderMenuTool.h"

@interface YW_SubMenuViewController () <UITableViewDelegate, UITableViewDataSource>

/** TableView */
@property(strong, nonatomic) UITableView *tableView;

/** HeaderView */
@property(strong, nonatomic) UIView *headerView;

/** Data */
@property(strong, nonatomic) NSArray *data;

@end

@implementation YW_SubMenuViewController

-(NSArray *)data
{
    if (!_data) {
        _data = [NSArray array];
    }
    return _data;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:ThemeColor];
    
    [self setupView];
    
    [self setupData];
}

-(void)setupView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 150)];
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"Diary_Menu";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [self.headerView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerView.mas_leading);
        make.trailing.equalTo(self.headerView.mas_trailing);
        make.centerY.equalTo(self.headerView.mas_centerY);
    }];
}

-(void)setupData
{
    YW_MainMenuItem *Contact = [YW_MainMenuItem itemWithIcon:@"menu_wallet" title:@"Contact" destVcClass:[YW_DiaryViewController class]];
    
    YW_MainMenuItem *Chat = [YW_MainMenuItem itemWithIcon:@"menu_promo" title:@"Chat" destVcClass:[YW_ActivityViewController class]];
    
    YW_MainMenuItem *Life = [YW_MainMenuItem itemWithIcon:@"menu_trips" title:@"Life" destVcClass:[YW_NewsViewController class]];
    
    YW_MainMenuItem *Search = [YW_MainMenuItem itemWithIcon:@"menu_invite" title:@"Search" destVcClass:[YW_NewsViewController class]];

    self.data = @[Contact, Chat, Life, Search];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YW_TableViewCell *cell = [YW_TableViewCell cellWithTableView:tableView];
    cell.item = self.data[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YW_MainMenuItem *item = _data[indexPath.row];
    if (item.destVcClass == nil) return;
    
    YW_AnimateMemuViewController *animateVC = (YW_AnimateMemuViewController *)self.parentViewController;
    [animateVC closeMenu];
    
    UIViewController *vc = [[item.destVcClass alloc] init];
    
    YW_NavigationController *nVC = [[YW_NavigationController alloc] initWithRootViewController:vc];

    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        window.rootViewController = nVC;
        [YW_SliderMenuTool hide];
    });
}

@end
