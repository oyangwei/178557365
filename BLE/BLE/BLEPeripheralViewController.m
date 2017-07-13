//
//  ViewController.m
//  BLE
//
//  Created by YangWei on 2017/7/10.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#define MSA_SHORTHAND
#define MSA_SHORTHAND_GLOBALS

#import "BLEPeripheralViewController.h"
#import "Masonry.h"
#import <CoreBluetooth/CoreBluetooth.h>
#include "BLESettingViewController.h"

#define buttonWidth 130
#define TabBarHeight [[UITabBarController alloc] init].tabBar.frame.size.height

static NSString *const Service1StrUUID = @"856f5555-8064-43e9-8b7e-d04c5a9d6a9a";
static NSString *const Service2StrUUID = @"856f5555-8064-43e9-8b7e-d04c5a9d6b9b";
static NSString *const Service3StrUUID = @"856f5555-8064-43e9-8b7e-d04c5a9d6c9c";
static NSString *const Service4StrUUID = @"856f5555-8064-43e9-8b7e-d04c5a9d6d9d";

static NSString *const notifyCharacticStrUUID = @"FFF1";
static NSString *const readWriteCharacticStrUUID = @"FFF2";
static NSString *const readCharacticStrUUID = @"FFE1";

static NSString *const LocalNameKey1 = @"Oyw01";
static NSString *const LocalNameKey2 = @"Oyw02";
static NSString *const LocalNameKey3 = @"Oyw03";
static NSString *const LocalNameKey4 = @"Oyw04";

@interface BLEPeripheralViewController ()<CBPeripheralManagerDelegate>

@property(strong, nonatomic) NSUserDefaults *userDefault;

@property(strong, nonatomic) CBPeripheralManager *pMgr;
@property(strong, nonatomic) NSMutableArray *services;
@property(strong, nonatomic) NSString *localNameKey;

@property(strong, nonatomic) UIButton *settingBtn;
@property(strong, nonatomic) UIButton *btn01;
@property(strong, nonatomic) UIButton *btn02;
@property(strong, nonatomic) UIButton *btn03;
@property(strong, nonatomic) UIButton *btn04;
@property(strong, nonatomic) NSTimer *timer;
@property(assign, nonatomic) int numOfServices;

@end

@implementation BLEPeripheralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDefault = [NSUserDefaults standardUserDefaults];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [settingBtn setTitle:@"Setting" forState:UIControlStateNormal];
    settingBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    settingBtn.layer.borderColor = [UIColor blueColor].CGColor;
    settingBtn.layer.borderWidth = 1.0;
    settingBtn.layer.cornerRadius = 3;
    [settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchDown];
    
    UIButton *btn01 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn01.userInteractionEnabled = YES;
    btn01.layer.cornerRadius = buttonWidth / 2;
    btn01.tag = 101;
    [btn01 setTitle:@"Btn01" forState:UIControlStateNormal];
    [btn01 setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:1.0]];
    [btn01 addTarget:self action:@selector(touchStart:) forControlEvents:UIControlEventTouchDown];
    [btn01 addTarget:self action:@selector(touchEnd:) forControlEvents:UIControlEventTouchUpInside];
    [btn01 addTarget:self action:@selector(touchEnd:) forControlEvents:UIControlEventTouchUpOutside];
    
    UIButton *btn02 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn02.layer.cornerRadius = buttonWidth / 2;
    btn02.tag = 102;
    [btn02 setTitle:@"Btn02" forState:UIControlStateNormal];
    [btn02 setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:1.0]];
    [btn02 addTarget:self action:@selector(touchStart:) forControlEvents:UIControlEventTouchDown];
    [btn02 addTarget:self action:@selector(touchEnd:) forControlEvents:UIControlEventTouchUpInside];
    [btn02 addTarget:self action:@selector(touchEnd:) forControlEvents:UIControlEventTouchUpOutside];
    
    UIButton *btn03 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn03.layer.cornerRadius = buttonWidth / 2;
    btn03.tag = 103;
    [btn03 setTitle:@"Btn03" forState:UIControlStateNormal];
    [btn03 setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:1.0]];
    [btn03 addTarget:self action:@selector(touchStart:) forControlEvents:UIControlEventTouchDown];
    [btn03 addTarget:self action:@selector(touchEnd:) forControlEvents:UIControlEventTouchUpInside];
    [btn03 addTarget:self action:@selector(touchEnd:) forControlEvents:UIControlEventTouchUpOutside];
    
    UIButton *btn04 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn04.layer.cornerRadius = buttonWidth / 2;
    btn04.tag = 104;
    [btn04 setTitle:@"Btn04" forState:UIControlStateNormal];
    [btn04 setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:1.0]];
    [btn04 addTarget:self action:@selector(touchStart:) forControlEvents:UIControlEventTouchDown];
    [btn04 addTarget:self action:@selector(touchEnd:) forControlEvents:UIControlEventTouchUpInside];
    [btn04 addTarget:self action:@selector(touchEnd:) forControlEvents:UIControlEventTouchUpOutside];
    
    self.settingBtn = settingBtn;
    self.btn01 = btn01;
    self.btn02 = btn02;
    self.btn03 = btn03;
    self.btn04 = btn04;
    
    [self.view addSubview:settingBtn];
    [self.view addSubview:btn01];
    [self.view addSubview:btn02];
    [self.view addSubview:btn03];
    [self.view addSubview:btn04];
    
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_trailing).offset(-20);
        make.top.equalTo(self.view.mas_top).offset(30);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(44);
    }];
    
    [btn01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset(- buttonWidth / 2 - 10);
        make.centerX.equalTo(self.view.mas_centerX).offset(- buttonWidth / 2 - 10);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(buttonWidth);
    }];
    
    [btn02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset(- buttonWidth / 2 - 10);
        make.centerX.equalTo(self.view.mas_centerX).offset( buttonWidth / 2 + 10);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(buttonWidth);
    }];
    
    [btn03 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset( buttonWidth / 2 + 10);
        make.centerX.equalTo(self.view.mas_centerX).offset(- buttonWidth / 2 - 10);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(buttonWidth);
    }];
    
    [btn04 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset( buttonWidth / 2 + 10);
        make.centerX.equalTo(self.view.mas_centerX).offset( buttonWidth / 2 + 10);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(buttonWidth);
    }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}


-(CBPeripheralManager *)pMgr
{
    if (!_pMgr) {
        _pMgr = [[CBPeripheralManager alloc] initWithDelegate:self
                                                        queue:dispatch_get_main_queue()
                                                      options:nil];
    }
    return _pMgr;
}

-(NSMutableArray *)services
{
    if (!_services) {
        _services = [NSMutableArray array];
    }
    return _services;
}

#pragma mark - 实现CBPeripheralManagerDelegate方法
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    //在开发中，NS_ENUM可以直接用 == 号判断，NS_OPTIONS类型的枚举要用&(包含)判断
    if (peripheral.state == CBManagerStatePoweredOn) {
        // if peripheral.state is on, then doing other operation
        NSLog(@"%s, line = %d", __func__, __LINE__);
    }
    else
    {
        NSLog(@"not ON %ld", (long)peripheral.state);
    }
}

#pragma mark - 添加服务进CBPeripheralManager时会触发的方法
-(void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    // 每添加一次服务，方法调用一次
    if (!error) {
        self.numOfServices++;
    }
    
    if (self.numOfServices == self.services.count) {
        //广播内容
        NSDictionary *advertDict = @{CBAdvertisementDataServiceUUIDsKey : [self.services valueForKey:@"UUID" ],
                                     CBAdvertisementDataLocalNameKey:self.localNameKey};
        NSLog(@"%s, line = %d, %@", __func__, __LINE__, advertDict);
        [peripheral startAdvertising:advertDict];
    }
}

#pragma mark - 开始广播出发的代理
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(nullable NSError *)error
{
    NSLog(@"%s, line = %d", __func__, __LINE__);
}

#pragma mark - 外设收到读的请求后，然后根据读特征的值赋值给request
-(void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
    //判断是否可读
    if (request.characteristic.properties & CBCharacteristicPropertyRead) {
        NSData *data = request.characteristic.value;
        request.value = data;
        
        //对请求成功做出响应
        [self.pMgr respondToRequest:request withResult:CBATTErrorSuccess];
    }
    else
    {
        [self.pMgr respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
    }
}

#pragma mark - 外设收到写的请求后，然后读request的值，写给特征
-(void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests
{
    NSLog(@"%s, line = %d", __func__, __LINE__);
    CBATTRequest *request = requests.firstObject;
    //判断是否可写
    if (request.characteristic.properties == CBCharacteristicPropertyRead) {
        NSData *data = request.value;
        //此处赋值要转类型，否则报错
        CBMutableCharacteristic *mChar = (CBMutableCharacteristic *)request.characteristic;
        mChar.value = data;
        //对请求成功做出响应
        [self.pMgr respondToRequest:request withResult:CBATTErrorSuccess];
    }
    else
    {
        [self.pMgr respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
    }
}

- (void)touchStart:(id)sender
{
    NSLog(@"%s, line = %d", __func__, __LINE__);
    UIButton *btn = (UIButton *)sender;
    NSDictionary *dic = @{@"tag":[NSString stringWithFormat:@"%ld", (long)btn.tag]};
    self.timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(sendMsg) userInfo:dic repeats:YES];
    
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)touchEnd:(id)sender
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    UIButton *btn = (UIButton *)sender;
    [UIView animateWithDuration:0.5 animations:^{
        btn.alpha = 1.0;
    }];
    [self.pMgr stopAdvertising];
    NSLog(@"%s, line = %d", __func__, __LINE__);
}

- (void)sendMsg
{
    self.numOfServices = 0;
    [self.services removeAllObjects];
    int tag = [self.timer.userInfo[@"tag"] intValue];
    NSLog(@"%s, line = %d, tag = %d", __func__, __LINE__, tag);
    UIButton *btn = [self.view viewWithTag:tag];
    [UIView animateWithDuration:0.5 animations:^{
        btn.alpha = 0.5;
    }];
    // 创建特征的描述
    CBMutableDescriptor *descriptor = [[CBMutableDescriptor alloc] initWithType:[CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString] value:@"TeleconMobile01"];
    
    // 创建特征（服务的特征）
    CBMutableCharacteristic *cha = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:readCharacticStrUUID]
                                                                      properties:CBCharacteristicPropertyRead value:nil
                                                                     permissions:CBAttributePermissionsReadable];
    cha.descriptors = @[descriptor];
    
    switch (tag) {
        case 101:
        {
            if ([[self.userDefault valueForKey:@"UUID01"] isEqualToString:@""] || [self.userDefault objectForKey:@"UUID01"] == nil) {
                [self alertMsg:@"UUID can't be null !"];
                break;
            }
            
            // 通常UUID都是由硬件工程师定义的
            CBUUID *serviceUUID = [CBUUID UUIDWithString:[self.userDefault valueForKey:@"UUID01"]];
            
            // 设置添加到外设中的服务
            CBMutableService *service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
            service.characteristics = @[cha];
            
            // 添加服务到外设管理者中
            [self.services addObject:service];
            self.localNameKey = LocalNameKey1;
            break;
        }
        case 102:
        {
            if ([[self.userDefault valueForKey:@"UUID02"] isEqualToString:@""] || [self.userDefault objectForKey:@"UUID02"] == nil) {
                [self alertMsg:@"UUID can't be null !"];
                return;
            }
            
            // 通常UUID都是由硬件工程师定义的
            CBUUID *serviceUUID = [CBUUID UUIDWithString:[self.userDefault valueForKey:@"UUID02"]];
            CBMutableService *service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
            service.characteristics = @[cha];
            [self.services addObject:service];
            self.localNameKey = LocalNameKey2;
            break;
        }
        case 103:
        {
            if ([[self.userDefault valueForKey:@"UUID03"] isEqualToString:@""] || [self.userDefault objectForKey:@"UUID03"] == nil) {
                [self alertMsg:@"UUID can't be null !"];
                return;
            }
            
            // 通常UUID都是由硬件工程师定义的
            CBUUID *serviceUUID = [CBUUID UUIDWithString:[self.userDefault valueForKey:@"UUID03"]];
            CBMutableService *service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
            service.characteristics = @[cha];
            [self.services addObject:service];
            self.localNameKey = LocalNameKey3;
            break;
        }
        case 104:
        {
            if ([[self.userDefault valueForKey:@"UUID04"] isEqualToString:@""] || [self.userDefault objectForKey:@"UUID04"] == nil) {
                [self alertMsg:@"UUID can't be null !"];
                return;
            }
            
            // 通常UUID都是由硬件工程师定义的
            CBUUID *serviceUUID = [CBUUID UUIDWithString:[self.userDefault valueForKey:@"UUID04"]];            CBMutableService *service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
            service.characteristics = @[cha];
            [self.services addObject:service];
            self.localNameKey = LocalNameKey4;
            break;
        }
        default:
            break;
    }
    
    if (self.services.count) {
        for (CBMutableService *service in self.services) {
            [self.pMgr addService:service];
        }
    }
}

#pragma mark - 进入设置界面
-(void)settingBtnClick
{
    self.hidesBottomBarWhenPushed = YES;
    BLESettingViewController *settingVC = [[BLESettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)alertMsg:(NSString *)msg{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Warning" message:msg preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:confirm];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
