//
//  TSFCouponNoPayCell.m
//  TaoShenFang
//
//  Created by YXM on 16/11/21.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFCouponNoPayCell.h"
#import "OtherHeader.h"

@implementation TSFCouponNoPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor=BGCOLOR;
    self.BGView.backgroundColor=[UIColor whiteColor];
    self.BGView.layer.masksToBounds=YES;
    self.BGView.layer.cornerRadius=5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
