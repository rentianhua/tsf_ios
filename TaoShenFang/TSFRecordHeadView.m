//
//  TSFRecordHeadView.m
//  TaoShenFang
//
//  Created by YXM on 16/12/19.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFRecordHeadView.h"
#import "OtherHeader.h"
#import <Masonry.h>


@interface TSFRecordHeadView ()

@property (nonatomic,strong)UILabel * label1;
@property (nonatomic,strong)UILabel * label2;
@property (nonatomic,strong)UILabel * label3;

@end


@implementation TSFRecordHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        _label1=[[UILabel alloc]init];
        _label1.text=@"类型";
        _label1.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:_label1];
        _label1.textAlignment=NSTextAlignmentLeft;
        
        _label2=[[UILabel alloc]init];
        _label2.text=@"状态";
        _label2.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:_label2];
        _label2.textAlignment=NSTextAlignmentCenter;
        
        _label3=[[UILabel alloc]init];
        _label3.text=@"时间";
        _label3.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:_label3];
        _label3.textAlignment=NSTextAlignmentRight;
        
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    __weak typeof(self)weakSelf=self;
    
    [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.label1.mas_right).offset(20);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
    
    [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.label2.mas_right).offset(10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    
    
}






@end
