//
//  BLESettingViewController.h
//  BLE
//
//  Created by YangWei on 2017/7/13.
//  Copyright © 2017年 TeleconMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLESettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *UUIDTextField01;
@property (weak, nonatomic) IBOutlet UITextField *Name01;

@property (weak, nonatomic) IBOutlet UITextField *UUIDTextField02;
@property (weak, nonatomic) IBOutlet UITextField *Name02;

@property (weak, nonatomic) IBOutlet UITextField *UUIDTextField03;
@property (weak, nonatomic) IBOutlet UITextField *Name03;

@property (weak, nonatomic) IBOutlet UITextField *UUIDTextField04;
@property (weak, nonatomic) IBOutlet UITextField *Name04;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

- (IBAction)confirmClick:(id)sender;

@end
