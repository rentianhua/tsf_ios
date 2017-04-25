//
//  XMYClassifyView.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/20.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "XMYClassifyView.h"
#import "OtherHeader.h"

@interface XMYClassifyView ()

@property (nonatomic,strong)NSArray *areaArray;

@end

@implementation XMYClassifyView
- (NSArray *)areaArray
{
    if (_areaArray==nil) {
        _areaArray=[NSArray arrayWithObjects:@"福田",@"龙岗",@"罗湖",@"两居",@"三居",@"四居",@"精装修",@"商品房",@"全部", nil];
    }
    return _areaArray;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        CGFloat buttonWidth=kMainScreenWidth/3;
        CGFloat buttonHeight=buttonWidth/3;
        
        for (int i=0; i<self.areaArray.count; i++) {
            int X=i/3;
            int Y=i%3;
            
            UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(0+X*buttonWidth, 0+Y* buttonHeight, buttonWidth , buttonHeight)];
            button.backgroundColor=[UIColor whiteColor];
            button.layer.borderColor=RGB(238, 238, 238, 1.0).CGColor;
            button.layer.borderWidth=0.5;
            button.tag=100+i;
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitle:self.areaArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self addSubview:button];
            [button addTarget:self action:@selector(headerClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        UIButton * moreButton=(UIButton *)[self viewWithTag:(100+self.areaArray.count-1)];
        [moreButton setTitleColor:NavBarColor forState:UIControlStateNormal];
    }
    return self;
}

- (void)headerClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(xMYClassifyViewButtonClick:)]) {
        [_delegate xMYClassifyViewButtonClick:button];
    }
}



@end
