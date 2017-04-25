//
//  TSFRecordModel.m
//  TaoShenFang
//
//  Created by YXM on 16/12/16.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFRecordModel.h"
#import <MJExtension.h>

@implementation TSFRecordModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end
