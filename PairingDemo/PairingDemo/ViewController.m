//
//  ViewController.m
//  PairingDemo
//
//  Created by Oyw on 2017/10/9.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <AFNetworking.h>
#import <Masonry.h>
#import "YW_PairCellModel.h"
#import "YW_ThingPairTableViewCell.h"
#import <SVProgressHUD.h>

#define UUIDPrefix @"FD72D491-8174-4067-B64C-ACACF1"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate>
    
/** 刷新转动 */
@property(strong, nonatomic) UIActivityIndicatorView *refresh;

/** TableView */
@property(strong, nonatomic) UITableView *tableView;

/** DataArray */
@property(strong, nonatomic) NSMutableArray *dataArray;

/** centerManager 中心管理者 */
@property(strong, nonatomic) CBCentralManager *centerManager;
    
/** peripheralManager 外设模式 */
@property(strong, nonatomic) CBPeripheralManager *peripheralManager;

/** peripheral 外设 */
@property(strong, nonatomic) CBPeripheral *peripheral;

/** 存放外设的表 */
@property(strong, nonatomic) NSMutableArray *peripheralArray;

/** 存放Service的表 */
@property(strong, nonatomic) NSMutableArray *nServices;

/** 存放Characterics的表 */
@property(strong, nonatomic) NSMutableArray *nCharacterics;

/** 扫描按钮 */
@property(strong, nonatomic) UIButton *scanBtn;
    
/** ReceiveData */
@property(strong, nonatomic) NSMutableArray *receiveUUIDs;
    
/** writeCharacteristic 写入的特征 */
@property(strong, nonatomic) CBCharacteristic *writeCharacteristic;

@end

@implementation ViewController

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
    
-(NSMutableArray *)receiveUUIDs
{
    if (!_receiveUUIDs) {
        _receiveUUIDs = [NSMutableArray array];
    }
    return _receiveUUIDs;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *scanBtn = [[UIButton alloc] init];
    scanBtn.backgroundColor = [UIColor blueColor];
    [scanBtn setTitle:@"Scan" forState:UIControlStateNormal];
    [scanBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [scanBtn addTarget:self action:@selector(scanClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.scanBtn = scanBtn;
    
    [self.view addSubview:scanBtn];
    
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
}

- (void)scanClick:(UIButton *)button
{
    button.hidden = YES;
    /** 中心管理者 */
    self.centerManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    UIActivityIndicatorView *refresh = [[UIActivityIndicatorView alloc] init];
    refresh.color = [UIColor grayColor];
    [refresh startAnimating];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"YW_ThingPairTableViewCell" bundle:nil] forCellReuseIdentifier:@"thingPairCell"];
    
    self.refresh = refresh;
    self.tableView = tableView;
    
    [self.view addSubview:refresh];
    [self.view addSubview:tableView];
    
    [refresh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(refresh.mas_bottom);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}
    
-(void)reloadData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    self.dataArray = [NSMutableArray array];
    for (int i = 0; i < self.peripheralArray.count; i++) {
        [dic addEntriesFromDictionary:@{@"ThingType":[NSString stringWithFormat:@"ThingType%.2d", i]}];
        [dic addEntriesFromDictionary:@{@"ProductInfo":[NSString stringWithFormat:@"ProductInfo%.2d", i]}];
        [dic addEntriesFromDictionary:@{@"uuid":((CBPeripheral *)self.peripheralArray[i]).identifier.UUIDString}];
        
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
        case CBManagerStateResetting :
        case CBManagerStateUnsupported :
        case CBManagerStateUnauthorized :
        case CBManagerStatePoweredOff :
        {
            NSLog(@"蓝牙出错");
            break;
        }
        case CBManagerStatePoweredOn :
        {
            [self.centerManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@NO}];
            
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
    
//    if (![peripheral.identifier.UUIDString hasPrefix:@""]) {
//        return;
//    }
    
    if (![self.peripheralArray containsObject:peripheral]) {
        NSLog(@"%s, line = %d , peripheral:%@, RSSI:%@, advertisementData:%@", __func__, __LINE__, peripheral, RSSI, advertisementData);
        [self.peripheralArray addObject:peripheral];
        [self reloadData];
    }
    
}
    
/** 连接外设后调用 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%s, line = %d , peripheral:%@, UUID:%@", __func__, __LINE__, peripheral, peripheral.identifier);
    
    [self.centerManager stopScan]; //停止扫描
    [self.refresh stopAnimating]; //停止刷新
    
    [self requestThingData:@{@"uuid":[peripheral.identifier.UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""]}];
    
    [self.peripheral setDelegate:self];
    [self.peripheral discoverServices:nil];  //扫描服务
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(60);
    }];
    
    [SVProgressHUD showSuccessWithStatus:@"Connected Success!"];
    
    YW_ThingPairTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.peripheralArray indexOfObject:peripheral] inSection:0]];
    [cell.pairBtn setTitle:@"Paired" forState:UIControlStateNormal];
}
    
/** 连接外设失败 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    YW_ThingPairTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.peripheralArray indexOfObject:peripheral] inSection:0]];
    [cell.pairBtn setTitle:@"Pair" forState:UIControlStateNormal];
}
    
/** 外设信号强度变化时 */
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
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
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
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
    NSLog(@"%s, line = %d, characteristic = %@", __func__, __LINE__, characteristic);
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"%s, line = %d, characteristic = %@", __func__, __LINE__, characteristic);
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"%s, line = %d, characteristic = %@", __func__, __LINE__, characteristic);
}

-(void)writeDataToPeripheral
{
    if (_peripheral.state == CBPeripheralStateConnected) {
        for (CBCharacteristic *c in self.nCharacterics) {
            if ([c.UUID isEqual:[CBUUID UUIDWithString:@"FF01"]]) {
                int i = 0;
                while (i < 6) {  //发送6次
                    [_peripheral writeValue:[self hexString:self.receiveUUIDs[1]] forCharacteristic:c type:CBCharacteristicWriteWithResponse];
                    i++;
                }
            }else if ([c.UUID isEqual:[CBUUID UUIDWithString:@"FF02"]]) {
                int i = 0;
                while (i < 6) {  //发送6次
                    [_peripheral writeValue:[self hexString:self.receiveUUIDs[2]] forCharacteristic:c type:CBCharacteristicWriteWithResponse];
                    i++;
                }
            }else if ([c.UUID isEqual:[CBUUID UUIDWithString:@"FF03"]]) {
                int i = 0;
                while (i < 6) {  //发送6次
                    [_peripheral writeValue:[self hexString:self.receiveUUIDs[3]] forCharacteristic:c type:CBCharacteristicWriteWithResponse];
                    i++;
                }
            }else if ([c.UUID isEqual:[CBUUID UUIDWithString:@"FF04"]]) {
                int i = 0;
                while (i < 6) {  //发送6次
                    [_peripheral writeValue:[self hexString:self.receiveUUIDs[4]] forCharacteristic:c type:CBCharacteristicWriteWithResponse];
                    i++;
                }
            }
        }
    }
}
    
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        [self writeCharacteristic];   //  写入失败之后，重新尝试写入，直到成功
    }
    NSLog(@"%s, line = %d, characteristic = %@", __func__, __LINE__, characteristic);
    
    [peripheral readValueForCharacteristic:characteristic];
}
    
#pragma mark - 向服务器请求数据
-(void)requestThingData:(NSDictionary *)parameters
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];

    [manager POST:@"http://192.168.3.4/Module/Receiving_1.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        NSString *data = ((NSDictionary *)responseObject)[@"result"];
        NSString *newStr = [parameters[@"uuid"] substringToIndex:20];
        
        NSLog(@"%lu", (unsigned long)[data length]);
        
        for (int i = 0; i < [data length]; i++) {
            unichar ch = [data characterAtIndex:i];
            
            int index = i / 6;
            
            if (i % 6 == 0) {
               newStr = [newStr stringByAppendingFormat:@"00000%d%c", index + 1, ch]; // 当i = 0时，D1拼接000001，依此类推；
            }else
            {
                newStr = [newStr stringByAppendingFormat:@"%c", ch];
                if (i % 6 == 5) {
                    [self.receiveUUIDs addObject:newStr];  // 将接收到的UUID处理后，添加到数组中
                    newStr = [parameters[@"uuid"] substringToIndex:20];  // 重置newStr
                }
            }
        }
        [self writeDataToPeripheral];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%s, line = %d, error = %@", __func__, __LINE__, error);
    }];
}

#pragma mark - 向服务器写入配对成功的数据
-(void)writePairThingData:(NSDictionary *)condition withPeripheral:(CBPeripheral *)peripheral
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];
    
    [manager POST:@"http://192.168.3.4/Module/Receiving_2.php" parameters:condition progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)                 {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%s, line = %d, error = %@", __func__, __LINE__, error);
    }];
}
    
-(NSData *)hexString:(NSString *)hexString
{
    int j = 0;
    Byte byte[20];
    
    for (int i = 0; i < [hexString length]; i++) {
        int int_ch;
        
        if ([hexString characterAtIndex:i] == '-') {
            i++;
        }
        unichar hex_char1 = [hexString characterAtIndex:i];
        int int_ch1;
        if (hex_char1 >= '0' && hex_char1 <= '9') {
            int_ch1 = 16 * (hex_char1 - 48);
        }else if(hex_char1 >= 'A' && hex_char1 <= 'F'){
            int_ch1 = (hex_char1 - 65) * 16;
        }else{
            int_ch1 = (hex_char1 - 97) * 16;
        }
        i++;
        
        if ([hexString characterAtIndex:i] == '-') {
            i++;
        }
        unichar hex_char2 = [hexString characterAtIndex:i];
        int int_ch2;
        if (hex_char2 >= '0' && hex_char2 <= '9') {
            int_ch2 = hex_char2 - 48;
        }else if(hex_char2 >= 'A' && hex_char2 <= 'F'){
            int_ch2 = hex_char2 - 65;
        }else{
            int_ch2 = hex_char2 - 97;
        }
        
        int_ch = int_ch1 + int_ch2;
        NSLog(@"%d", int_ch);
        byte[j] = int_ch;
        j++;
    }
    NSData *data = [NSData dataWithBytes:byte length:20];
    return data;
}

@end
