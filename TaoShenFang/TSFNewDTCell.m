//
//  TSFNewDTCell.m
//  TaoShenFang
//
//  Created by YXM on 16/11/30.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFNewDTCell.h"

@implementation TSFNewDTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.label3.layer.masksToBounds=YES;
    self.label3.layer.cornerRadius=3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
