//
//  YW_SubControllerMenuViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/16.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_SubControllerMenuViewController.h"
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
//    if ([[[YW_MenuSingleton shareMenuInstance] menuTitle] isEqualToString:@"View"])
//    {
//        
//        YW_MainMenuItem *Slide = [YW_MainMenuItem itemWithIcon:@"menu_invite" title:@"Slide" destVcClass:[NSNull class]];
//        YW_MainMenuItem *Fixed = [YW_MainMenuItem itemWithIcon:@"menu_invite" title:@"Fixed" destVcClass:[NSNull class]];
//        
//        self.data = @[Slide, Fixed];
//    }
//    else
//    {
//        YW_MainMenuItem *Select = [YW_MainMenuItem itemWithIcon:@"menu_invite" title:@"Select" destVcClass:[NSNull class]];
//        
//        if ([[[YW_MenuSingleton shareMenuInstance] menuTitle] isEqualToString:@"Things"]) {
//            YW_MainMenuItem *CreateCollection = [YW_MainMenuItem itemWithIcon:@"menu_invite" title:@"CreateCollection" destVcClass:[NSNull class]];
//            YW_MainMenuItem *AddThing = [YW_MainMenuItem itemWithIcon:@"menu_invite" title:@"AddThing" destVcClass:[NSNull class]];
//            self.data = @[Select, CreateCollection, AddThing];
//        }else
//        {
//            self.data = @[Select];
//        }
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

    YW_TableViewCell *cell = (YW_TableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    YW_AnimateMemuViewController *animVC = (YW_AnimateMemuViewController *)self.parentViewController;
    [animVC closeMenu];
    
//    if ([[[YW_MenuSingleton shareMenuInstance] viewTitle] isEqualToString:@"Diary"]) {
////        YW_DiaryViewController *diaryVC = (YW_DiaryViewController *)animVC.rootViewController;
////        [diaryVC setCurrentSelectedViewController:item.destVcNum];
//    }
//    else if ([[[YW_MenuSingleton shareMenuInstance] viewTitle] isEqualToString:@"Activity"]) {
//        YW_ActivityViewController *activityVC = (YW_ActivityViewController *)animVC.rootViewController;
//        [activityVC selectFunctionOfItemTitle:cell.item.itmeTitle];
//    }
//    else if ([[[YW_MenuSingleton shareMenuInstance] viewTitle] isEqualToString:@"Me"]) {
////        YW_MeViewController *meVC = (YW_MeViewController *)animVC.rootViewController;
////        [meVC setCurrentSelectedViewController:item.destVcNum];
//    }
}

@end
