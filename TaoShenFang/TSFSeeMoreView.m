//
//  TSFSeeMoreView.m
//  TaoShenFang
//
//  Created by YXM on 16/11/4.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFSeeMoreView.h"
#import "OtherHeader.h"

@interface TSFSeeMoreView ()

@property (nonatomic,strong)UIView * BGView;

@end

@implementation TSFSeeMoreView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        
        
        
        _BGView=[[UIView alloc]init];
        _BGView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:_BGView];
        
        
        _button=[[UIButton alloc]init];
        _button.layer.borderColor=RGB(237, 27, 36, 1.0).CGColor;
        _button.layer.borderWidth=0.8;
        _button.layer.masksToBounds=YES;
        _button.layer.cornerRadius=3;
        [_button setTitle:@"查看更多" forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_button setTitleColor:RGB(237, 27, 36, 1.0) forState:UIControlStateNormal];
        [_BGView addSubview:_button];
        
        [_button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return  self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selfW=self.bounds.size.width;
    CGFloat selfH=self.bounds.size.height;
    
    _BGView.frame=CGRectMake(0, 0, selfW, selfH-10);
    
    CGFloat BGW=_BGView.bounds.size.width;
    CGFloat BGH=_BGView.bounds.size.height;
    
    _button.frame=CGRectMake(BGW*0.2, BGH*0.2, BGW*0.6, BGH*0.6);
}

- (void)btnClick:(UIButton *)button{
   
    UITableView * tableView=(UITableView *)self.superview;
    if ([_delegate respondsToSelector:@selector(tableView:selectFooter:)]) {
        [_delegate tableView:tableView selectFooter:_section];
    }
}


@end
