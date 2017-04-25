//
//  RentLookCell.m
//  TaoShenFang
//
//  Created by YXM on 16/9/11.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "RentLookCell.h"

@implementation RentLookCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
