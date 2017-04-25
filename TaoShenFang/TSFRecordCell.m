//
//  TSFRecordCell.m
//  TaoShenFang
//
//  Created by YXM on 16/12/15.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFRecordCell.h"

@implementation TSFRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
