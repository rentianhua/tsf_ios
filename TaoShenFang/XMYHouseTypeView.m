//
//  XMYHouseTypeView.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/19.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "XMYHouseTypeView.h"
#import <Masonry.h>
#import "OtherHeader.h"
#import "HouseModel.h"
@interface XMYHouseTypeView ()



@property (nonatomic,strong)UILabel * label1;//售价
@property (nonatomic,strong)UILabel * label3;//房型
@property (nonatomic,strong)UILabel * label5;//面积
@property (nonatomic,strong)UILabel * label2;
@property (nonatomic,strong)UILabel * label4;
@property (nonatomic,strong)UILabel * label6;

@property (nonatomic,strong)UIView * lineView1;
@property (nonatomic,strong)UIView * lineView2;



@end

@implementation XMYHouseTypeView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor=[UIColor whiteColor];
        
        _label3=[UILabel new];
        _label3.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_label3];
        _label3.textColor=[UIColor grayColor];
        _label3.font=[UIFont systemFontOfSize:16];
        
        [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.bottom.equalTo(self.contentView.mas_centerY).offset(0);
            make.width.mas_equalTo(kMainScreenWidth*0.33);
            make.height.mas_equalTo(30);
        }];
        
        _label1=[UILabel new];
        _label1.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_label1];
        _label1.textColor=[UIColor grayColor];
        _label1.font=[UIFont systemFontOfSize:16];
        
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.and.bottom.and.height.equalTo(_label3);
        }];
        
        _label5=[UILabel new];
        _label5.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_label5];
        _label5.textColor=[UIColor grayColor];
        _label5.font=[UIFont systemFontOfSize:16];
        [_label5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.width.and.bottom.and.height.equalTo(_label3);
        }];

        _label2=[UILabel new];
        _label2.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_label2];
        _label2.textColor=NavBarColor;
        _label2.font=[UIFont systemFontOfSize:16];
        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.height.equalTo(_label1);
            make.top.equalTo(_label1.mas_bottom).offset(5);
        }];

        _label4=[UILabel new];
        _label4.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_label4];
        _label4.textColor=NavBarColor;
        _label4.font=[UIFont systemFontOfSize:16];
        [_label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.height.equalTo(_label3);
            make.top.equalTo(_label3.mas_bottom).offset(5);
        }];
        
        _label6=[UILabel new];
        _label6.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_label6];
        _label6.textColor=NavBarColor;
        _label6.font=[UIFont systemFontOfSize:16];
        [_label6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.height.equalTo(_label5);
            make.top.equalTo(_label5.mas_bottom).offset(5);
        }];
        
        _lineView1=[UIView new];
        [self.contentView addSubview:_lineView1];
        _lineView1.backgroundColor=SeparationLineColor;
        [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_label1.mas_right).offset(0);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(40);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        _lineView2=[UIView new];
        [self.contentView addSubview:_lineView2];
        _lineView2.backgroundColor=SeparationLineColor;
        [_lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_label3.mas_right).offset(0);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(40);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];

    }
    return self;
}

- (void)configHeaderWithModel:(HouseModel *)model{
    
    CGFloat margin=10;
    CGFloat labelY=20;
    CGFloat labelW=(kMainScreenWidth-margin*2)/3;
    NSArray * arr;
    if ([model.catid isEqualToNumber:@6]) {
        _label1.text=@"售价";
        _label3.text=@"户型";
        _label5.text=@"面积";
    } else{
        _label1.text=@"租金";
        _label3.text=@"户型";
        _label5.text=@"面积";
    }
    
    for (int i=0; i<3; i++) {
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(margin+i*labelW, labelY, labelW, 21)];
        label.textColor=[UIColor blackColor];
        label.text=arr[i];
        label.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        
    }
    
    if ([model.catid isEqualToNumber:@6]) {
        _label2.text=[NSString stringWithFormat:@"%@万",model.zongjia];
        _label4.text=[NSString stringWithFormat:@"%@平米",model.jianzhumianji];
        _label6.text=[NSString stringWithFormat:@"%@室%@厅",model.shi,model.ting];
        
    } else{
        _label2.text=[NSString stringWithFormat:@"%@元/月",model.zujin];
        _label4.text=[NSString stringWithFormat:@"%@室%@厅",model.shi,model.ting];
        _label6.text=[NSString stringWithFormat:@"%@平米",model.mianji];
        
    }

}

@end
