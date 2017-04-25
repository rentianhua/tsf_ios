//
//  UpLoadIDCardCell.m
//  TaoShenFang
//
//  Created by YXM on 16/9/1.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "UpLoadIDCardCell.h"

@implementation UpLoadIDCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)upload:(UIButton *)sender {
}
@end
