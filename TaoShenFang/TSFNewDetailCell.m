//
//  TSFNewDetailCell.m
//  TaoShenFang
//
//  Created by YXM on 16/11/28.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFNewDetailCell.h"
#import "OtherHeader.h"
@implementation TSFNewDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.yhqBtn1.backgroundColor=NavBarColor;
    [self.yhqBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.yhqBtn2.backgroundColor=NavBarColor;
    [self.yhqBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.yhqBtn3.backgroundColor=NavBarColor;
    [self.yhqBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
