//
//  NewHouseListCell.m
//  TaoShenFangTest
//
//  Created by YXM on 16/8/20.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "NewHouseListCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+SDAutoLayout.h"
#import "OtherHeader.h"
#import "HouseModel.h"
#define ImgViewW kMainScreenWidth *0.25
#define ImgViewH ImgViewW*2/3
@interface NewHouseListCell ()

@property (nonatomic,strong)UIImageView * imgView;
@property (nonatomic,strong)UILabel * label1;
@property (nonatomic,strong)UILabel * label2;
@property (nonatomic,strong)UILabel * label3;
@property (nonatomic,strong)UILabel * label4;
@property (nonatomic,strong)UILabel * label5;

@end

@implementation NewHouseListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        UIImageView * imgView=[UIImageView new];
        [self.contentView addSubview:imgView];
        self.imgView=imgView;
        
        CGFloat margin1=20;
        CGFloat margin2=10;
        imgView.sd_layout
        .leftSpaceToView(self.contentView,margin1)
        .topSpaceToView(self.contentView,margin1)
        .heightIs(ImgViewH)
        .widthIs(ImgViewW);
        
        CGFloat labelH=ImgViewH * 0.25;
        UILabel * label1=[UILabel new];
        [self.contentView addSubview:label1];
        self.label1=label1;
        label1.font=[UIFont boldSystemFontOfSize:16];
        
        label1.sd_layout
        .leftSpaceToView(imgView,margin2)
        .topEqualToView(imgView)
        .rightSpaceToView(self.contentView,margin1)
        .heightIs(labelH);
        
        UILabel * label2=[UILabel new];
        [self.contentView addSubview:label2];
        self.label2=label2;
        label2.font=[UIFont systemFontOfSize:12];
        
        label2.sd_layout
        .leftEqualToView(label1)
        .rightEqualToView(label1)
        .topSpaceToView(label1,0)
        .heightIs(labelH);
        
        
        CGFloat label1W=(kMainScreenWidth-ImgViewW-margin1*2-margin2);
        
        UILabel * label3=[UILabel new];
        [self.contentView addSubview:label3];
        self.label3=label3;
        label3.font=[UIFont systemFontOfSize:12];
        label3.textColor=[UIColor grayColor];
        label3.sd_layout
        .leftEqualToView(label2)
        .topSpaceToView(label2,0)
        .widthIs(label1W *0.4)
        .heightIs(labelH);
        
        UILabel * label4=[UILabel new];
        label4.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:label4];
        self.label4=label4;
        label4.font=[UIFont systemFontOfSize:12];
        label4.textColor=NavBarColor;
        label4.sd_layout
        .rightSpaceToView(self.contentView,margin1)
        .topEqualToView(label3)
        .heightIs(labelH)
        .widthIs(label1W *0.6);
        
        UILabel * label5=[UILabel new];
        [self.contentView addSubview:label5];
        self.label5=label5;
        label5.textColor=[UIColor grayColor];
        label5.font=[UIFont systemFontOfSize:12];
        
        label5.sd_layout
        .leftEqualToView(label1)
        .rightEqualToView(label1)
        .heightIs(labelH)
        .topSpaceToView(label3,0);
        
        [self setupAutoHeightWithBottomView:imgView bottomMargin:margin1];
        
    }
    return self;
}

- (void)setModel:(HouseModel *)model
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
    self.label1.text=model.title;
    self.label2.text=model.loupandizhi;
    if ([model.jianzhumianji isEqualToString:@"0"] || model.jianzhumianji.length==0) {
        self.label3.text=@"";
    } else{
        self.label3.text=[NSString stringWithFormat:@"%@㎡",model.jianzhumianji];
    }
    if ([model.junjia isEqualToString:@"0"] || model.junjia.length==0) {
        NSString * str=@"价格待定";
        [self.label4 setAttributedText:[self price:str len:str.length]];
    } else{
    NSString * label4Str=[NSString stringWithFormat:@"%@元/㎡",model.junjia];
        [self.label4 setAttributedText:[self price:label4Str len:label4Str.length-3]];
    }
    self.label5.text=[NSString stringWithFormat:@"%@ %@",model.cityname,model.areaname];
}

//改变价格字体大小
- (NSMutableAttributedString *)price:(NSString *)text len:(NSInteger)len{
    
    NSMutableAttributedString * attributeStr=[[NSMutableAttributedString alloc]initWithString:text];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:16] range:NSMakeRange(0, len)];
    return attributeStr;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
