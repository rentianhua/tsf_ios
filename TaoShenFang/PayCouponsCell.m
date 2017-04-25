//
//  PayCouponsCell.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/27.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "PayCouponsCell.h"
#import "OtherHeader.h"
@implementation PayCouponsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self.selectionStyle=UITableViewCellSelectionStyleNone;
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        CGFloat margin=10;
        UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(margin, 20, 40, 40)];
        imgView.backgroundColor=[UIColor blueColor];
        [self addSubview:imgView];
        self.imgView=imgView;
        
        UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+margin, 19, 100, 21)];
        label1.text=@"支付宝";
        label1.font=[UIFont systemFontOfSize:16];
        label1.textColor=[UIColor blackColor];
        [self addSubview:label1];
        self.label1=label1;
        
        UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(kMainScreenWidth-30-20, 25, 30, 30)];
        button.backgroundColor=[UIColor redColor];
        [self addSubview:button];
        self.button=button;

        UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+margin, 19+21, kMainScreenWidth-CGRectGetMaxX(imgView.frame)-margin-50, 21)];
        label2.text=@"推荐支付宝用户使用";
        label2.font=[UIFont systemFontOfSize:16];
        label2.textColor=[UIColor blackColor];
        [self addSubview:label2];
        self.label2=label2;
        
    }
    return self;
}





@end
