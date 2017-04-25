//
//  TSFCouponView.m
//  TaoShenFang
//
//  Created by YXM on 16/11/21.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFCouponView.h"
#import "OtherHeader.h"


@interface TSFCouponView ()

@property (nonatomic,strong)UILabel * titleLabel;

@property (nonatomic,strong)UIView * BGView;

@property (nonatomic,strong)UILabel * codeLabel;

@property (nonatomic,strong)UITextField * textField;

@property (nonatomic,strong)UIButton * commitBtn;


@property (nonatomic,strong)UIButton * cancelBtn;

@property (nonatomic,strong)UIView * altView;


@end

@implementation TSFCouponView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
      
        
        _BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _BGView.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
        [self addSubview:_BGView];
        
        
        
        _altView=[[UIView alloc]init];
        _altView.backgroundColor=[UIColor whiteColor];
        [_BGView addSubview:_altView];
        
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.text=@"删除优惠券";
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        [_altView addSubview:_titleLabel];
        
        
        _cancelBtn=[[UIButton alloc]init];
        [_cancelBtn setImage:[UIImage imageNamed:@"altcancel"] forState:UIControlStateNormal];
        
        [_altView addSubview:_cancelBtn];
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _codeLabel=[[UILabel alloc]init];
        _codeLabel.text=@"验证码";
        _codeLabel.font=[UIFont systemFontOfSize:14];
        [_altView addSubview:_codeLabel];
        
        _textField=[[UITextField alloc]init];
        _textField.layer.borderColor=SeparationLineColor.CGColor;
        _textField.layer.borderWidth=1.0;
        [_altView addSubview:_textField];
        
        _sendCodeBtn=[[UIButton alloc]init];
        _sendCodeBtn.backgroundColor=SeparationLineColor;
        _sendCodeBtn.layer.masksToBounds=YES;
        _sendCodeBtn.layer.cornerRadius=3;
        [_sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_sendCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_altView addSubview:_sendCodeBtn];
        [_sendCodeBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _commitBtn =[[UIButton alloc]init];
        [_commitBtn setTitle:@"确认删除" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_altView addSubview:_commitBtn];
        [_commitBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    
        _commitBtn.backgroundColor=NavBarColor;
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    _altView.layer.masksToBounds=YES;
    _altView.layer.cornerRadius=10;
    
    CGFloat altX=kMainScreenWidth*0.1;
    CGFloat altY=kMainScreenHeight*0.3;
    CGFloat altW=kMainScreenWidth*0.8;
    CGFloat altH=altW*0.8;

    _altView.frame=CGRectMake(altX, altY, altW, altH);
    _titleLabel.frame=CGRectMake(40, 0, _altView.bounds.size.width-80, 40);
    _cancelBtn.frame=CGRectMake(_altView.bounds.size.width-40, 5, 30, 30);
    
    _codeLabel.frame=CGRectMake(5, CGRectGetMaxY(_titleLabel.frame)+20, 50, 30);
    _textField.frame=CGRectMake(CGRectGetMaxX(_codeLabel.frame)+5, _codeLabel.frame.origin.y, altW-80-10-50-10, 30);
    
    _sendCodeBtn.frame=CGRectMake(altW-80-5, _textField.frame.origin.y, 80, 30);
    _commitBtn.frame=CGRectMake((altW-80)*0.5, CGRectGetMaxY(_textField.frame)+25, 80, 30);
    
    _commitBtn.layer.masksToBounds=YES;
    _commitBtn.layer.cornerRadius=3;
    
    _textField.layer.masksToBounds=YES;
    _textField.layer.cornerRadius=5;
    
}

- (void)cancelAction:(UIButton *)cancelBtn{
    
    [self removeFromSuperview];
}

- (void)sendAction:(UIButton *)sendBtn{
    _sendBlock();
}

- (void)commitAction:(UIButton *)commitAction{
    __weak typeof(self)weakSelf=self;
    _commitBlock(weakSelf.textField.text);
}



@end
