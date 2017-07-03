//
//  ViewController.m
//  TeleconMobileDemo03
//
//  Created by YangWei on 17/6/23.
//  Copyright © 2017年 YangWei. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

#define firstPostURL @"http://192.168.3.4/test_three/index1.php"
#define secondPostURL @"http://192.168.3.4/test_three/index2.php"

typedef void (^FinishBlock) (void);

@interface ViewController ()

@property (assign, nonatomic) NSInteger num;
@property (strong, nonatomic) NSDictionary *responseData;
@property (assign, nonatomic) BOOL isSuccess;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.startPostBtn.backgroundColor = [UIColor greenColor];
    self.phoneTextFile.keyboardType = UIKeyboardTypeNumberPad;
    
}

- (IBAction)startPost:(id)sender {
    
    [self start];
    
}

-(void)start{

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_group_async(group, queue, ^{
        FinishBlock finishBlock = ^{
            dispatch_semaphore_signal(semaphore);
        };
        
        NSDictionary *userInfo = @{@"callback" : [finishBlock copy]};
        self.num = 0;
        NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(Show:) userInfo:userInfo repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        CFRunLoopRun();
    });
    
    dispatch_group_notify(group, queue, ^{
        
        dispatch_semaphore_wait( semaphore, DISPATCH_TIME_FOREVER);
        
        if (!self.isSuccess) {
            [self alertMsg:@"Response Failed !"];
            return;
        }
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: self.phoneTextFile.text, @"phone", self.nameTextFiled.text, @"name", nil];
        [self requestAsync:secondPostURL withParameters:parameters withFinish:nil];
        
    });
    
}

-(void)Show : (NSTimer *)timer
{
    NSDictionary *userInfo = timer.userInfo;
    FinishBlock block = userInfo[@"callback"];
    
    if (self.num == 9) {
        self.num = 0;
        if (!self.isSuccess) {
            return;
        }
        CFRunLoopStop(CFRunLoopGetCurrent());
        return;
    }
    
    self.num ++;
    
    NSString *str = [NSString stringWithFormat:@"开始第%ld请求：", (long)self.num];
    self.dataLabel.text = str;
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: @"OywiPhone", @"sid", self.phoneTextFile.text, @"phone", self.nameTextFiled.text, @"name",nil];
    [self requestAsync:firstPostURL withParameters:parameters withFinish:block];
    
}

-(void)requestAsync:(NSString *)url withParameters:(NSDictionary *)parameters withFinish:(void(^)()) finish
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([url isEqualToString:firstPostURL]) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            if (![dic[@"phone"] isEqualToString:@""] && ![dic[@"name"] isEqualToString:@""])
            {
                self.isSuccess = true;
            }
            
            self.responseData = dic;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dataLabel.text = [self.dataLabel.text stringByAppendingFormat:@"%@", self.responseData];
            });
        }
        else if([url isEqualToString:secondPostURL])
        {
            NSDictionary *dic = (NSDictionary *)responseObject;
            self.responseData = dic;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dataLabel.text = [@"请求成功 : " stringByAppendingFormat:@"%@", self.responseData];
            });
        }
        
        if (finish && self.isSuccess) {
            finish();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_nameTextFiled resignFirstResponder];
    [_phoneTextFile resignFirstResponder];
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
