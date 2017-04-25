//
//  TSFPayModel.m
//  TaoShenFang
//
//  Created by YXM on 16/11/18.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFPayModel.h"

@implementation TSFPayModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id", @"des":@"description"};
}

@end
