//
//  ViewController.m
//  TeleconMobile_Demo01
//
//  Created by Oyw on 2017/6/21.
//  Copyright © 2017年 Oyw. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#define GetCodeURL @"http://192.168.3.4/test/SmsSenderDemo.php"
#define CheckCodeURL @"http://192.168.3.4/test/Response.php"

@interface ViewController ()
@property(strong, nonatomic) NSString *Sid;  //会话id
@property(assign, nonatomic) BOOL getCodeSeccess;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendRequest:(id)sender {
    
    if ([self.phoneTextField.text isEqualToString:@""]) {
        [self alertMsg:@"Phone can't null !"];
        return;
    }
    
    NSDictionary *condition = [NSDictionary dictionaryWithObjectsAndKeys: @"OywiPhone", @"sid", self.phoneTextField.text, @"phone", @"86", @"zipCode", nil];
    [self requestDataWithURL:GetCodeURL withParameters:condition];
}

- (IBAction)checkCodeRequest:(id)sender {
    if (!self.getCodeSeccess) {
        [self alertMsg:@"Please get code !"];
        return;
    }
    
    if ([self.codeTextField.text isEqualToString:@""]) {
        [self alertMsg:@"Code can't null !"];
        return;
    }
    
    NSDictionary *condition = [NSDictionary dictionaryWithObjectsAndKeys: self.codeTextField.text, @"SMSCode", self.Sid, @"Sid", nil];
    [self requestDataWithURL:CheckCodeURL withParameters:condition];
}

#pragma mark --网络请求数据
-(void)requestDataWithURL:(NSString *)url withParameters:(NSDictionary *)condition{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];
    
    [manager POST:url parameters:condition progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([url isEqualToString:GetCodeURL])
        {
            NSDictionary *dic = (NSDictionary *)responseObject;
            self.Sid = dic[@"sid"];
            self.dataLabel.text = [NSString stringWithFormat:@"%@", dic];
            self.getCodeSeccess = true;
            NSLog(@"%@", dic);
        }
        else if ([url isEqualToString:CheckCodeURL])
        {
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            self.dataLabel.text = [NSString stringWithFormat:@"%@", dic];
            
        }
                
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure -- %@", error);
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
}

-(void)alertMsg:(NSString *)msg{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定～！！！");
    }];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}



@end
