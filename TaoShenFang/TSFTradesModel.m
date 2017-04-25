//
//  TSFTradesModel.m
//  TaoShenFang
//
//  Created by YXM on 16/12/8.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFTradesModel.h"

@implementation TSFTradesModel

- (NSString *)content{
    if (_content==nil) {
        _content=@"";
    }
    return _content;
}

- (NSString * )renzheng{
    if (_renzheng==nil) {
        _renzheng=@"";
    }
    return _renzheng;
}

@end
