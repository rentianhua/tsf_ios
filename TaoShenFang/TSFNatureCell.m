//
//  TSFNatureCell.m
//  TaoShenFang
//
//  Created by YXM on 16/11/16.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFNatureCell.h"

@implementation TSFNatureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
