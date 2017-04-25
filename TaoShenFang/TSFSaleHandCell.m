//
//  TSFSaleHandCell.m
//  TaoShenFang
//
//  Created by YXM on 16/10/20.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFSaleHandCell.h"

@implementation TSFSaleHandCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor=[UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1.0];
    self.BGView.layer.masksToBounds=YES;
    self.BGView.layer.cornerRadius=5;
    
    self.BGView.backgroundColor=[UIColor whiteColor];

    
    self.btn1.layer.masksToBounds=YES;
    self.btn1.layer.cornerRadius=5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
