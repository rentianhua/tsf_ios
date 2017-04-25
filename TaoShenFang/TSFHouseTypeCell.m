//
//  TSFHouseTypeCell.m
//  TaoShenFang
//
//  Created by YXM on 16/11/15.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFHouseTypeCell.h"



@interface TSFHouseTypeCell ()

@property(nonatomic,strong)UIView*lineView;

@end



@implementation TSFHouseTypeCell


- (void)configCellWithPrice:(NSString * )price shi:(NSString *)shi ting:(NSString *)ting mianji:(NSString *)mianji{
    
    self.label1.text=[NSString stringWithFormat:@"%@万",price];
    self.label2.text=[NSString stringWithFormat:@"%@室%@厅",shi,ting];
    self.label3.text=[NSString stringWithFormat:@"%@平米",mianji];
}

-(UIView*)lineView{
    
    if(_lineView==nil) {
        
        _lineView= [[UIView alloc]init];
        
        _lineView.backgroundColor= [UIColor lightGrayColor]; //颜色可以自己调
        
        _lineView.alpha=0.3; // 透明度可以自己调
        
    }
    
    return _lineView;
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15);
    
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



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
