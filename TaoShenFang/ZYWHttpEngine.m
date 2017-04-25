//
//  ZYWHttpEngine.m
//  ZhongYiWang
//
//  Created by sks on 16/4/12.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "ZYWHttpEngine.h"
#import "AFNetworking.h"
//#import <AFHTTPRequestOperation.h>

@implementation ZYWHttpEngine

 

#pragma mark----post请求-----

+ (void)AllPostURL:(NSString *)URL params:(NSDictionary *)para  success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure
{
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:NULL forHTTPHeaderField:@"User-Agent"];
    //AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //securityPolicy.allowInvalidCertificates = YES;
    //manager.securityPolicy = securityPolicy;
    [manager POST:URL parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable JSON) {
        if (success) {
            NSJSONSerialization * json=[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
            success(json);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }

    }];
}

#pragma mark----get请求-----

+ (void)AllGetURL:(NSString *)URL params:(NSDictionary *)para success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure
{
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:NULL forHTTPHeaderField:@"User-Agent"];
    [manager GET:URL parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable JSON) {
        if (success) {
            NSJSONSerialization * json=[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
            success(json);

        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }

    }];
    
}

@end
