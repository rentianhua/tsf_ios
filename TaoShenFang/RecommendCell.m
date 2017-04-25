//
//  RecommendCell.m
//  TaoShenFang
//
//  Created by YXM on 16/9/10.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "RecommendCell.h"
#import "NewHouseModel.h"
#import "HouseModel.h"
#import <UIImageView+WebCache.h>
#import "OtherHeader.h"
@implementation RecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NewHouseModel *)model{
    _model=model;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,_model.data.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
    self.label1.text=_model.data.title;
    self.label2.text=[NSString stringWithFormat:@"%@ %@ %@",_model.data.province_name,_model.data.city_name,_model.data.area_name];
    self.label3.text=_model.data.wuyeleixing;
    float junjia;
    if (_model.data.jianzhumianji!=0) {
        junjia=[_model.data.zongjia floatValue]/[_model.data.jianzhumianji floatValue];
    }
   
    self.label4.text=[NSString stringWithFormat:@"%.f元/㎡",junjia*10000];
}



@end
