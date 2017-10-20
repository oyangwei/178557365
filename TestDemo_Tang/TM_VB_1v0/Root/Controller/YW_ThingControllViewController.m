//
//  YW_ThingControllViewController.m
//  TestDemo_Tang
//
//  Created by Oyw on 2017/10/18.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "YW_ThingControllViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "YW_DeclareView.h"

static NSString *const Service1StrUUID = @"66554433-2211-2211-2211-221144332211";
static NSString *const Service2StrUUID = @"67554433-2211-2211-2211-221144332211";
static NSString *const Service3StrUUID = @"68554433-2211-2211-2211-221144332211";
static NSString *const Service4StrUUID = @"69554433-2211-2211-2211-221144332211";
static NSString *const Service5StrUUID = @"6A554433-2211-2211-2211-221144332211";
static NSString *const Service6StrUUID = @"6B554433-2211-2211-2211-221144332211";
static NSString *const Service7StrUUID = @"6C554433-2211-2211-2211-221144332211";

static NSString *const notifyCharacticStrUUID = @"FFF1";
static NSString *const readWriteCharacticStrUUID = @"FFF2";
static NSString *const readCharacticStrUUID = @"FFE1";

static NSString *const LocalNameKey1 = @"Oyw01";
static NSString *const LocalNameKey2 = @"Oyw02";
static NSString *const LocalNameKey3 = @"Oyw03";
static NSString *const LocalNameKey4 = @"Oyw04";
static NSString *const LocalNameKey5 = @"Oyw05";
static NSString *const LocalNameKey6 = @"Oyw06";
static NSString *const LocalNameKey7 = @"Oyw07";

@interface YW_ThingControllViewController ()<CBPeripheralManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *button01;

@property (weak, nonatomic) IBOutlet UIButton *button02;

@property (weak, nonatomic) IBOutlet UIButton *button03;

@property (weak, nonatomic) IBOutlet UIButton *button04;

@property (weak, nonatomic) IBOutlet UIButton *button05;

@property (weak, nonatomic) IBOutlet UIButton *button06;

@property (weak, nonatomic) IBOutlet UIButton *button07;

/** 外设管理者 */
@property(strong, nonatomic) CBPeripheralManager *peripheralManager;

/** Services */
@property(strong, nonatomic) NSMutableArray *services;

/** LocalName */
@property(strong, nonatomic) NSString *localName;

/** numOfServices */
@property(assign, nonatomic) int numOfServices;

/** UIAlertWindow */
@property(strong, nonatomic) UIWindow *alertWindow;

/** DeclareView */
@property(strong, nonatomic) YW_DeclareView *declareView;

@end

@implementation YW_ThingControllViewController

-(NSMutableArray *)services
{
    if (!_services) {
        _services = [NSMutableArray array];
    }
    return _services;
}

-(CBPeripheralManager *)peripheralManager
{
    if (!_peripheralManager) {
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];  //初始化
    }
    return _peripheralManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self peripheralManager];
    
    [self setupNav];
    
    self.title = self.titleName;
    
    [self addGesture];
}

-(void)setupNav
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"declare" highImage:@"declare_click" target:self action:@selector(showDeclare)];
}

-(void)addGesture
{

    [self.button01 addTarget:self action:@selector(startAdvertise:) forControlEvents:UIControlEventTouchDown];
    [self.button01 addTarget:self action:@selector(endAdvertise:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.button02 addTarget:self action:@selector(startAdvertise:) forControlEvents:UIControlEventTouchDown];
    [self.button02 addTarget:self action:@selector(endAdvertise:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.button03 addTarget:self action:@selector(startAdvertise:) forControlEvents:UIControlEventTouchDown];
    [self.button03 addTarget:self action:@selector(endAdvertise:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.button04 addTarget:self action:@selector(startAdvertise:) forControlEvents:UIControlEventTouchDown];
    [self.button04 addTarget:self action:@selector(endAdvertise:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.button05 addTarget:self action:@selector(startAdvertise:) forControlEvents:UIControlEventTouchDown];
    [self.button05 addTarget:self action:@selector(endAdvertise:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.button06 addTarget:self action:@selector(startAdvertise:) forControlEvents:UIControlEventTouchDown];
    [self.button06 addTarget:self action:@selector(endAdvertise:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.button07 addTarget:self action:@selector(startAdvertise:) forControlEvents:UIControlEventTouchDown];
    [self.button07 addTarget:self action:@selector(endAdvertise:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)showDeclare
{
    [self alertDeclareView];
}

-(void)startAdvertise:(UIButton *)btn
{
    [UIView animateWithDuration:0.2 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }];
    
    self.numOfServices = 0;
    [self writeData:(int)btn.tag];
    
}

-(void)endAdvertise:(UIButton *)btn
{
    [UIView animateWithDuration:0.2 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    [self.peripheralManager stopAdvertising];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    switch (peripheral.state) {
        case CBManagerStateUnknown:
        case CBManagerStateResetting:
        case CBManagerStateUnsupported:
        case CBManagerStateUnauthorized:
        case CBManagerStatePoweredOff:
        {
            NSLog(@"请打开蓝牙");
            break;
        }
        case CBManagerStatePoweredOn:
        {
            NSLog(@"蓝牙已打开");
            break;
        }
        default:
            break;
    }
}

-(void)writeData:(int)tag
{
    [self.services removeAllObjects];  //移除所有的Service
    
    CBMutableDescriptor *descriptor = [[CBMutableDescriptor alloc] initWithType:[CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString] value:@"TeleconMobile01"];
    
    // 创建特征（服务的特征）
    CBMutableCharacteristic *cha = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:readCharacticStrUUID]
                                                                      properties:CBCharacteristicPropertyRead value:nil
                                                                     permissions:CBAttributePermissionsReadable];
    cha.descriptors = @[descriptor];
    
    switch (tag) {
        case 101:
        {
            CBUUID *serviceUUID = [CBUUID UUIDWithString:Service1StrUUID];
            CBMutableService *service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
            service.characteristics = @[cha];
            [self.services addObject:service];

            self.localName = LocalNameKey1;
            break;
        }
            
        case 102:
        {
            CBUUID *serviceUUID = [CBUUID UUIDWithString:Service2StrUUID];
            CBMutableService *service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
            service.characteristics = @[cha];
            [self.services addObject:service];
            
            self.localName = LocalNameKey2;
            break;
        }
            
        case 103:
        {
            CBUUID *serviceUUID = [CBUUID UUIDWithString:Service3StrUUID];
            CBMutableService *service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
            service.characteristics = @[cha];
            [self.services addObject:service];
            
            self.localName = LocalNameKey3;
            break;
        }
            
        case 104:
        {
            CBUUID *serviceUUID = [CBUUID UUIDWithString:Service4StrUUID];
            CBMutableService *service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
            service.characteristics = @[cha];
            [self.services addObject:service];
            
            self.localName = LocalNameKey4;
            break;
        }
            
        case 105:
        {
            CBUUID *serviceUUID = [CBUUID UUIDWithString:Service5StrUUID];
            CBMutableService *service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
            service.characteristics = @[cha];
            [self.services addObject:service];
            
            self.localName = LocalNameKey5;
            break;
        }
            
        case 106:
        {
            CBUUID *serviceUUID = [CBUUID UUIDWithString:Service6StrUUID];
            CBMutableService *service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
            service.characteristics = @[cha];
            [self.services addObject:service];
            
            self.localName = LocalNameKey6;
            break;
        }
            
        case 107:
        {
            CBUUID *serviceUUID = [CBUUID UUIDWithString:Service7StrUUID];
            CBMutableService *service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
            service.characteristics = @[cha];
            [self.services addObject:service];
            
            self.localName = LocalNameKey7;
            break;
        }
            
        default:
            break;
    }
    
    if (self.services.count) {
        for (CBMutableService *service in self.services) {
            [self.peripheralManager addService:service];
        }
    }
}

-(void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    NSLog(@"%s, line = %d", __func__, __LINE__);
    if (!error) {
        self.numOfServices ++;
    }
    
    if (self.numOfServices == self.services.count) {
        [self.peripheralManager startAdvertising:@{
                                                   CBAdvertisementDataLocalNameKey : self.localName,
                                                   CBAdvertisementDataServiceUUIDsKey : [self.services valueForKey:@"UUID"]
                                                   }];
    }
}

-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    if (error) {
        NSLog(@"%s, line = %d, error = %@", __func__, __LINE__, error);
        return;
    }
    NSLog(@"%s, line = %d, peripheral = %@", __func__, __LINE__, peripheral);
}

-(void)alertDeclareView
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
    
    
    YW_DeclareView *declareView = [YW_DeclareView declareView];
    declareView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    self.declareView = declareView;
    __weak typeof(self) weakSelf = self;
    declareView.confirmBlock = ^{
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.alertWindow.hidden = YES;
        }];
    };
    
    [UIView animateWithDuration:0.5 animations:^{
        [window addSubview:declareView];
    } ];
}

@end
