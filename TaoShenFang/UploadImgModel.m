//
//  UploadImgModel.m
//  TaoShenFang
//
//  Created by YXM on 16/10/9.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "UploadImgModel.h"

@implementation UploadImgModel

- (NSString *)picname{
    if (_picname==nil) {
        _picname=@"";
    }
    return _picname;
}

@end
