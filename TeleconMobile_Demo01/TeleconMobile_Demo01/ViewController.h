//
//  ViewController.h
//  TeleconMobile_Demo01
//
//  Created by Oyw on 2017/6/21.
//  Copyright © 2017年 Oyw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkCodeBtn;

@property (weak, nonatomic) IBOutlet UITextView *dataLabel;
@end

