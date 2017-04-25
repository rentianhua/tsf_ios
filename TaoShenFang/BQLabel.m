//
//  BQLabel.m
//  TaoShenFang
//
//  Created by YXM on 16/10/14.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "BQLabel.h"

@implementation BQLabel

- (instancetype)init{
    if (self=[super init]) {
        _textInsets=UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        _textInsets=UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}





@end
