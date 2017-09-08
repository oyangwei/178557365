//
//  YW_ActivityCreateCollectionViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/4.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_ActivityCreateCollectionViewController.h"
#import "YW_ActivityRecentTableViewCell.h"

@interface YW_ActivityCreateCollectionViewController () <UITableViewDelegate, UITableViewDataSource>

/** 群名 */
@property(strong, nonatomic) UITextField *collectionNameTextFiled;

/** Things列表 */
@property(strong, nonatomic) NSMutableArray *thingsArr;

/** 选中的Things列表 */
@property(strong, nonatomic) NSMutableArray *selectedThingsArr;

/** TableView */
@property(strong, nonatomic) UITableView *tableView;

@end

@implementation YW_ActivityCreateCollectionViewController

-(NSMutableArray *)thingsArr
{
    if (!_thingsArr) {
        _thingsArr = [NSMutableArray array];
        [self requestThingsData];
    }
    return _thingsArr;
}

-(NSMutableArray *)selectedThingsArr
{
    if (!_selectedThingsArr) {
        _selectedThingsArr = [NSMutableArray array];
    }
    return _selectedThingsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *collectionNameTextFiled = [[UITextField alloc] init];
    collectionNameTextFiled.placeholder = @"Collectcion Name";
    collectionNameTextFiled.font = [UIFont systemFontOfSize:18];
    collectionNameTextFiled.layer.borderWidth = 1;
    collectionNameTextFiled.layer.borderColor = [UIColor colorWithHexString:ThemeColor].CGColor;
    collectionNameTextFiled.contentMode = NSTextAlignmentCenter;
    
    self.collectionNameTextFiled = collectionNameTextFiled;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setEditing:YES];
    [tableView registerNib:[UINib nibWithNibName:@"YW_ActivityRecentTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.tableView = tableView;
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    confirmBtn.backgroundColor = [UIColor colorWithHexString:ThemeColor];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"OK" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:collectionNameTextFiled];
    [self.view addSubview:tableView];
    [self.view addSubview:confirmBtn];
    
    [collectionNameTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(44);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(200);
    }];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collectionNameTextFiled.mas_bottom).offset(10);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.bottom.equalTo(confirmBtn.mas_top).offset(-10);
    }];

}

- (void)requestThingsData
{
    [YWNetworkingMamager postWithURLString:GetUserThingsURL parameters:@"" progress:nil success:^(NSDictionary *data) {
        NSArray *dataArr = (NSArray *)data;
        
        for (NSDictionary *dic in dataArr) {
            [_thingsArr addObject:dic[@"Thing_Type"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)requestCreateCollection:(NSDictionary *)condition
{
    NSLog(@"condition--%@", condition);
    [YWNetworkingMamager postWithURLString:InsertMembersCollectionURL parameters:condition progress:nil success:^(NSDictionary *data) {
        NSLog(@"data--%@", data);
        
        int result = [data[@"result"] intValue];
        
        if (result == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if (result == 1006)
        {
            NSLog(@"Collections is exsit !");
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@", error);
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
    return 64;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedThingsArr addObject:self.thingsArr[indexPath.row]];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedThingsArr removeObject:self.thingsArr[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Selected Things";
}

-(void)confirmClick
{
    NSMutableDictionary *condition = [NSMutableDictionary dictionary];
    [condition addEntriesFromDictionary:@{@"Collection_Name":self.collectionNameTextFiled.text}];
    
    if (_selectedThingsArr.count > 0) {
        [condition addEntriesFromDictionary:@{@"Collection_Members":_selectedThingsArr}];
    }
    
    [self requestCreateCollection:condition];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.collectionNameTextFiled resignFirstResponder];
}

@end
