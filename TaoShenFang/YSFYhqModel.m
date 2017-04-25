//
//  YSFYhqModel.m
//  TaoShenFang
//
//  Created by YXM on 16/11/29.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "YSFYhqModel.h"

@implementation YSFYhqModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id",
             @"typeID":@"typeid",
             @"descrip":@"description"
             };
}




@end
