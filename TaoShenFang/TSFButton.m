//
//  TSFButton.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/15.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "TSFButton.h"

@implementation TSFButton

- (id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.contentMode=UIViewContentModeScaleToFill;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleW=contentRect.size.width;
    CGFloat titleH=contentRect.size.height*0.2;
    CGFloat titleX=0;
    CGFloat titleY=contentRect.size.height*0.8+10;

    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imgW=contentRect.size.width;
    CGFloat imgH=contentRect.size.height*0.8;
    CGFloat imgX=0;
    CGFloat imgY=0;
    
    return CGRectMake(imgX, imgY, imgW, imgH);
}

@end
