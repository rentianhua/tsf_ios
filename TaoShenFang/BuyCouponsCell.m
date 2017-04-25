//
//  BuyCouponsCell.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/26.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "BuyCouponsCell.h"
#import "OtherHeader.h"
@implementation BuyCouponsCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self.selectionStyle=UITableViewCellSelectionStyleNone;
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat margin=10;
        UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(margin, margin,kMainScreenWidth , 21)];
        label1.text=@"中海信众创城40平米一房";
        label1.font=TitleFont;
        [self addSubview:label1];
        self.label1=label1;
        
        UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(margin, CGRectGetMaxY(label1.frame)+margin, (kMainScreenWidth-2*margin)/2, 21)];
        label2.text=@"1室1厅1卫 40m^2";
        label2.font=DescrTitleFont;
        [self addSubview:label2];
        self.label2=label2;
        
        UILabel * label3=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame), CGRectGetMaxY(label1.frame), (kMainScreenWidth-2*margin)/2, 21)];
        label3.text=@"64万起";
        label3.textColor=[UIColor redColor];
        label3.textAlignment=NSTextAlignmentRight;
        label3.font=TitleFont;
        [self addSubview:label3];
        self.label3=label3;
        

    
    }
    return self;
}
@end
