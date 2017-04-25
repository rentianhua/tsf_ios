//
//  MoreInformationFooterView.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/22.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "MoreInformationFooterView.h"
#import "OtherHeader.h"
@implementation MoreInformationFooterView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor=[UIColor whiteColor];
        UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth-20, 50)];
        button.backgroundColor=SeparationLineColor;
        [button setTitle:@"查看更多" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self.contentView addSubview:button];
        self.button=button;
    }
    return self;
}

@end
