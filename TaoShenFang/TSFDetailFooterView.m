//
//  TSFDetailFooterView.m
//  TaoShenFang
//
//  Created by YXM on 16/11/14.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFDetailFooterView.h"
#import "OtherHeader.h"
@interface TSFDetailFooterView ()



@end

@implementation TSFDetailFooterView

- (void)setSection:(NSInteger)section{
    _section=section;
    _moreBtn.tag=_section;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier  {
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        

        
        _BGView=[[UIView alloc]init];
        _BGView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:_BGView];
        
        _moreBtn=[[UIButton alloc]init];
        _moreBtn.backgroundColor=RGB(247, 247, 247, 1.0);
        [_moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:DESCCOL forState:UIControlStateNormal];
        [_moreBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        
        [_BGView addSubview:_moreBtn];
        
        [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)moreAction:(UIButton *)button{
    
    UITableView * tableView=(UITableView *)self.superview;
    
    if ([_delegate respondsToSelector:@selector(tableView:selectFooter:)]) {
        [_delegate tableView:tableView selectFooter:button.tag];
    }
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _BGView.frame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-20);
    _moreBtn.frame=CGRectMake(15, 10, _BGView.bounds.size.width-30, 40);
}

@end
