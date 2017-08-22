//
//  YW_ActivityThingsViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/8/9.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_ActivityThingsViewController.h"
#import "YW_ActivityThingsTableViewCell.h"
#import "SPUtil.h"

@interface YW_ActivityThingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** Activity Data List */
@property(strong, nonatomic) NSMutableArray *activityArray;

/** 选中的行列表 */
@property(strong, nonatomic) NSMutableArray *deleteArray;

@end

@implementation YW_ActivityThingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YW_ActivityThingsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}

#pragma mark - 懒加载Activity Data List
-(NSMutableArray *)activityArray
{
    if (!_activityArray) {
        _activityArray = [NSMutableArray array];
        for (int i = 1; i <= 50; i++) {
            [_activityArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _activityArray;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.activityArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YW_ActivityThingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    [cell configureWithAvatar:[UIImage imageNamed:@"login_bg"] title:_activityArray[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableView isEditing]) {
        [self.deleteArray addObject:indexPath];
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
        [_activityArray removeObjectAtIndex:indexPath.row];
    }
    [self.tableView deleteRowsAtIndexPaths:sortDeleteArray withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView reloadData];
//    self.deleteArray = [NSMutableArray array];
}

@end
