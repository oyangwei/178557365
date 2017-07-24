//
//  RootViewController.m
//  BLE
//
//  Created by YangWei on 2017/7/12.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "RootViewController.h"
#import "BLECenterManagerViewController.h"
#import "BLEPeripheralViewController.h"

@interface RootViewController ()

@property(strong, nonatomic) UINavigationController *nVC;
@property(assign, nonatomic) BOOL isTouched;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isTouched = NO;
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    tabBar.titlePositionAdjustment = UIOffsetMake( 0, -11);
    
    BLEPeripheralViewController *peripheralVC = [[BLEPeripheralViewController alloc] init];
    peripheralVC.title = @"Advertise";
    UINavigationController *nVC = [[UINavigationController alloc] initWithRootViewController:peripheralVC];
    self.nVC = nVC;
    
    BLECenterManagerViewController *centerVC = [[BLECenterManagerViewController alloc] init];
    centerVC.title = @"Scan";
    
    [self addChildViewController:nVC];
    [self addChildViewController:centerVC];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_orientationDidChange:) name:@"isCanOrientarion" object:@"Periheral"];
}

-(void)_orientationDidChange:(NSNotification *)ns
{
    self.isTouched = [ns.userInfo[@"isTouched"] boolValue];
    [self shouldAutorotate];
}

-(BOOL)shouldAutorotate
{
    return !self.isTouched;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isTouched = YES;
    [self shouldAutorotate];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isTouched = NO;
    [self shouldAutorotate];
}

@end
