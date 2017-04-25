//
//  LatAndLonModel.m
//  TaoShenFang
//
//  Created by YXM on 16/10/21.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "LatAndLonModel.h"

@implementation LatAndLonModel

- (NSString *)fromtable{
    if (_fromtable==nil) {
        _fromtable=@"";
    }
    return _fromtable;
}

- (NSString *)xiaoqu{
    if (_xiaoqu==nil) {
        _xiaoqu=@"";
    }
    return _xiaoqu;
}
- (NSString *)xiaoquname{
    if (_xiaoquname==nil) {
        _xiaoquname=@"";
    }
    return _xiaoquname;
}

- (NSString *)latAndLon{
    if (_latAndLon==nil) {
        _latAndLon=@"";
    }
    return _latAndLon;
}
@end
