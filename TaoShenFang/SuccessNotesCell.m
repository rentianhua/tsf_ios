//
//  SuccessNotesCell.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/25.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "SuccessNotesCell.h"
#import "OtherHeader.h"

@implementation SuccessNotesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self.selectionStyle=UITableViewCellSelectionStyleNone;
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat margin=10;
        UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(margin, margin, kMainScreenWidth/5, 21)];
        label1.text=@"2室1厅";
        label1.font=[UIFont systemFontOfSize:12];
        label1.textColor=[UIColor blackColor];
        label1.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label1];
        self.label1=label1;
        
        UIView * lineView1=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), margin+5, 1, label1.bounds.size.height-5-margin)];
        lineView1.backgroundColor=SeparationLineColor;
        [self addSubview:lineView1];
        
        UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+1, margin , kMainScreenWidth/5, 21)];
        label2.text=@"67m^2";
        label2.textAlignment=NSTextAlignmentCenter;
        label2.font=[UIFont systemFontOfSize:12];
        label2.textColor=[UIColor blackColor];
        [self addSubview:label2];
        self.label2=label2;
        
        UIView * lineView2=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame), margin+5, 1, label1.bounds.size.height-5-margin)];
        lineView2.backgroundColor=SeparationLineColor;
        [self addSubview:lineView2];
        UILabel * label3=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame)+1,margin , kMainScreenWidth/5, 21)];
        label3.text=@"中层/28层";
        label3.textAlignment=NSTextAlignmentCenter;
        label3.font=[UIFont systemFontOfSize:12];
        label3.textColor=[UIColor blackColor];
        [self addSubview:label3];
        self.label3=label3;
        
        UILabel * label4=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth*4/5, margin , kMainScreenWidth/5, 21)];
        label4.text=@"3800元/月";
        label4.font=[UIFont systemFontOfSize:12];
        label4.textColor=[UIColor redColor];
        [self addSubview:label4];
        self.label4=label4;
        
        UILabel * label5=[[UILabel alloc]initWithFrame:CGRectMake(margin, CGRectGetMaxY(label4.frame)+margin, kMainScreenWidth*4/5, 21)];
        label5.text=@"签约时间：2016-02-25";
        label5.font=[UIFont systemFontOfSize:12];
        label5.textAlignment=NSTextAlignmentCenter;
        label5.textColor=[UIColor blackColor];
        [self addSubview:label5];
        self.label5=label5;
        
        UILabel * label6=[[UILabel alloc]initWithFrame:CGRectMake(kMainScreenWidth*4/5-margin, CGRectGetMaxY(label4.frame)+margin, kMainScreenWidth/5-margin, 21)];
        label6.text=@"简装";
        label6.textAlignment=NSTextAlignmentCenter;
        label6.font=[UIFont systemFontOfSize:12];
        label6.textAlignment=NSTextAlignmentRight;
        label6.textColor=[UIColor redColor];
        [self addSubview:label6];
        self.label6=label6;
        
    }
    return self;
}


@end
