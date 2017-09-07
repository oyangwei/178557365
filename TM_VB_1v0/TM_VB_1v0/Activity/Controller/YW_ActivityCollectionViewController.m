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
@property(strong, nonatomic) NSArray *collectionsArr;

@end

@implementation YW_ActivityCollectionViewController

#pragma mark - 懒加载
-(NSArray *)collectionsArr
{
    if (!_collectionsArr) {
        _collectionsArr = [NSArray arrayWithObjects:@"Things01", @"Things02", @"Things03", nil];
    }
    return _collectionsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YW_ActivityRecentTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectionsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YW_ActivityRecentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell configureWithAvatar:[UIImage imageNamed:@"login_bg"] title:_collectionsArr[indexPath.row]];
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
    return @"Collections";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
