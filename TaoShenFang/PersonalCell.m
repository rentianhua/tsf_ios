//
//  PersonalCell.m
//  TaoShenFangTest
//
//  Created by YXM on 16/8/16.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "PersonalCell.h"
#import <Masonry.h>
#import "OtherHeader.h"
@implementation PersonalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self.selectionStyle=UITableViewCellSelectionStyleNone;
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel * left=[UILabel new];
        left.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:left];
        left.textAlignment=NSTextAlignmentLeft;
        [left mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
            make.height.mas_equalTo(21);
            make.width.mas_equalTo(120);
        }];
        self.leftLabel=left;
        
        UIButton * rightBtn=[UIButton new];
        rightBtn.hidden=NO;
        [rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [self.contentView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
            make.height.mas_equalTo(21);
            make.width.mas_equalTo(18);
        }];
        self.rightButton=rightBtn;
        
        UILabel * right=[UILabel new];
        right.hidden=YES;
        right.textAlignment=NSTextAlignmentRight;
        right.font=[UIFont systemFontOfSize:14];
        right.textColor=DESCCOL;
        [self.contentView addSubview:right];
        [right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(left.mas_right).offset(20);
            make.right.equalTo(rightBtn.mas_left).offset(0);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(21);
        }];
        self.rightLabel=right;

        
        UIButton * head=[UIButton new];
        head.hidden=YES;
        [self.contentView addSubview:head];
        [head mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(50);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(rightBtn.mas_left).offset(0);
        }];
        self.headButton=head;
        head.layer.cornerRadius=25;
        head.layer.masksToBounds=YES;

    }
    return self;
}

@end
