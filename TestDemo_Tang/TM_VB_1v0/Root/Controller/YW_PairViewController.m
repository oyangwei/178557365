//
//  YW_PairViewController.m
//  TestDemo_Tang
//
//  Created by Oyw on 2017/10/16.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_PairViewController.h"
#import "MJRefresh.h"
#import "YW_PairTableViewCell.h"
#import "YW_PairConfirmView.h"
#import "YW_ThingsModel.h"
#import "YW_ThingsSingleTon.h"

@interface YW_PairViewController () <UITableViewDelegate, UITableViewDataSource>

/** TableView */
@property(strong, nonatomic) UITableView *tableView;

/** AlertUIWindow */
@property(strong, nonatomic) UIWindow *alertWindow;

/** YW_PairConfirmView */
@property(strong, nonatomic) YW_PairConfirmView *confirmView;

/** PairThingsData */
@property(strong, nonatomic) NSMutableArray *pairThings;

@end

@implementation YW_PairViewController

-(NSMutableArray *)pairThings
{
    if (!_pairThings) {
        _pairThings = [NSMutableArray array];
    }
    return _pairThings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 64;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YW_PairTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"PairCell"];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    
    // 设置文字
    [header setTitle:@"Pull down to scan" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to scan" forState:MJRefreshStatePulling];
    [header setTitle:@"Scaning ..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor colorWithHexString:ThemeColor];
    
    tableView.mj_header = header;
    
    [tableView.mj_header beginRefreshing];
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

-(void)setupNav
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:ThemeColor]];
}

-(void)reloadData
{
    self.pairThings = [NSMutableArray array];
    
    __block typeof(CGFloat) scanTime = 0;
    __block typeof(CGFloat) intervalTime = 1;
    
    [NSTimer scheduledTimerWithTimeInterval:intervalTime repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"scanTime : %lf", scanTime);
        if (scanTime >= 2.0) {
            [timer invalidate];
            timer = nil;
            [self.tableView.mj_header endRefreshing];
            return;
        }
        scanTime += intervalTime;
        for (int i = 0; i < arc4random_uniform(0) + 1; i++) {
            YW_ThingsModel *model = [YW_ThingsModel thingsModel:@{@"Icon":@"sofa", @"Name":[NSString stringWithFormat:@"Sofa%.3d", arc4random_uniform(100)]}];
            [self.pairThings addObject:model];
        }
        [self.tableView reloadData];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pairThings.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YW_PairTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PairCell"];
    YW_ThingsModel *model = self.pairThings[indexPath.row];
    cell.nameLabel.text = model.productName;
    __weak typeof(self) weakSelf = self;
    __block typeof(YW_PairTableViewCell *) weakCell = cell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.pairBlock = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakCell setPairStat:NO];
            [weakSelf alertPairConfirmView:(int)indexPath.row];
        });
    };
    return cell;
}

-(void)alertPairConfirmView:(int)row
{
    NSLog(@"%s, line = %d", __func__, __LINE__);
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow = window;
    window.backgroundColor = [UIColor clearColor];
    window.windowLevel = UIWindowLevelAlert;
    window.hidden = NO;
    
    UIView *bgView = [[UIView alloc] initWithFrame:window.frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.3;
    [window addSubview:bgView];
    
    __weak typeof(NSMutableArray *) thingsArr = [YW_ThingsSingleTon shareInstance].thingsArray;
    __weak typeof(YW_ThingsModel *) model = self.pairThings[row];
    
    YW_PairConfirmView *confirmView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YW_PairConfirmView class]) owner:self options:nil] lastObject];
    confirmView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height/ 2 - 80);
    confirmView.modelNoLabel.text = model.productName;
    [confirmView.renameTextFiled becomeFirstResponder];
    self.confirmView = confirmView;
    __weak typeof(self) weakSelf = self;
    __block typeof(YW_PairConfirmView *) weakConfirmView = confirmView;
    confirmView.confirmBlock = ^{
        NSString *newModelNo;
        if (![weakConfirmView.renameTextFiled.text isEqualToString:@""]) {
            newModelNo = weakConfirmView.renameTextFiled.text;
        }else
        {
            newModelNo = weakConfirmView.modelNoLabel.text;
        }
        
        weakSelf.alertWindow.hidden = YES;
        model.productName = newModelNo;
        
        [thingsArr addObject:model];
        [[YW_ThingsSingleTon shareInstance] setThingsArray:thingsArr];
        [weakConfirmView.renameTextFiled resignFirstResponder];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [UIView animateWithDuration:0.5 animations:^{
        [window addSubview:confirmView];
    } ];
}

@end

