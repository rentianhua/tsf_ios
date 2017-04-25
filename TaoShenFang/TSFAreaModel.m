//
//  TSFAreaModel.m
//  TaoShenFang
//
//  Created by YXM on 16/11/8.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFAreaModel.h"
#import <MJExtension.h>

@implementation TSFAreaModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"area":@"TSFAreaModel"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

- (NSString *)name{
    if (_name==nil) {
        _name=@"";
    }
    return _name;
}

@end
