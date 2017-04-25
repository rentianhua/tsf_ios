//
//  CouponsDetailCell.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/26.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "CouponsDetailCell.h"
#import "OtherHeader.h"

@implementation CouponsDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self.selectionStyle=UITableViewCellSelectionStyleNone;
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        button.backgroundColor=[UIColor redColor];
        [button setTitle:@"团" forState:UIControlStateNormal];
        button.layer.cornerRadius=15;
        button.clipsToBounds=YES;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:button];
        
        UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+10, 15, 200, 21)];
        label1.text=@"3万抵8万";
        label1.font=[UIFont systemFontOfSize:16];
        label1.textColor=[UIColor blackColor];
        [self addSubview:label1];
        
        UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(label1.frame)+10, kMainScreenWidth-20, 63)];
        label2.numberOfLines=0;
        label2.text=@"此优惠券自购买7日内有效期！购买后如需退款我们将收取20%的违约金";
        label2.font=[UIFont systemFontOfSize:16];
        label2.textColor=[UIColor redColor];
        [self addSubview:label2];
        

        

        
    }
    return self;
}


@end
