//
//  HandDetailFooter.m
//  TaoShenFang
//
//  Created by YXM on 16/9/11.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "HandDetailFooter.h"
#import <Masonry.h>
#import "OtherHeader.h"
@implementation HandDetailFooter

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor=[UIColor whiteColor];
        _button=[UIButton new];
        [self.contentView addSubview:_button];
        _button.backgroundColor=SeparationLineColor;
        [_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(40);
        }];
    }
    return self;
}
- (void)buttonClick:(UIButton *)button{
    self.clickBlock();
}
@end
