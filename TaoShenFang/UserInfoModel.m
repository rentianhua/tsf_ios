//
//  UserInfoModel.m
//  TaoShenFang
//
//  Created by YXM on 16/9/20.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
- (NSString *)cardnumber{
    if (_cardnumber==nil) {
        _cardnumber=@"";
    }
    return _cardnumber;
}
- (NSString *)mainarea{
    if (_mainarea==nil) {
        _mainarea=@"";
    }
    return _mainarea;
}
- (NSString *)leixing{
    if (_leixing==nil) {
        _leixing=@"";
    }
    return _leixing;
}
- (NSString *)coname{
    if (_coname==nil) {
        _coname=@"";
    }
    return _coname;
}
- (NSString *)biaoqian{
    if (_biaoqian==nil) {
        _biaoqian=@"";
    }
    return _biaoqian;
}
- (NSString *)dengji{
    if (_dengji==nil) {
        _dengji=@"";
    }
    return _dengji;
}
- (NSString *)realname{
    if (_realname==nil) {
        _realname=@"";
    }
    return _realname;
}
- (NSString *)worktime{
    if (_worktime==nil) {
        _worktime=@"";
    }
    return _worktime;
}

@end
