//
//  YW_ActivityCollectionViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/1.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_ActivityCollectionViewController.h"
#import "YW_ActivityRecentTableViewCell.h"

#define HeaderViewHeight 44

@interface YW_ActivityCollectionViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** CollectionsArr */
@property(strong, nonatomic) NSMutableArray *thingsArr;

@end

@implementation YW_ActivityCollectionViewController

#pragma mark - 懒加载
-(NSMutableArray *)thingsArr
{
    if (!_thingsArr) {
        _thingsArr = [NSMutableArray array];
    }
    return _thingsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YW_ActivityRecentTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self requestThingsFromCollectionData];
}

- (void)requestThingsFromCollectionData
{
    NSDictionary *condition = [NSDictionary dictionaryWithObject:self.collectionName forKey:@"Collection_Name"];
    
    [YWNetworkingMamager postWithURLString:GetCollectionMembersURL parameters:condition progress:nil success:^(NSDictionary *data) {
        NSLog(@"%@", data);
        
        NSArray *dataArr = (NSArray *)data;
        
        for (NSDictionary *dic in dataArr) {
            [self.thingsArr addObject:dic[@"Status"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.thingsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YW_ActivityRecentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell configureWithAvatar:[UIImage imageNamed:@"login_bg"] title:_thingsArr[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeaderViewHeight;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.collectionName;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
