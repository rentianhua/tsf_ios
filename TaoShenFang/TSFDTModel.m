//
//  TSFDTModel.m
//  TaoShenFang
//
//  Created by YXM on 16/11/30.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFDTModel.h"

@implementation TSFDTModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
   
    return @{@"ID":@"id",
             @"descrip":@"description",
             @"newid":@"new_id"};
}

@end
