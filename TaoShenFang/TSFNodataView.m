//
//  TSFNodataView.m
//  TaoShenFang
//
//  Created by YXM on 16/11/4.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFNodataView.h"
#import "OtherHeader.h"

@interface TSFNodataView ()

@property (nonatomic,strong)UIView * BGView;

@end
@implementation TSFNodataView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        
        
        _BGView=[[UIView alloc]init];
        _BGView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:_BGView];
        
        _label=[[UILabel alloc]init];
        _label.text=@"暂无数据";
        _label.font=[UIFont systemFontOfSize:16];
        _label.textAlignment=NSTextAlignmentLeft;
        _label.textColor=DESCCOL;
        [_BGView addSubview:_label];
    }
    return  self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selfW=self.bounds.size.width;
    CGFloat selfH=self.bounds.size.height;
    
    _BGView.frame=CGRectMake(0, 0, selfW, selfH-10);
    
    CGFloat BGH=_BGView.bounds.size.height;
    
    _label.frame=CGRectMake(15, BGH*0.2, selfW-30, BGH*0.6);

}



@end
