//
//  AttentionHandCell.m
//  TaoShenFang
//
//  Created by YXM on 16/9/26.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "AttentionHandCell.h"

@implementation AttentionHandCell

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
