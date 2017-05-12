//
//  TSFAgentCell.m
//  TaoShenFang
//
//  Created by YXM on 16/11/3.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFAgentCell.h"
#import <Masonry.h>
#import "OtherHeader.h"
#import "BQLabel.h"
#define BQFONT [UIFont systemFontOfSize:8.5]

@interface TSFAgentCell ()


@property (nonatomic,strong)BQLabel * biaoqian1;
@property (nonatomic,strong)BQLabel * biaoqian2;
@property (nonatomic,strong)BQLabel * biaoqian3;
@property (nonatomic,strong)BQLabel * biaoqian4;
@property (nonatomic,strong)BQLabel * biaoqian5;
@property (nonatomic,strong)BQLabel * biaoqian6;

@end

@implementation TSFAgentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    BQLabel * biaoqian1=[[BQLabel alloc]init];
    biaoqian1.font=BQFONT;
    biaoqian1.textColor=UIColorFromRGB(0Xea8010);
    [self.labelView addSubview:biaoqian1];
    self.biaoqian1=biaoqian1;
    biaoqian1.hidden=YES;// UIColorFromRGB(0Xf0eff5);
    biaoqian1.layer.borderColor=UIColorFromRGB(0Xea8010).CGColor;
    biaoqian1.layer.borderWidth=0.9;
    biaoqian1.textInsets=UIEdgeInsetsMake(2, 0, 2, 0);
    
    BQLabel * biaoqian2=[[BQLabel alloc]init];
    biaoqian2.font=BQFONT;
    biaoqian2.textColor=UIColorFromRGB(0X33475f);
    [self.labelView addSubview:biaoqian2];
    self.biaoqian2=biaoqian2;
    self.biaoqian2.hidden=YES;//33475f
    biaoqian2.layer.borderColor=UIColorFromRGB(0X33475f).CGColor;
    biaoqian2.layer.borderWidth=0.9;
    biaoqian2.textInsets=UIEdgeInsetsMake(2, 0, 2, 0);
    
    BQLabel * biaoqian3=[[BQLabel alloc]init];
    biaoqian3.textColor=UIColorFromRGB(0Xf4c600);
    biaoqian3.font=BQFONT;
    [self.labelView addSubview:biaoqian3];
    self.biaoqian3=biaoqian3;
    biaoqian3.hidden=YES;
    biaoqian3.layer.borderColor=UIColorFromRGB(0Xf4c600).CGColor;
    biaoqian3.layer.borderWidth=0.9;
    biaoqian3.textInsets=UIEdgeInsetsMake(2, 0, 2, 0);
    
    BQLabel * biaoqian4=[[BQLabel alloc]init];
    biaoqian4.textColor=UIColorFromRGB(0X11cd6e);
    biaoqian4.font=BQFONT;
    [self.labelView addSubview:biaoqian4];
    self.biaoqian4=biaoqian4;
    biaoqian4.hidden=YES;
    biaoqian4.layer.borderColor=UIColorFromRGB(0X11cd6e).CGColor;
    biaoqian4.layer.borderWidth=0.9;
    biaoqian4.textInsets=UIEdgeInsetsMake(2, 0, 2, 0);
    
    BQLabel * biaoqian5=[[BQLabel alloc]init];
    biaoqian5.textColor=UIColorFromRGB(0XCC6699);
    biaoqian5.font=BQFONT;
    [self.labelView addSubview:biaoqian5];
    self.biaoqian5=biaoqian5;
    biaoqian5.hidden=YES;
    biaoqian5.layer.borderColor=UIColorFromRGB(0XCC6699).CGColor;
    biaoqian5.layer.borderWidth=0.9;
    biaoqian5.textInsets=UIEdgeInsetsMake(2, 0, 2, 0);
    
    BQLabel * biaoqian6=[[BQLabel alloc]init];
    biaoqian6.textColor=UIColorFromRGB(0XFFB6C1);
    biaoqian6.font=BQFONT;
    [self.labelView addSubview:biaoqian6];
    self.biaoqian6=biaoqian6;
    biaoqian6.hidden=YES;
    biaoqian6.layer.borderColor=UIColorFromRGB(0XFFB6C1).CGColor;
    biaoqian6.layer.borderWidth=0.9;
    biaoqian6.textInsets=UIEdgeInsetsMake(2, 0, 2, 0);
}


- (void)setBiaoqian:(NSString *)biaoqian{
    _biaoqian=biaoqian;
    
    if (_biaoqian.length==0) {
        return;
    }
    NSArray * array=[_biaoqian componentsSeparatedByString:@","];
    _biaoqian1.hidden=YES;
    _biaoqian2.hidden=YES;
    _biaoqian3.hidden=YES;
    _biaoqian4.hidden=YES;
    _biaoqian5.hidden=YES;
    _biaoqian6.hidden=YES;
    
    switch (array.count) {
        case 0:
            break;
        case 1:{
            _biaoqian1.hidden=NO;
            
            [_biaoqian1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
                
            }];
            _biaoqian1.text=[NSString stringWithFormat:@" %@ ",array[0]];
        }
            
            break;
        case 2:{
            _biaoqian1.hidden=NO;
            _biaoqian2.hidden=NO;
            
            [_biaoqian1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
                
                
            }];
            
            _biaoqian1.text=[NSString stringWithFormat:@" %@ ",array[0]];
            
            [_biaoqian2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_biaoqian1.mas_right).offset(3);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
            }];
            _biaoqian2.text=[NSString stringWithFormat:@" %@ ",array[1]];
            
        }
            
            break;
        case 3:{
            _biaoqian1.hidden=NO;
            _biaoqian2.hidden=NO;
            _biaoqian3.hidden=NO;

            [_biaoqian1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
                
            }];
            
            _biaoqian1.text=[NSString stringWithFormat:@" %@ ",array[0]];
            
            
            [_biaoqian2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_biaoqian1.mas_right).offset(3);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
            }];
            _biaoqian2.text=[NSString stringWithFormat:@" %@ ",array[1]];
            
            [_biaoqian3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_biaoqian2.mas_right).offset(3);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
            }];
            _biaoqian3.text=[NSString stringWithFormat:@" %@ ",array[2]];
            
        }
            
            break;
        case 4:{
            _biaoqian1.hidden=NO;
            _biaoqian2.hidden=NO;
            _biaoqian3.hidden=NO;
            _biaoqian4.hidden=NO;
            
            [_biaoqian1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
                
            }];
            
            _biaoqian1.text=[NSString stringWithFormat:@" %@ ",array[0]];
            
            [_biaoqian2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_biaoqian1.mas_right).offset(3);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
            }];
            _biaoqian2.text=[NSString stringWithFormat:@" %@ ",array[1]];
            
            [_biaoqian3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_biaoqian2.mas_right).offset(3);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
            }];
            _biaoqian3.text=[NSString stringWithFormat:@" %@ ",array[2]];
            
            [_biaoqian4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_biaoqian3.mas_right).offset(3);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
            }];
            _biaoqian4.text=[NSString stringWithFormat:@" %@ ",array[3]];
            
        }
            
            break;
        case 5:{
            _biaoqian1.hidden=NO;
            _biaoqian2.hidden=NO;
            _biaoqian3.hidden=NO;
            _biaoqian4.hidden=NO;
            _biaoqian5.hidden=NO;

            [_biaoqian1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
                
            }];
            
            _biaoqian1.text=[NSString stringWithFormat:@" %@ ",array[0]];
            
            [_biaoqian2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_biaoqian1.mas_right).offset(3);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
            }];
            _biaoqian2.text=[NSString stringWithFormat:@" %@ ",array[1]];
            
            [_biaoqian3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_biaoqian2.mas_right).offset(3);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
            }];
            _biaoqian3.text=[NSString stringWithFormat:@" %@ ",array[2]];
            
            [_biaoqian4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_biaoqian3.mas_right).offset(3);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
            }];
            _biaoqian4.text=[NSString stringWithFormat:@" %@ ",array[3]];
            
            [_biaoqian5 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_biaoqian4.mas_right).offset(3);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
            }];
            _biaoqian5.text=[NSString stringWithFormat:@" %@ ",array[4]];
        }
            
            break;
        case 6:{
            _biaoqian1.hidden=NO;
            _biaoqian2.hidden=NO;
            _biaoqian3.hidden=NO;
            _biaoqian4.hidden=NO;
            _biaoqian5.hidden=NO;
            _biaoqian6.hidden=NO;
            
            [_biaoqian1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
                
            }];
            
            _biaoqian1.text=[NSString stringWithFormat:@" %@ ",array[0]];
            
            [_biaoqian2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_biaoqian1.mas_right).offset(3);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
            }];
            _biaoqian2.text=[NSString stringWithFormat:@" %@ ",array[1]];
            
            [_biaoqian3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_biaoqian2.mas_right).offset(3);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
            }];
            _biaoqian3.text=[NSString stringWithFormat:@" %@ ",array[2]];
            
            [_biaoqian4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_biaoqian3.mas_right).offset(3);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
            }];
            _biaoqian4.text=[NSString stringWithFormat:@" %@ ",array[3]];
            
            [_biaoqian5 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_biaoqian4.mas_right).offset(3);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
            }];
            _biaoqian5.text=[NSString stringWithFormat:@" %@ ",array[4]];
            
            [_biaoqian6 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_biaoqian5.mas_right).offset(3);
                make.top.mas_equalTo(2);
                make.bottom.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(30);
            }];
            _biaoqian6.text=[NSString stringWithFormat:@" %@ ",array[5]];
        }
            
            break;
        default:
            break;
    }
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
