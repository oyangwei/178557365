//
//  YW_AddThingsViewController.m
//  TM_VB_1v0
//
//  Created by Oyw on 2017/9/13.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_AddThingsViewController.h"
#import "YW_PairCellModel.h"
#import "YW_ThingPairTableViewCell.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface YW_AddThingsViewController () <UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate>

/** 刷新转动 */
@property(strong, nonatomic) UIActivityIndicatorView *refresh;

/** TableView */
@property(strong, nonatomic) UITableView *tableView;

/** DataArray */
@property(strong, nonatomic) NSMutableArray *dataArray;

/** centerManager 中心管理者 */
@property(strong, nonatomic) CBCentralManager *centerManager;

/** peripheral 外设 */
@property(strong, nonatomic) CBPeripheral *peripheral;

/** 存放外设的表 */
@property(strong, nonatomic) NSMutableArray *peripheralArray;

/** 存放Service的表 */
@property(strong, nonatomic) NSMutableArray *nServices;

/** 存放Characterics的表 */
@property(strong, nonatomic) NSMutableArray *nCharacterics;

/** writeCharacteristic 写入的特征 */
@property(strong, nonatomic) CBCharacteristic *writeCharacteristic;

@end

@implementation YW_AddThingsViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)peripheralArray
{
    if (!_peripheralArray) {
        _peripheralArray = [NSMutableArray array];
    }
    return _peripheralArray;
}

-(NSMutableArray *)nServices
{
    if (!_nServices) {
        _nServices = [NSMutableArray array];
    }
    return _nServices;
}

-(NSMutableArray *)nCharacterics
{
    if (!_nCharacterics) {
        _nCharacterics = [NSMutableArray array];
    }
    return _nCharacterics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    
    /** 中心管理者 */
    self.centerManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"YW_ThingPairTableViewCell" bundle:nil] forCellReuseIdentifier:@"thingPairCell"];
    
    self.tableView = tableView;
    
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refresh.mas_bottom);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self reloadData];
}

-(void)reloadData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i = 0; i <= 10; i++) {
        [dic addEntriesFromDictionary:@{@"ThingType":[NSString stringWithFormat:@"ThingType%.2d", i]}];
        [dic addEntriesFromDictionary:@{@"ProductInfo":[NSString stringWithFormat:@"ProductInfo%.2d", i]}];
        
        [self.dataArray addObject:[YW_PairCellModel initWithDict:dic]];
    }
    
    [self.tableView reloadData];
    
    
}

#pragma mark - UITableViewDelegate、UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YW_ThingPairTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thingPairCell"];
    [cell setPairCellValue:self.dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak typeof(self) weakSelf = self;
    cell.pairPeripheralBlock = ^{
        weakSelf.peripheral = weakSelf.peripheralArray[indexPath.row];
        [weakSelf.centerManager connectPeripheral:weakSelf.peripheral options:nil];
    };
    return cell;
}

#pragma mark - CBCentralManagerDelegate
/** 蓝牙状态改变时调用 */
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStateUnknown :
            [self alertMsg:@"Unknown" confimBlock:nil];
            break;
            
        case CBManagerStateResetting :
            [self alertMsg:@"Resetting" confimBlock:nil];
            break;
            
        case CBManagerStateUnsupported :
            [self alertMsg:@"Unsupported" confimBlock:nil];
            break;
            
        case CBManagerStateUnauthorized :
            [self alertMsg:@"Unauthorized" confimBlock:nil];
            break;
            
        case CBManagerStatePoweredOff :
            [self alertMsg:@"PoweredOff" confimBlock:nil];
            break;
            
        case CBManagerStatePoweredOn :
        {
            [self alertMsg:@"PoweredOn" confimBlock:nil];
            
            UIActivityIndicatorView *refresh = [[UIActivityIndicatorView alloc] init];
            [refresh startAnimating];
            
            [self.centerManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
            self.refresh = refresh;
            
            [self.view addSubview:refresh];
            
            [refresh mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top).offset(0);
                make.centerX.equalTo(self.view.mas_centerX);
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(60);
            }];
            
            break;
        }
        default:
            break;
    }
}

/** 扫描外设时调用 */
-(void)centralManager:(CBCentralManager *)central
didDiscoverPeripheral:(CBPeripheral *)peripheral
    advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                 RSSI:(NSNumber *)RSSI
{
    NSLog(@"%s, line = %d , peripheral:%@, RSSI:%@, advertisementData:%@", __func__, __LINE__, peripheral, RSSI, advertisementData);
    
    NSString *Thing_ID = advertisementData[@"Thing_ID"];
    NSString *M_ID = advertisementData[@"M_ID"];
    
    [self requestThingData:@{@"M_ID":M_ID, @"Thing_ID":Thing_ID} withPeripheral:peripheral];   //每扫描一个外设，即向服务器查询一次
    
    // [self.centerManager connectPeripheral:peripheral options:nil];   //连接外设
}

/** 连接外设后调用 */
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%s, line = %d , peripheral:%@, UUID:%@", __func__, __LINE__, peripheral, peripheral.identifier);
    
    [self.peripheral setDelegate:self];
    [self.peripheral discoverServices:nil];
    [self.centerManager stopScan];
    [self.refresh stopAnimating];
    
    NSLog(@"扫描服务");
}

/** 连接外设失败 */
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@", error);
}

/** 外设信号强度变化时 */
-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    /**
     * 计算公式：
     *    d = 10^((abs(RSSI) - A) / (10 * n))
     * 其中：
     *    d - 计算所得距离
     *    RSSI - 接收信号强度（负值）
     *    A - 发射端和接收端相隔1米时的信号强度
     *    n - 环境衰减因子
     */
    NSLog(@"%s, line = %d, 可根据RSSI计算出蓝牙设备和手机的距离", __func__, __LINE__);
}

/** 发现外设服务时调用 */
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    for (CBService *service in peripheral.services) {
        [self.nServices addObject:service];
    }
    
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

/** 根据服务搜索特征 */
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *c in service.characteristics) {
        [self.nCharacterics addObject:c];
    }
}

/** 获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取 */
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{

}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{

}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

#pragma mark - 向服务器请求数据
-(void)requestThingData:(NSDictionary *)condition withPeripheral:(CBPeripheral *)peripheral
{
    
    [YWNetworkingMamager postWithURLString:@"" parameters:condition progress:nil success:^(NSDictionary *data) {
        if (![data[@"Reg_Contact_ID"] isEqualToString:@""]) {
            [self.peripheralArray addObject:peripheral];     //成功则表明该外设没有被配对过，可以添加到peripheralArray中。
        }
    } failure:^(NSError *error) {
        NSLog(@"%s, line = %d, error = %@", __func__, __LINE__, error);
    }];
}

#pragma mark - 向服务器写入配对成功的数据
-(void)writePairThingData:(NSDictionary *)condition withPeripheral:(CBPeripheral *)peripheral
{
    [YWNetworkingMamager postWithURLString:@"" parameters:condition progress:nil success:^(NSDictionary *data) {
        
    } failure:^(NSError *error) {
        NSLog(@"%s, line = %d, error = %@", __func__, __LINE__, error);
    }];
}

@end
