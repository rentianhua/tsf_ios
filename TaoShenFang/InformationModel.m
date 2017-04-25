//
//  InformationModel.m
//  TaoShenFangTest
//
//  Created by YXM on 16/8/20.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "InformationModel.h"
@implementation InformationModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"descrip":@"description"};
}
- (NSString *)title{
    if (_title==nil) {
        _title=@"";
    }
    return _title;
}
- (NSString *)descrip{
    if (_descrip==nil) {
        _descrip=@"";
    }
    return _descrip;
}
- (NSString *)content{
    if (_content==nil) {
        _content=@"";
    }
    return _content;
}
@end
