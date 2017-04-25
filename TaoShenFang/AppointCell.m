//
//  AppointCell.m
//  TaoShenFang
//
//  Created by YXM on 16/8/30.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "AppointCell.h"

@implementation AppointCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
