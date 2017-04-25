//
//  TSFMessageCell.m
//  TaoShenFang
//
//  Created by YXM on 16/12/20.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFMessageCell.h"

@implementation TSFMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.button.layer.masksToBounds=YES;
    self.button.layer.cornerRadius=25;

    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
