//
//  LouPanXinXiCell.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/25.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "LouPanXinXiCell.h"

@implementation LouPanXinXiCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel * leftLabel=[UILabel new];
        leftLabel.font=[UIFont systemFontOfSize:14];
        leftLabel.textColor=[UIColor grayColor];
        [self.contentView addSubview:leftLabel];
        self.leftLabel=leftLabel;
        
        UILabel * rightLabel=[UILabel new];
        rightLabel.font=[UIFont systemFontOfSize:14];
        rightLabel.textColor=[UIColor blackColor];
        [self.contentView addSubview:rightLabel];
        self.rightLabel=rightLabel;
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat margin=10;
    _leftLabel.frame=CGRectMake(margin, 0, 80, self.contentView.bounds.size.height);
    _rightLabel.frame=CGRectMake(CGRectGetMaxX(_leftLabel.frame)+margin, 0, self.contentView.bounds.size.width-CGRectGetMaxX(_leftLabel.frame)-margin*2, self.contentView.bounds.size.height);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
