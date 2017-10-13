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
{
    int numService;
}
    
/** 刷新转动 */
@property(strong, nonatomic) UIActivityIndicatorView *refresh;

/** TableView */
@property(strong, nonatomic) UITableView *tableView;

/** DataArray */
@property(strong, nonatomic) NSMutableArray *dataArray;

/** centerManager 中心管理者 */
@property(strong, nonatomic) CBCentralManager *centerManager;
    
/** centerManager2 中心管理者 */
@property(strong, nonatomic) CBCentralManager *centerManager2;
    
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
    
/** 计时器 */
@property(strong, nonatomic) NSTimer *timer;

/** 当前时间 */
@property(assign, nonatomic) NSInteger currentSecond;
    
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
        
        [weakSelf.centerManager stopScan]; //停止扫描
        [weakSelf.refresh stopAnimating]; //停止刷新
        
        [weakSelf requestThingData:@{@"uuid":[weakSelf.peripheral.identifier.UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""]}];
        
        [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(60);
        }];
        
        [SVProgressHUD showSuccessWithStatus:@"Connected Success!"];
        
        YW_ThingPairTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.peripheralArray indexOfObject:weakSelf.peripheral] inSection:0]];
        [cell.pairBtn setTitle:@"Paired" forState:UIControlStateNormal];
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

- (void)createPeripheralManager
{
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:nil];
}
    
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    //在开发中，NS_ENUM可以直接用 == 号判断，NS_OPTIONS类型的枚举要用&(包含)判断
    if (peripheral.state == CBManagerStatePoweredOn) {
        
        CBMutableDescriptor *descriptor = [[CBMutableDescriptor alloc] initWithType:[CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString] value:@"TeleconMobile01"];
        
        // 创建特征（服务的特征）
        CBMutableCharacteristic *cha = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:@"FFE1"]
                                                                          properties:CBCharacteristicPropertyRead value:nil
                                                                         permissions:CBAttributePermissionsReadable];
        cha.descriptors = @[descriptor];
        numService = 0;
        [self.nServices removeAllObjects];
        for (int i = 0; i < self.receiveUUIDs.count; i++) {
            // 通常UUID都是由硬件工程师定义的
            CBUUID *serviceUUID = [CBUUID UUIDWithString:[self formatterUUID:self.receiveUUIDs[1]]];
            
            // 设置添加到外设中的服务
            CBMutableService *service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
            
            service.characteristics = @[cha];
            
            [self.nServices addObject:service];
            
            [self.peripheralManager addService:service];
        }
    }
    else
    {
        NSLog(@"not ON %ld", (long)peripheral.state);
    }
}

// 添加服务
-(void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    NSLog(@"%s, line = %d service = %@", __func__, __LINE__, service);
    
    if (error) {
        NSLog(@"error : %@", error);
        return;
    }
    
    numService ++;
    
    if (self.nServices.count == numService) {
        [peripheral startAdvertising:@{
                                       CBAdvertisementDataLocalNameKey : @"ManufacturerData",
                                       CBAdvertisementDataServiceUUIDsKey : [self.nServices valueForKey:@"UUID"]
                                       }];
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    if (error) {
        NSLog(@"error : %@", error);
    }

    NSLog(@"peripheral : %@", peripheral);
    
    self.currentSecond = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timepiece) userInfo:nil repeats:YES];
    
}
    
- (void)timepiece
{
    self.currentSecond ++;
    
    if (self.currentSecond == 60) {
        [self.peripheralManager stopAdvertising];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.centerManager2 = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        });
    }
}
    
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (central == self.centerManager) {
        //    if (![peripheral.identifier.UUIDString hasPrefix:@""]) {
        //        return;
        //    }
        
        if (![self.peripheralArray containsObject:peripheral]) {
            NSLog(@"%s, line = %d , peripheral:%@, RSSI:%@, advertisementData:%@", __func__, __LINE__, peripheral, RSSI, advertisementData);
            [self.peripheralArray addObject:peripheral];
            [self reloadData];
        }
    }else if (central == self.centerManager2)
    {
        
        if ([peripheral.identifier isEqual:_peripheral.identifier]) {
            NSLog(@"%s, line = %d , peripheral:%@, RSSI:%@, advertisementData:%@", __func__, __LINE__, peripheral, RSSI, advertisementData);
            
            [self writePairThingData:@{@"uuid":advertisementData[@"UUID"]}];
        }
    }
    
}
    
#pragma mark - 向服务器请求数据
-(void)requestThingData:(NSDictionary *)parameters
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];

    [manager POST:@"http://192.168.3.4/Module/Receiving_one.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        NSString *data = ((NSDictionary *)responseObject)[@"result"];
        NSString *newStr = [parameters[@"uuid"] substringToIndex:20];
        
        [self.receiveUUIDs removeAllObjects];
        
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createPeripheralManager];  //切换至外设模式
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%s, line = %d, error = %@", __func__, __LINE__, error);
    }];
}

#pragma mark - 向服务器写入配对成功的数据
-(void)writePairThingData:(NSDictionary *)condition
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];
    
    [manager POST:@"http://192.168.3.4/Module/Receiving_2.php" parameters:condition progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)                 {
        NSLog(@"%@", responseObject);
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
    
// 格式转换
-(NSString *)formatterUUID:(NSString *)uuid
{
    // 665544332211112233445566
    NSString *newUUID = [NSString string];
    for (int i = 0; i < [uuid length]; i ++) {
        newUUID = [newUUID stringByAppendingFormat:@"%c", [uuid characterAtIndex:i]];
        if (i == 7 || i == 11 || i == 15 || i == 19) {
            newUUID = [newUUID stringByAppendingFormat:@"-"];
        }
    }
    return newUUID;
}

@end
