//
//  BokerSectionView.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/23.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "BokerSectionView.h"
#import "OtherHeader.h"
@implementation BokerSectionView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithReuseIdentifier:reuseIdentifier];

    if (self) {
        
        UIButton * button1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth/3, 40)];
        button1.backgroundColor=[UIColor whiteColor];
        button1.layer.borderColor=SeparationLineColor.CGColor;
        button1.layer.borderWidth=1;
        [button1 setTitle:@"区域" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"down01"] forState:UIControlStateNormal];
        [button1.titleLabel setFont:TitleFont];
        [self addSubview:button1];
        
        button1.imageEdgeInsets=UIEdgeInsetsMake(0, button1.imageView.bounds.size.width+10, 0,-button1.titleLabel.bounds.size.width);
        button1.titleEdgeInsets=UIEdgeInsetsMake(0, -button1.titleLabel.bounds.size.width, 0,  button1.imageView.bounds.size.width);
        
        
        UIButton * button2=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button1.frame), 0, kMainScreenWidth/3, 40)];
        button2.backgroundColor=[UIColor whiteColor];
        button2.layer.borderColor=SeparationLineColor.CGColor;
        button2.layer.borderWidth=1;
        [button2 setTitle:@"筛选条件" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"down01"] forState:UIControlStateNormal];
        [button2.titleLabel setFont:TitleFont];
        [self addSubview:button2];
        
        button2.imageEdgeInsets=UIEdgeInsetsMake(0, button1.imageView.bounds.size.width+10, 0,-button1.titleLabel.bounds.size.width);
        button2.titleEdgeInsets=UIEdgeInsetsMake(0, -button1.titleLabel.bounds.size.width, 0,  button1.imageView.bounds.size.width);
        
        UIButton * button3=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button2.frame), 0, kMainScreenWidth/3, 40)];
        button3.backgroundColor=[UIColor whiteColor];
        button3.layer.borderColor=SeparationLineColor.CGColor;
        button3.layer.borderWidth=1;
        [button3 setTitle:@"默认排序" forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button3 setImage:[UIImage imageNamed:@"down01"] forState:UIControlStateNormal];
        [button3.titleLabel setFont:TitleFont];
        [self addSubview:button3];
        
        button3.imageEdgeInsets=UIEdgeInsetsMake(0, button1.imageView.bounds.size.width+10, 0,-button1.titleLabel.bounds.size.width);
        button3.titleEdgeInsets=UIEdgeInsetsMake(0, -button1.titleLabel.bounds.size.width, 0,  button1.imageView.bounds.size.width);


    }
    return self;
}


@end
