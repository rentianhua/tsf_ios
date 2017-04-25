//
//  TSFBlockCell.m
//  TaoShenFang
//
//  Created by YXM on 16/10/31.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFBlockCell.h"

@implementation TSFBlockCell

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
