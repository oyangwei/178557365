//
//  BLECenterManagerViewController.m
//  BLE
//
//  Created by YangWei on 2017/7/10.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#define MSA_SHORTHAND
#define MSA_SHORTHAND_GLOBALS

#import "BLECenterManagerViewController.h"
#import "Masonry.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "Advertise.h"
#import "AdvertiseTableViewCell.h"

#define buttonWidth 200
#define TabBarHeight [[UITabBarController alloc] init].tabBar.frame.size.height

@interface BLECenterManagerViewController () <CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property(strong, nonatomic) CBCentralManager *cMgr;
@property(strong, nonatomic) CBPeripheral *peripheral;
@property(strong, nonatomic) NSMutableArray *dataArray;

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) UIButton *btn01;
@property(strong, nonatomic) NSTimer *timer;
@property(assign, nonatomic) int leftSeconds;
@property(assign, nonatomic) CGFloat cellHeight;
@property(assign, nonatomic) BOOL isScan;
@property(assign, nonatomic) BOOL isScrolling;

@end

@implementation BLECenterManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    UIButton *btn01 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn01.userInteractionEnabled = YES;
    btn01.layer.cornerRadius = 10;
    btn01.tag = 101;
    [btn01 setTitle:@"Scan" forState:UIControlStateNormal];
    [btn01 setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:1.0]];
    [btn01 addTarget:self action:@selector(touchStart:) forControlEvents:UIControlEventTouchDown];
    
    self.tableView = tableView;
    self.btn01 = btn01;
    
    [self.view addSubview:tableView];
    [self.view addSubview:btn01];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(self.view.mas_top).offset(40);
        make.bottom.equalTo(self.view.mas_bottom).offset(- 120- TabBarHeight);
    }];
    
    [btn01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(buttonWidth);
        make.top.equalTo(self.tableView.mas_bottom).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20 - TabBarHeight);
    }];
    
}

/** 中心管理者 */
-(CBCentralManager *)cMgr
{
    if (!_cMgr) {
        _cMgr = [[CBCentralManager alloc] initWithDelegate:self
                                                     queue:dispatch_get_main_queue()
                                                   options:nil];
    }
    return _cMgr;
}

/** 扫描到的结果数组 */
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)touchStart:(id)sender
{
    if (!self.isScan) {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [self cMgr];
        [self.cMgr scanForPeripheralsWithServices:nil   //通过某些服务器筛选外设
                                          options:nil];
        
        self.leftSeconds = 10;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    }
    else
    {
        [self.cMgr stopScan];
        
        if ([self.timer isValid]) {
            [self.timer invalidate];
            self.timer = NULL;
        }
    }
    
    self.isScan = !self.isScan;
    [self.btn01 setTitle:self.isScan?[@"Stop" stringByAppendingString:[NSString stringWithFormat:@"%d", self.leftSeconds]]:@"Scan" forState:UIControlStateNormal];
}

-(void)timeDown
{
    self.leftSeconds--;
    if (self.leftSeconds == 0) {
        [self.cMgr stopScan];
        
        if ([self.timer isValid]) {
            [self.timer invalidate];
            self.timer = NULL;
        }
        
        self.isScan = !self.isScan;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
            [self.btn01 setTitle:self.isScan?[@"Stop" stringByAppendingString:[NSString stringWithFormat:@"%d", self.leftSeconds]]:@"Scan" forState:UIControlStateNormal];
            });
        });
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.btn01 setTitle:self.isScan?[@"Stop" stringByAppendingString:[NSString stringWithFormat:@"%d", self.leftSeconds]]:@"Scan" forState:UIControlStateNormal];
        });
    });
    
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"CBManagerStateUnknown");
            break;
        case CBManagerStateResetting:
            NSLog(@"CBManagerStateResetting");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"CBManagerStateUnsupported");
            
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"CBManagerStateUnauthorized");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"CBManagerStatePoweredOff");
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"CBManagerStatePoweredOn");
            
            //搜索外设
            [self.cMgr scanForPeripheralsWithServices:nil   //通过某些服务器筛选外设
                                              options:nil];  //dict,条件
            break;
            
        default:
            break;
    }
}

//扫描之后调用的方法
-(void)centralManager:(CBCentralManager *)central  //中心管理者
didDiscoverPeripheral:(CBPeripheral *)peripheral   //外设
    advertisementData:(NSDictionary<NSString *,id> *)advertisementData  //外设携带的数据
                 RSSI:(NSNumber *)RSSI  // 外设发出的蓝牙信号强度
{
    NSLog(@"central = %@, peripheral = %@, advertisementData = %@, RSSI = %@", central, peripheral, advertisementData, RSSI);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: advertisementData, @"packet", peripheral.name, @"name", RSSI, @"RSSI", nil];
        Advertise *ad = [Advertise instanceWithDictionary:dict];
        [self.dataArray addObject:ad];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height) animated:YES];
        });
    });
}

-(void)centralManager:(CBCentralManager *)central  //中心管理者
 didConnectPeripheral:(CBPeripheral *)peripheral   //外设
{
    NSLog(@"%s, line = %d, %@连接成功", __func__, __LINE__, peripheral);
    
    self.peripheral.delegate = self;
    
    [self.peripheral discoverServices:nil];
}

-(void)centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral
                error:(NSError *)error
{
    NSLog(@"%s, line = %d, %@连接失败", __func__, __LINE__, peripheral);
}

-(void)centralManager:(CBCentralManager *)central
didDisConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%s, line = %d, %@断开连接", __func__, __LINE__, peripheral);
}

//发现服务后调用
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(nullable NSError *)error
{
    if (error) {
        NSLog(@"%s, line = %d, error = %@", __func__, __LINE__, error.localizedDescription);
        return;
    }
    
    for (CBService *service in peripheral.services) {
        NSLog(@"%s, line = %d, service = %@", __func__, __LINE__, service);
        [self.peripheral discoverCharacteristics:nil forService:service];
    }
}

#pragma mark - 获取外设服务里的特征的时候调用的代理方法
-(void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
            error:(NSError *)error
{
    if (error) {
        NSLog(@"%s, line = %d, error = %@", __func__, __LINE__, error.localizedDescription);
        return;
    }
    
    for (CBCharacteristic *cha in service.characteristics) {
        //获取特征对应的描述
        [peripheral discoverDescriptorsForCharacteristic:cha];
        
        //获取特征的值
        [peripheral readValueForCharacteristic:cha];
    }
}

#pragma mark - 发现外设的特征的描述数组
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"%s, line = %d, error = %@", __func__, __LINE__, error.localizedDescription);
        return;
    }
    
    for (CBDescriptor *descriptor in characteristic.descriptors) {
        [peripheral readValueForDescriptor:descriptor];
        NSLog(@"%s, line = %d, descriptor = %@", __func__, __LINE__, descriptor);
    }
}

#pragma mark -  更新特征的描述的时候会调用此方法
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    if (error) {
        NSLog(@"%s, line = %d, error = %@", __func__, __LINE__, error.localizedDescription);
        return;
    }
    
    [peripheral readValueForDescriptor:descriptor];
}

#pragma mark - UITableViewDataSource
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
    AdvertiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"advertise"];
    if (cell == nil) {
        cell = [[AdvertiseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"advertise"];
    }
    
    cell.userInteractionEnabled = NO;
    [cell initWithModel:_dataArray[indexPath.row]];
    self.cellHeight = cell.cellHeight;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

@end
