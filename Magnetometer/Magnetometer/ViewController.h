//
//  ViewController.h
//  Magnetometer
//
//  Created by z°先森 on 2017/7/25.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *averX;
@property (weak, nonatomic) IBOutlet UILabel *averY;
@property (weak, nonatomic) IBOutlet UILabel *areaZ;

@property (weak, nonatomic) IBOutlet UILabel *curX;
@property (weak, nonatomic) IBOutlet UILabel *curY;
@property (weak, nonatomic) IBOutlet UILabel *curZ;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

