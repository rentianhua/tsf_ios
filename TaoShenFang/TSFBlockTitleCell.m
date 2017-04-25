//
//  TSFBlockTitleCell.m
//  TaoShenFang
//
//  Created by YXM on 16/12/8.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFBlockTitleCell.h"

@implementation TSFBlockTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.gouBtn.layer.masksToBounds=YES;
    self.gouBtn.layer.cornerRadius=5;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
