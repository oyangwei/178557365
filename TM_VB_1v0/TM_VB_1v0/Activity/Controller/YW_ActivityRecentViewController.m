//
//  YW_ActivityRecentViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/9.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_ActivityRecentViewController.h"
#import "YW_ActivityRecentTableViewCell.h"
#import "YW_ActivityCollectionViewController.h"
#import "SPUtil.h"
#import "YWNetworkingMamager.h"
#import "YW_ThingsModel.h"

#define HeaderViewHeight 44

#define ContactNormalBackgroudColor @"#EEEEEE"
#define ContactLabelNormalTextColor @"#AAAAAA"

#define ContactSelectBackgroudColor @"#AAAAAA"
#define ContactLabelSelectTextColor @"#FFFFFF"

typedef NS_ENUM(NSInteger, CurentShowThings){
    ShowNone = 1 << 0,
    ShowFavorite = 1 << 1,
    ShowCollections = 1 << 2,
    ShowThings = 1 << 3
};

static NSString *const currentTitle = @"Things";

@interface YW_ActivityRecentViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL isHideFavorite;
    BOOL isHideCollections;
    BOOL isHideThings;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** Activity Data List */
@property(strong, nonatomic) NSMutableDictionary *dataDict;

/** 选中的行列表 */
@property(strong, nonatomic) NSMutableArray *deleteArray;

/** HeaderTitles */
@property(strong, nonatomic) NSArray *headerTitleArr;

/** FavoriteArr */
@property(strong, nonatomic) NSArray *favoriteArr;

/** CollectionsArr */
@property(strong, nonatomic) NSMutableArray *collectionsArr;

/** ThingsArr */
@property(strong, nonatomic) NSMutableArray *thingsArr;

@end

@implementation YW_ActivityRecentViewController

#pragma mark - 懒加载
-(NSArray *)headerTitleArr
{
    if (!_headerTitleArr) {
        _headerTitleArr = [NSArray arrayWithObjects:@"Favorites", @"Collections", @"Things", nil];
    }
    return _headerTitleArr;
}

-(NSMutableArray *)collectionsArr
{
    if (!_collectionsArr) {
        _collectionsArr = [NSMutableArray array];
    }
    return _collectionsArr;
}

-(NSMutableArray *)thingsArr
{
    if (!_thingsArr) {
        _thingsArr = [NSMutableArray array];
    }
    return _thingsArr;
}

-(NSMutableDictionary *)dataDict
{
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < self.headerTitleArr.count; i++) {
            NSMutableArray *arr = [NSMutableArray array];
            int arrCount = arc4random_uniform(20);
            
            if (i == 0) {
                arrCount = 6;
                arr = [NSMutableArray arrayWithObjects:@"One Btn", @"Tow Btn", @"Three Btn", @"Four Btn", @"BLE Btn", @"Six Btn", nil];
            }else
            {
                for (int j = 0; j < arrCount; j++) {
                    [arr addObject:[NSString stringWithFormat:@"%@%.2d", _headerTitleArr[i], j]];
                }
            }
            
            [_dataDict addEntriesFromDictionary:@{_headerTitleArr[i]:arr}];
        }
    }
    return _dataDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isHideFavorite = YES;
    isHideCollections = YES;
    isHideThings = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YW_ActivityRecentTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self requestCollectionsData];
    [self requestThingsData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[YW_ActivityVCSingleton shareInstance] setLastVCTitle:currentTitle];
    [[YW_ActivityVCSingleton shareInstance] setThingsVC:(YW_NavigationController *)self.navigationController];   //进入到Things之后，记录一下
    [[YW_NaviSingleton shareInstance] setActivityNVC:(YW_NavigationController *)self.navigationController];
}

- (void)requestThingsData
{
    [YWNetworkingMamager postWithURLString:GetUserThingsURL parameters:@"" progress:nil success:^(NSDictionary *data) {
        NSArray *dataArr = (NSArray *)data;
        
        for (NSDictionary *dic in dataArr) {
            [self.thingsArr addObject:dic[@"Thing_Type"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)requestCollectionsData
{
    [YWNetworkingMamager postWithURLString:GetUserCollectionsURL parameters:@"" progress:nil success:^(NSDictionary *data) {
        NSArray *dataArr = (NSArray *)data;
        
        for (NSDictionary *dic in dataArr) {
            [self.collectionsArr addObject:dic[@"Collection_Name"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.headerTitleArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.dataDict[_headerTitleArr[section]];
    
    if (section == 0) {
        self.favoriteArr = !isHideFavorite?arr:[NSArray array];
        return self.favoriteArr.count;
    }else if (section == 1)
    {
        if (isHideCollections)
            return 0;
        else
            return self.collectionsArr.count;
    }else
    {
        if (isHideThings)
            return 0;
        else
            return self.thingsArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = self.dataDict[_headerTitleArr[indexPath.section]];
    
    switch (indexPath.section) {
        case 0:
            arr = self.favoriteArr;
            break;
        case 1:
            arr = self.collectionsArr;
            break;
        case 2:
            arr = self.thingsArr;
            break;
        default:
            break;
    }
    
    YW_ActivityRecentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    [cell configureWithAvatar:[UIImage imageNamed:@"login_bg"] title:arr[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWitdh, HeaderViewHeight)];
    
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchShowThings:)];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.tag = section + 100;
    titleLabel.userInteractionEnabled = YES;
    titleLabel.text = self.headerTitleArr[section];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel addGestureRecognizer:tapGestureRecognizer];
    
    switch (section) {
        case 0:
            headerView.backgroundColor = [UIColor colorWithHexString:isHideFavorite?ContactNormalBackgroudColor:ContactSelectBackgroudColor];
            titleLabel.textColor = [UIColor colorWithHexString:isHideFavorite?ContactLabelNormalTextColor:ContactLabelSelectTextColor];
            break;
        case 1:
            headerView.backgroundColor = [UIColor colorWithHexString:isHideCollections?ContactNormalBackgroudColor:ContactSelectBackgroudColor];
            titleLabel.textColor = [UIColor colorWithHexString:isHideCollections?ContactLabelNormalTextColor:ContactLabelSelectTextColor];
            break;
        case 2:
            headerView.backgroundColor = [UIColor colorWithHexString:isHideThings?ContactNormalBackgroudColor:ContactSelectBackgroudColor];
            titleLabel.textColor = [UIColor colorWithHexString:isHideThings?ContactLabelNormalTextColor:ContactLabelSelectTextColor];
        default:
            break;
    }
    
    [headerView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headerView.mas_leading);
        make.top.equalTo(headerView.mas_top);
        make.trailing.equalTo(headerView.mas_trailing);
        make.height.mas_equalTo(HeaderViewHeight);
    }];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeaderViewHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YW_ActivityRecentTableViewCell *cell = (YW_ActivityRecentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.tableView isEditing]) {
        [self.deleteArray addObject:indexPath];
    }else
    {
        if (indexPath.section == 0) {
            if ([self.delegate respondsToSelector:@selector(activityItemSelected: itemNum:)]) {
                [self.delegate activityItemSelected:cell.title itemNum:(int)indexPath.row];
            }
        }
        else if (indexPath.section == 1)
        {
            YW_ActivityCollectionViewController *collectionVC = [[YW_ActivityCollectionViewController alloc] init];
            collectionVC.collectionName = _collectionsArr[indexPath.row];
            [self.navigationController pushViewController:collectionVC animated:YES];
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(activityItemSelected:)]) {
                [self.delegate activityItemSelected:cell.title];
            }
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableView isEditing]) {
        [self.deleteArray removeObject:indexPath];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *collect = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Collect" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[SPUtil sharedInstance] showNotificationInViewController:self title:@"Collect Successful" subtitle:nil type:SPMessageNotificationTypeSuccess];
    }];
    collect.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *share = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Share" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[SPUtil sharedInstance] showNotificationInViewController:self title:@"Share Successful" subtitle:nil type:SPMessageNotificationTypeSuccess];
    }];
    share.backgroundColor = [UIColor purpleColor];
    return @[collect, share];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(void)switchShowThings:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UILabel *label = (UILabel *)tapGestureRecognizer.view;
    
    switch (label.tag) {
        case 100:
            isHideFavorite = !isHideFavorite;
            break;
        case 101:
            isHideCollections = !isHideCollections;
            break;
        case 102:
            isHideThings = !isHideThings;
            break;
        default:
            break;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:label.tag - 100] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)setEditing:(BOOL)editing cancle:(BOOL)cancle
{
    [self.tableView setEditing:editing animated:YES];
    
    if (editing) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.tableView.frame;
            frame.size.height -= EditBtnHeight;
            self.tableView.frame = frame;
        }];
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.tableView.frame;
            frame.size.height += EditBtnHeight;
            self.tableView.frame = frame;
        }];
    }
    
    if (cancle) {
        self.deleteArray = [NSMutableArray array];
        return;
    }
    
    NSArray *sortDeleteArray = [self.deleteArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSIndexPath *indexPath1 = (NSIndexPath *)obj1;
        NSIndexPath *indexPath2 = (NSIndexPath *)obj2;
        //因为满足sortedArrayUsingComparator方法的默认排序顺序，则不需要交换
        if (indexPath1.row > indexPath2.row)
            return NSOrderedAscending;
        return NSOrderedDescending;
    }];
    for (NSIndexPath *indexPath in sortDeleteArray) {
//        [_activityArray removeObjectAtIndex:indexPath.row];
    }
    [self.tableView deleteRowsAtIndexPaths:sortDeleteArray withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView reloadData];
//    self.deleteArray = [NSMutableArray array];
}

//- cre

@end
