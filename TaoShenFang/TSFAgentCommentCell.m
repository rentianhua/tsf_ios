//
//  TSFAgentCommentCell.m
//  TaoShenFang
//
//  Created by YXM on 16/11/3.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFAgentCommentCell.h"

@implementation TSFAgentCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.imgView.layer.masksToBounds=YES;
    self.imgView.layer.cornerRadius=20;
    self.label2.numberOfLines=0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
