//
//  YWNetworkingMamager.m
//  TeleconMobile_Demo02
//
//  Created by YangWei on 17/6/22.
//  Copyright © 2017年 Oyw. All rights reserved.
//

#import "YWNetworkingMamager.h"
#import "AFNetworking.h"

@implementation YWNetworkingMamager

+(void)getWithURLString:(NSString *)urlString parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

+(void)postWithURLString:(NSString *)urlString parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{

}

@end
