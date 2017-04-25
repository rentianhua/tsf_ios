//
//  OrderModel.m
//  TaoShenFang
//
//  Created by YXM on 16/9/22.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"id":@"ID",@"typeid":@"typeID"};
}

@end
