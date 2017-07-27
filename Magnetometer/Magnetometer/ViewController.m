//
//  ViewController.m
//  Magnetometer
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()
@property(strong, nonatomic) CMMotionManager *motionManager;
@property(assign, nonatomic) int leftTime;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftTime = 60;
    
    _motionManager = [[CMMotionManager alloc] init];
    [_motionManager startMagnetometerUpdates];
    
    if (!_motionManager.magnetometerAvailable) {
        NSLog(@"传感器不可用");
    }
    else
    {
        _motionManager.magnetometerUpdateInterval = 1.0;
        
        [_motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
            self.curX.text = [NSString stringWithFormat:@"%f", magnetometerData.magneticField.x];
            self.curY.text = [NSString stringWithFormat:@"%f", magnetometerData.magneticField.y];
            self.curZ.text = [NSString stringWithFormat:@"%f", magnetometerData.magneticField.z];
            
            [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                
            }];
        }];
    }
}


@end
