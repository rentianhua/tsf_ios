//
//  UserModel.m
//  TaoShenFangTest
//
//  Created by YXM on 16/8/22.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (NSString *)sex{
    if (_sex==nil) {
        _sex=@"";
    }
    return _sex;
}
- (NSString *)attention{
    if (_attention==nil) {
        _attention=@"";
    }
    return _attention;
}
- (NSString *)nickname{
    if (_nickname==nil) {
        _nickname=@"";
    }
    return _nickname;
}
- (NSString *)vtel{
    if (_vtel==nil) {
        _vtel=@"";
    }
    return _vtel;
}
- (NSString *)ctel{
    if (_ctel==nil) {
        _ctel=@"";
    }
    return _ctel;
}
- (NSString *)about{
    if (_about==nil) {
        _about=@"";
    }
    return _about;
}
- (NSString *)realname{
    if (_realname==nil) {
        _realname=@"";
    }
    return _realname;
}
@end
