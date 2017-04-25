//
//  ZYWHttpEngine.h
//  ZhongYiWang
//
//  Created by sks on 16/4/12.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ZYWHttpEngine : NSObject


#pragma mark----post请求-----
+ (void)AllPostURL:(NSString *)URL params:(NSDictionary *)para  success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure;

#pragma mark-----Get请求------
+ (void)AllGetURL:(NSString *)URL params:(NSDictionary *)para success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure;

@end
