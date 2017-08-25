//
//  YW_SubControllerMenuViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/16.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_SubControllerMenuViewController.h"
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
#import "SPUtil.h"

@interface YW_SubControllerMenuViewController () <UITableViewDelegate, UITableViewDataSource>

/** TableView */
@property(strong, nonatomic) UITableView *tableView;

/** HeaderView */
@property(strong, nonatomic) UIView *headerView;

/** Data */
@property(strong, nonatomic) NSArray *data;

@end

@implementation YW_SubControllerMenuViewController

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
    titleLabel.text = [[YW_MenuSingleton shareMenuInstance] menuTitle];
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
    if ([[[YW_MenuSingleton shareMenuInstance] menuTitle] isEqualToString:@"View"])
    {
        
        YW_MainMenuItem *Slide = [YW_MainMenuItem itemWithIcon:@"menu_invite" title:@"Slide" destVcClass:[YW_NewsViewController class]];
        YW_MainMenuItem *Fixed = [YW_MainMenuItem itemWithIcon:@"menu_invite" title:@"Fixed" destVcClass:[YW_NewsViewController class]];
        self.data = @[Slide, Fixed];
    }
    else
    {
        YW_MainMenuItem *Select = [YW_MainMenuItem itemWithIcon:@"menu_invite" title:@"Select" destVcClass:[YW_NewsViewController class]];
        self.data = @[Select];
    }
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
    
    YW_AnimateMemuViewController *animVC = (YW_AnimateMemuViewController *)self.parentViewController;
    [animVC closeMenu];
    
//    YW_MainMenuItem *cell = (YW_MainMenuItem *)[tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"%@", cell);
//    [[SPUtil sharedInstance] showNotificationInViewController:animVC.rootViewController title:@"AAAA" subtitle:nil type:SPMessageNotificationTypeMessage];
//    NSLog(@"%s, line = %d", __func__, __LINE__);
}

@end
