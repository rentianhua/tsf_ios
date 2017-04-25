//
//  FleaMarketTableCell.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/20.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "FleaMarketTableCell.h"
#import "OtherHeader.h"
#import "TSFAvgModel.h"
@implementation FleaMarketTableCell

- (void)setModel:(TSFAvgModel *)model{
    _model=model;
    
    
    NSMutableAttributedString * AttributedStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元/平",_model.avg_price]];
    NSInteger length=AttributedStr.length ;
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, length-3)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:RGB(255, 115, 38, 1.0) range:NSMakeRange(0, length-3)];
    self.leftLabel.attributedText=AttributedStr;
    
    
    NSMutableAttributedString * AttributedStr1=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@套",_model.comp_count]];
    NSInteger length1=AttributedStr1.length ;
    [AttributedStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, length1-1)];
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGB(0, 174, 102, 1.0) range:NSMakeRange(0, length1-1)];
    self.rightLabel.attributedText=AttributedStr1;
    
    self.label2.text=[NSString stringWithFormat:@"%@月成交量",_model.month];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.label1.textColor=RGB(173, 173, 173, 1.0);
    self.label2.textColor=RGB(173, 173, 173, 1.0);
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.grayView.backgroundColor=RGB(231, 231, 231, 1.0);
    self.lineView.backgroundColor=RGB(231, 231, 231, 1.0);
    
   
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
