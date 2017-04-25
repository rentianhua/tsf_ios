//
//  TSFRentMangerModel.m
//  TaoShenFang
//
//  Created by YXM on 16/11/10.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFRentMangerModel.h"

@implementation TSFRentMangerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID":@"id"
             };
}

- (NSString *)title{
    if (_title==nil) {
        _title=@"";
    }
    return _title;
}
- (NSString *)url{
    if (_url==nil) {
        _url=@"";
    }
    return _url;
}
- (NSString *)username{
    if (_username==nil) {
        _username=@"";
    }
    return _username;
}
- (NSString *)zujinrange{
    if (_zujinrange==nil) {
        _zujinrange=@"";
    }
    return _zujinrange;
}
- (NSString *)chenghu{
    if (_chenghu==nil) {
        _chenghu=@"";
    }
    return _chenghu;
}
- (NSString *)area{
    if (_area==nil) {
        _area=@"";
    }
    return _area;
}
- (NSString *)city{
    if (_city==nil) {
        _city=@"";
    }
    return _city;
}
- (NSString *)province{
    if (_province==nil) {
        _province=@"";
    }
    return _province;
}
- (NSString *)shi{
    if (_shi==nil) {
        _shi=@"";
    }
    return _shi;
}
- (NSString *)zulin{
    if (_zulin==nil) {
        _zulin=@"";
    }
    return _zulin;
}
- (NSString *)qiwangts{
    if (_qiwangts==nil) {
        _qiwangts=@"";
    }
    return _qiwangts;
}
- (NSString *)province_name{
    if (_province_name==nil) {
        _province_name=@"";
    }
    return _province_name;
}
- (NSString *)city_name{
    if (_city_name==nil) {
        _city_name=@"";
    }
    return _city_name;
}
- (NSString *)area_name{
    if (_area_name==nil) {
        _area_name=@"";
    }
    return _area_name;
}
- (NSString *)zongjiarange{
    if (_zongjiarange==nil) {
        _zongjiarange=@"";
    }
    return _zongjiarange;
}


@end
