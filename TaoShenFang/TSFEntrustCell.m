//
//  TSFEntrustCell.m
//  TaoShenFang
//
//  Created by YXM on 16/11/2.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFEntrustCell.h"

@implementation TSFEntrustCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _BGView.layer.cornerRadius=3;
    _BGView.layer.masksToBounds=YES;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
