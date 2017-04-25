//
//  MyHandTextCell.m
//  TaoShenFang
//
//  Created by YXM on 16/8/24.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "MyHandTextCell.h"
#import "OtherHeader.h"
@implementation MyHandTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
//    self.rightTextField.layer.borderColor=SeparationLineColor.CGColor;
//    self.rightTextField.layer.borderWidth=0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
