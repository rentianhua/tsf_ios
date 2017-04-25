//
//  TSFRentCell.m
//  TaoShenFang
//
//  Created by YXM on 16/11/1.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFRentCell.h"

@implementation TSFRentCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
