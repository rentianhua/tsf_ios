//
//  ExtruHouseListCell.m
//  TaoShenFangTest
//
//  Created by YXM on 16/8/16.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "ExtruHouseListCell.h"

@implementation ExtruHouseListCell

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
