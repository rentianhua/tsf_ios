//
//  TSFSearchView.m
//  TaoShenFang
//
//  Created by YXM on 16/10/14.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFSearchView.h"
#import <Masonry.h>

@interface TSFSearchView ()



@end

@implementation TSFSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=2;
        
        UILabel * label=[[UILabel alloc]init];
        label.font=[UIFont systemFontOfSize:14];
        label.textAlignment=NSTextAlignmentLeft;
        [self addSubview:label];
        self.label=label;
        
        UILabel * lineLabel=[[UILabel alloc]init];
        lineLabel.backgroundColor=[UIColor lightGrayColor];
        [self addSubview:lineLabel];
        self.linelabel=lineLabel;
 
        UIButton * button=[[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"new_search_01"] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14 ]];
        [self addSubview:button];
        self.button=button;
        button.contentEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title=title;
    _label.text=title;
    
    NSAttributedString * attrStr=[[NSAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    _label.frame=CGRectMake(0, 0, attrStr.size.width+10, self.frame.size.height);
    _linelabel.frame=CGRectMake(CGRectGetMaxX(_label.frame), 10, 1, self.frame.size.height-20);
    _button.frame=CGRectMake(CGRectGetMaxX(_linelabel.frame), 0, self.frame.size.width-CGRectGetMaxX(_linelabel.frame), self.frame.size.height);
  
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder=placeholder;
    [_button setTitle:[NSString stringWithFormat:@" %@",placeholder] forState:UIControlStateNormal];
}
- (void)searchAction:(UIButton *)button{
  
    self.searchBlock();
  
}

@end
