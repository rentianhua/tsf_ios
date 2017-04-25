//
//  TFValueParser.h
//  TFQuicklyBuild
//
//  Created by zengxiangfeng on 16/1/12.
//  Copyright © 2016年 zengxiangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFValueParser : NSObject

+ (id)valueWithString:(NSString *)aString;

+ (void)registerEnums:(NSDictionary *)enums; // <NSString *, NSNumber *>

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com