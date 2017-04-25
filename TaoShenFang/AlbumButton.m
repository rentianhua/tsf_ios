//
//  AlbumButton.m
//  TaoShenFangTest
//
//  Created by YXM on 16/8/15.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "AlbumButton.h"

@implementation AlbumButton

- (id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        //UIViewContentModeScaleAspectFill
        self.contentMode=UIViewContentModeScaleToFill;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleW=contentRect.size.width;
    CGFloat titleH=contentRect.size.height*0.18;
    CGFloat titleX=0;
    CGFloat titleY=contentRect.size.height*0.82;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imgH=contentRect.size.height*0.8;
    CGFloat imgW=contentRect.size.width;
    CGFloat imgX=(contentRect.size.width-imgW)/2;
    CGFloat imgY=0;
    
    return CGRectMake(imgX, imgY, imgW, imgH);
}



@end
