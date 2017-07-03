//
//  ViewController.m
//  TeleconMobile_Demo02
//
//  Created by Oyw on 2017/6/21.
//  Copyright © 2017年 Oyw. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#define GetCodeURL @"http://192.168.3.4/test_two/index1.php"
#define CheckCodeURL @"http://192.168.3.4/test_two/index2.php"

@interface ViewController ()
@property(assign, nonatomic) BOOL getCodeSuccess;
@property(strong, nonatomic) NSDictionary *responseData;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.getCodeBtn.backgroundColor = [UIColor greenColor];
    
}

- (IBAction)sendRequest:(id)sender {
    
    if ([self.phoneTextField.text isEqualToString:@""]) {
        [self alertMsg:@"Phone can't null !"];
        return;
    }
    
    [self send];
}

#pragma mark --网络请求数据
-(void)requestAsync:(NSString *)url withParameters:(NSDictionary *)condition withFinish:(void(^)())finish{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];
    
    [manager POST:url parameters:condition progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([url isEqualToString:GetCodeURL])
        {
            NSDictionary *dic = (NSDictionary *)responseObject;
            self.responseData = dic;
            self.getCodeSuccess = true;
            NSLog(@"%@", dic);
            finish();
        }
        else if ([url isEqualToString:CheckCodeURL])
        {
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            self.dataLabel.text = [self.dataLabel.text stringByAppendingFormat:@"\n2.%@", dic];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure -- %@", error);
    }];
}

- (void)send {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_group_async(group, queue, ^{
        NSDictionary *condition = [NSDictionary dictionaryWithObjectsAndKeys: @"OywiPhone", @"sid", self.phoneTextField.text, @"phone", @"阳威", @"name", nil];
        [self requestAsync:GetCodeURL withParameters:condition withFinish:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        if (!self.getCodeSuccess) {
            [self alertMsg:@"Get Code Failed !"];
            return;
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.dataLabel.text = [NSString stringWithFormat:@"1.%@", self.responseData];
        });
        [NSThread sleepForTimeInterval:2.0];
        NSDictionary *condition = [NSDictionary dictionaryWithObjectsAndKeys: self.responseData[@"name"], @"name", self.responseData[@"phone"], @"phone", nil];
        [self requestAsync:CheckCodeURL withParameters:condition withFinish:nil];
    });
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_phoneTextField resignFirstResponder];
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
