//
//  TSFMapButton.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/19.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "TSFMapButton.h"

@implementation TSFMapButton

- (id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        self.contentMode=UIViewContentModeScaleToFill;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleW=contentRect.size.width;
    CGFloat titleH=contentRect.size.height*0.5;
    CGFloat titleX=0;
    CGFloat titleY=contentRect.size.height*0.5;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imgH=contentRect.size.height*0.4;
    CGFloat imgW=imgH;
    CGFloat imgX=(contentRect.size.width-imgW)/2;
    CGFloat imgY=contentRect.size.height*0.1;
    
    return CGRectMake(imgX, imgY, imgW, imgH);
}

@end
