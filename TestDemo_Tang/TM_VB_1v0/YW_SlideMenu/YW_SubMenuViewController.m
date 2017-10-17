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
#import "YW_SliderMenuTool.h"

@interface YW_SubMenuViewController () <UITableViewDelegate, UITableViewDataSource>

/** TableView */
@property(strong, nonatomic) UITableView *tableView;

/** HeaderView */
@property(strong, nonatomic) UIView *headerView;

/** Data */
@property(strong, nonatomic) NSMutableArray *data;

@end

@implementation YW_SubMenuViewController

-(NSMutableArray *)data
{
    if (!_data) {
        _data = [NSMutableArray array];
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
//    titleLabel.text = [[YW_MenuSingleton shareMenuInstance] menuTitle];
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
//    NSArray *arr = [[YW_MenuSingleton shareMenuInstance] menuControllersTitlesArr];
//
//    for (int i = 0; i < arr.count; i++) {
//        YW_MainMenuItem *item = [YW_MainMenuItem itemWithIcon:@"menu_wallet" title:arr[i] destVcNumber:i];
//        [self.data addObject:item];
//    }
    
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
    
//    YW_MainMenuItem *item = _data[indexPath.row];
//
//    YW_AnimateMemuViewController *animateVC = (YW_AnimateMemuViewController *)self.parentViewController;
//    [animateVC closeMenu];
    
//    if ([[[YW_MenuSingleton shareMenuInstance] menuTitle] isEqualToString:@"Diary"]) {
//        YW_DiaryViewController *diaryVC = (YW_DiaryViewController *)animateVC.rootViewController;
//    }
//    else if ([[[YW_MenuSingleton shareMenuInstance] menuTitle] isEqualToString:@"Activity"]) {
//        YW_ActivityViewController *activityVC = (YW_ActivityViewController *)animateVC.rootViewController;
//        [activityVC setCurrentSelectedViewController:item.destVcNum];
//    }
//    else if ([[[YW_MenuSingleton shareMenuInstance] menuTitle] isEqualToString:@"Me"]) {
//        YW_MeViewController *meVC = (YW_MeViewController *)animateVC.rootViewController;
//        [meVC setCurrentSelectedViewController:item.destVcNum];
//    }
}

@end
