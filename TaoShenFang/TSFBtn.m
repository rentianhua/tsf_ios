//
//  TSFBtn.m
//  YXM下拉框
//
//  Created by YXM on 16/11/7.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFBtn.h"

#define KSCREENW [UIScreen mainScreen].bounds.size.width

@implementation TSFBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGSize strSize=CGSizeMake(200, MAXFLOAT);
    CGSize titleSize=[self.currentTitle boundingRectWithSize:strSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    CGFloat titleW=titleSize.width;
    CGFloat maxW=KSCREENW*0.25-20;
    if (titleW> maxW) {
        titleW=maxW;
    }

    CGFloat X=(contentRect.size.width-titleW-10)*0.5;
    CGFloat Y=0;
    CGFloat width=titleW;
    CGFloat height=contentRect.size.height;
    
    
    return CGRectMake(X, Y, width, height);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
     CGSize strSize=CGSizeMake(200, MAXFLOAT);
    CGSize titleSize=[self.currentTitle boundingRectWithSize:strSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    CGFloat titleW=titleSize.width;
    CGFloat maxW=KSCREENW*0.25-20;
    if (titleW> maxW) {
        titleW=maxW;
    }
    CGFloat X=(contentRect.size.width-titleW-10)*0.5+titleW;
    CGFloat Y=(contentRect.size.height-16)*0.5;
    CGFloat width=10;
    CGFloat height=16;

    return CGRectMake(X, Y, width, height);
}





@end
