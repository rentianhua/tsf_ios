//
//  HandDetailBasicCell.m
//  TaoShenFang
//
//  Created by YXM on 16/9/10.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "HandDetailBasicCell.h"
#import "HouseModel.h"
#import "BQLabel.h"
#import "OtherHeader.h"
#import <Masonry.h>

#define BQFONT [UIFont systemFontOfSize:10]
@interface HandDetailBasicCell ()


@property(nonatomic,strong)UIView*lineView;

@property (nonatomic,strong)BQLabel * biaoqian1;
@property (nonatomic,strong)BQLabel * biaoqian2;
@property (nonatomic,strong)BQLabel * biaoqian3;
@property (nonatomic,strong)BQLabel * biaoqian4;

@end

@implementation HandDetailBasicCell

-(UIView*)lineView{
    
    if(_lineView==nil) {
        
        _lineView= [[UIView alloc]init];
        
        _lineView.backgroundColor= [UIColor lightGrayColor]; //颜色可以自己调
        
        _lineView.alpha=0.3; // 透明度可以自己调
        
    }
    
    return _lineView;
    
}



- (void)configCellWithModel:(HouseModel *)model{

     self.selectionStyle=UITableViewCellSelectionStyleNone;
    float junjia=0.0;
    if (model.jianzhumianji!=nil && ![model.jianzhumianji isEqualToString:@"0"] && model.jianzhumianji.length!=0) {
        float zj=[model.zongjia floatValue];
        float mj=[model.jianzhumianji floatValue];
        junjia=zj/mj;
        
    }
    if (junjia==0.0) {
        NSString * string1=[NSString stringWithFormat:@"均价：价格待定"];
        [_label1 setAttributedText:[self string:string1 len:3]];
    } else{
       NSString * string11=[NSString stringWithFormat:@"均价：%.f元/平",junjia*10000];
        [_label1 setAttributedText:[self string:string11 len:3]];
    }
    
    NSString * date=[model.guapaidate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString * string2=[NSString stringWithFormat:@"挂牌：%@",date];
    [_label2 setAttributedText:[self string:string2 len:3]];

    NSString * string3=[NSString stringWithFormat:@"楼层：%@/%@",model.ceng,model.zongceng];
    [_label3 setAttributedText:[self string:string3 len:3]];
    
    NSString * string4=[NSString stringWithFormat:@"朝向：%@",model.chaoxiang];
    [_label4 setAttributedText:[self string:string4 len:3]];
    
    NSString * string5=[NSString stringWithFormat:@"装修：%@",model.zhuangxiu];
    [_label5 setAttributedText:[self string:string5 len:3]];
    
    NSString * string6=[NSString stringWithFormat:@"楼型：%@",model.jianzhutype];
    [_label6 setAttributedText:[self string:string6 len:3]];
    
    NSString * string7=[NSString stringWithFormat:@"房龄：%@年",model.fangling];
    [_label7 setAttributedText:[self string:string7 len:3]];
    
    NSString * string8=[NSString stringWithFormat:@"区域：%@ %@",model.cityname,model.areaname];
    [_label8 setAttributedText:[self string:string8 len:3]];
    
    NSString * string9=[NSString stringWithFormat:@"看房时间：提前预约随时可看"];
    [_label9 setAttributedText:[self string:string9 len:5]];
    
    NSString * string10=[NSString stringWithFormat:@"房源编号：%@",model.bianhao];
    [_label10 setAttributedText:[self string:string10 len:5]];
    
    NSString * string11=[NSString stringWithFormat:@"小区名称：%@",model.xiaoquname];
    [_label11 setAttributedText:[self string:string11 len:5]];
    
    
    
    if (model.biaoqian.length==0) {
        return;
    }
    NSArray * array=[model.biaoqian componentsSeparatedByString:@","];
    
    switch (array.count) {
        case 0:
            
            break;
        case 1:{
            _biaoqian1.hidden=NO;
            _biaoqian2.hidden=YES;
            _biaoqian3.hidden=YES;
            _biaoqian4.hidden=YES;
            
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
            _biaoqian3.hidden=YES;
            _biaoqian4.hidden=YES;
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
            _biaoqian4.hidden=YES;
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
            
        default:
            break;
    }
}

- (NSMutableAttributedString *)string:(NSString *)string len:(NSInteger)len{
    
    NSMutableAttributedString * attrStr1=[[NSMutableAttributedString alloc]initWithString:string];
    [attrStr1 addAttribute:NSForegroundColorAttributeName value:DESCCOL range:NSMakeRange(0, len)];
   
    return attrStr1;
}

- (void)awakeFromNib{
    [super awakeFromNib]; self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    BQLabel * biaoqian1=[[BQLabel alloc]init];
    biaoqian1.font=BQFONT;
    biaoqian1.textColor=RGB(240, 165, 90, 1.0);
    [self.labelView addSubview:biaoqian1];
    self.biaoqian1=biaoqian1;
    biaoqian1.hidden=YES;// UIColorFromRGB(0Xf0eff5);
    biaoqian1.backgroundColor=RGB(252, 237, 217, 1.0);
    biaoqian1.layer.masksToBounds=YES;
    biaoqian1.layer.cornerRadius=3;
    biaoqian1.textInsets=UIEdgeInsetsMake(2, 0, 2, 0);
    
    BQLabel * biaoqian2=[[BQLabel alloc]init];
    biaoqian2.font=BQFONT;
    biaoqian2.textColor=RGB(39, 182, 116, 1.0);
    [self.labelView addSubview:biaoqian2];
    self.biaoqian2=biaoqian2;
    self.biaoqian2.hidden=YES;//33475f
    biaoqian2.backgroundColor=RGB(219, 243, 233, 1.0);
    // biaoqian2.layer.borderWidth=0.9;
    biaoqian2.textInsets=UIEdgeInsetsMake(2, 0, 2, 0);
    biaoqian2.layer.masksToBounds=YES;
    biaoqian2.layer.cornerRadius=3;
    
    
    BQLabel * biaoqian3=[[BQLabel alloc]init];
    biaoqian3.textColor=RGB(250, 129, 81, 1.0);
    biaoqian3.font=BQFONT;
    [self.labelView addSubview:biaoqian3];
    self.biaoqian3=biaoqian3;
    biaoqian3.hidden=YES;
    biaoqian3.backgroundColor=RGB(254, 233, 220, 1.0);
    //biaoqian3.layer.borderWidth=0.9;
    biaoqian3.textInsets=UIEdgeInsetsMake(2, 0, 2, 0);
    biaoqian3.layer.masksToBounds=YES;
    biaoqian3.layer.cornerRadius=3;
    
    
    
    BQLabel * biaoqian4=[[BQLabel alloc]init];
    biaoqian4.textColor=RGB(85, 159, 252, 1.0);
    biaoqian4.font=BQFONT;
    [self.labelView addSubview:biaoqian4];
    self.biaoqian4=biaoqian4;
    biaoqian4.hidden=YES;
    biaoqian4.backgroundColor=RGB(227, 229, 255, 1.0);
    //biaoqian4.layer.borderWidth=0.9;
    biaoqian4.textInsets=UIEdgeInsetsMake(2, 0, 2, 0);
    biaoqian4.layer.masksToBounds=YES;
    biaoqian4.layer.cornerRadius=3;
    
    
    [self.contentView addSubview:self.lineView];

}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //设置分割线的frame
    
    CGFloat lineX =self.textLabel.frame.origin.x;
    
    CGFloat lineH =1;
    
    CGFloat lineY =CGRectGetHeight(self.frame) - lineH;
    
    CGFloat lineW =CGRectGetWidth(self.frame) - lineX;
    
    self.lineView.frame=CGRectMake(lineX,lineY, lineW, lineH);
    
}

- (void)setHidenLine:(BOOL)hidenLine{
    
    _hidenLine= hidenLine;
    
    self.lineView.hidden= hidenLine;
    
}



@end
