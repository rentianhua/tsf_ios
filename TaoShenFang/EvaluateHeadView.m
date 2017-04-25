//
//  EvaluateHeadView.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/27.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "EvaluateHeadView.h"
#import "OtherHeader.h"


@implementation EvaluateHeadView

- (id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        NSArray * array=@[@"评论数",@"好评率"];
        for (int i=0; i<2; i++) {
            UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0+kMainScreenWidth*0.5*i, 0, kMainScreenWidth*0.5, 21)];
            label.text=array[i];
            label.textColor=[UIColor whiteColor];
            label.font=[UIFont systemFontOfSize:14];
            [self addSubview:label];
        }
        
        
        
        
    }
    return self;
}
@end
