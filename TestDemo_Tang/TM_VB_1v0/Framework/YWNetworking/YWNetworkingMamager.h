//
//  YWNetworkingMamager.h
//  TeleconMobile_Demo02
//
//  Created by YangWei on 17/6/22.
//  Copyright © 2017年 Oyw. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ProgressBlock)(NSProgress *downloadProgress);
typedef void (^SuccessBlock)(NSDictionary *data);
typedef void (^FailureBlock)(NSError *error);

@interface YWNetworkingMamager : NSObject

@property (nonatomic, copy) ProgressBlock progressBlock;
@property (nonatomic, copy) SuccessBlock successBlock;
@property (nonatomic, copy) FailureBlock failureBlock;

/**
 *  发送get请求
 *  @param urlString   请求的网址字符串
 *  @param parameters  请求的参数
 *  @param successBlock     请求成功的回调
 *  @param failureBlock     请求失败的回调
 */

+(void)getWithURLString:(NSString *)urlString
             parameters:(id)parameters
               progress:(ProgressBlock)progressBlock
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock;

/**
 *  发送post请求
 *  @param urlString   请求的网址字符串
 *  @param parameters  请求的参数
 *  @param successBlock     请求成功的回调
 *  @param failureBlock     请求失败的回调
 */

+(void)postWithURLString:(NSString *)urlString
              parameters:(id)parameters
                progress:(ProgressBlock)progressBlock
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock;


@end
