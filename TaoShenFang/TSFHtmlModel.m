//
//  TSFHtmlModel.m
//  TaoShenFang
//
//  Created by YXM on 16/11/30.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFHtmlModel.h"

@implementation TSFHtmlModel

- (NSString *)fukuanfangshi{
    if (_fukuanfangshi==nil) {
        _fukuanfangshi=@"";
    }
    return _fukuanfangshi;
}
- (NSString *)huxingintro{
    if (_huxingintro==nil) {
        _huxingintro=@"";
    }
    return _huxingintro;
}
@end
