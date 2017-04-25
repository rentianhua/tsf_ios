//
//  TSFBuyYHQView.m
//  TaoShenFang
//
//  Created by YXM on 16/11/29.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFBuyYHQView.h"
#import "OtherHeader.h"
@interface TSFBuyYHQView ()

@property (nonatomic,strong)UIView * BGView;

@property (nonatomic,strong)UIView * altView;

@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * label1;
@property (nonatomic,strong)UILabel * label2;
@property (nonatomic,strong)UILabel * label3;
@property (nonatomic,strong)UILabel * label4;

@property (nonatomic,strong)UITextField * textField1;
@property (nonatomic,strong)UITextField * textField2;
@property (nonatomic,strong)UITextField * textField3;


@property (nonatomic,strong)UIButton * comfirmBtn;
@property (nonatomic,strong)UIButton * cancelBtn;

@end

@implementation TSFBuyYHQView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame: frame]) {
        
        _BGView=[[UIView alloc]init];
        _BGView.backgroundColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.8];
        [self addSubview:_BGView];
        
        _altView=[[UIView alloc]init];
        _altView.backgroundColor=[UIColor whiteColor];
        [_BGView addSubview:_altView];
        
        
        _label1=[[UILabel alloc]init];
        _label1.text=@"购房人";
        _label1.font=[UIFont systemFontOfSize:14];
        _label1.textColor=DESCCOL;
        [_altView addSubview:_label1];
        _label2=[[UILabel alloc]init];
        _label2.text=@"手机号";
        _label2.textColor=DESCCOL;
        _label2.font=[UIFont systemFontOfSize:14];
        [_altView addSubview:_label2];

        _label3=[[UILabel alloc]init];
        _label3.text=@"验证码";
        _label3.textColor=DESCCOL;
        _label3.font=[UIFont systemFontOfSize:14];
        [_altView addSubview:_label3];

        _textField1=[[UITextField alloc]init];
        _textField1.font=[UIFont systemFontOfSize:14];
        _textField1.placeholder=@" 请输入购房人姓名";
        [_altView addSubview:_textField1];
        
        _textField2=[[UITextField alloc]init];
        _textField2.font=[UIFont systemFontOfSize:14];
        _textField2.placeholder=@" 请输入购房人手机号";
        _textField2.keyboardType=UIKeyboardTypeNumberPad;
        [_altView addSubview:_textField2];
        
        _textField3=[[UITextField alloc]init];
        _textField3.font=[UIFont systemFontOfSize:14];
        _textField3.placeholder=@"";
        [_altView addSubview:_textField3];
        
        
        _codeBtn=[[UIButton alloc]init];
        [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        _codeBtn.backgroundColor=SeparationLineColor;
        [_codeBtn.titleLabel setFont:[UIFont systemFontOfSize:9]];
        [_codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_altView addSubview:_codeBtn];
        [_codeBtn addTarget:self action:@selector(codeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _comfirmBtn=[[UIButton alloc]init];
        _comfirmBtn.backgroundColor=NavBarColor;
        _comfirmBtn.layer.masksToBounds=YES;
        _comfirmBtn.layer.cornerRadius=5;
        [_comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_comfirmBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        [_comfirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_comfirmBtn addTarget:self action:@selector(comfirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [_altView addSubview:_comfirmBtn];
        
        _label4=[[UILabel alloc]init];
        _label4.textColor=DESCCOL;
        _label4.text=@"每位购房人只能购买一次优惠券";
        _label4.font=[UIFont systemFontOfSize:12];
        _label4.textAlignment=NSTextAlignmentCenter;
        [_altView addSubview:_label4];
        
        
        _cancelBtn=[[UIButton alloc]init];
        [_cancelBtn setImage:[UIImage imageNamed:@"altcancel"] forState:UIControlStateNormal];
        [_altView addSubview:_cancelBtn];
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];

        _titleLabel=[[UILabel alloc]init];
        _titleLabel.font=[UIFont systemFontOfSize:16];
        [_altView addSubview:_titleLabel];
        
    }
    return self;
}

- (void)setYhqDes:(NSString *)des
{
    _label4.text = des;
}

- (void)setYhqStr:(NSString *)yhqStr{
    _yhqStr=yhqStr;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _BGView.frame=self.frame;
    
    _altView.frame=CGRectMake(0, 0, self.frame.size.width*0.8, self.frame.size.width*0.6);
    
    CGFloat height=(self.frame.size.width*0.6-6*10)/6;
    CGFloat margin=10;
    CGFloat altW=self.altView.frame.size.width;
    
    _altView.center=CGPointMake(self.center.x, self.center.y);
    _altView.layer.masksToBounds=YES;
    _altView.layer.cornerRadius=5;
    
    _cancelBtn.frame=CGRectMake(_altView.frame.size.width-height, 0, height, height);
    
    _titleLabel.font=[UIFont boldSystemFontOfSize:16];
    _titleLabel.textColor=NavBarColor;
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.frame=CGRectMake(margin, 0, altW-height-margin*2, height);
    _titleLabel.text=_yhqStr;
    
    _label1.frame=CGRectMake(margin, height+margin, 60, height);
    _label2.frame=CGRectMake(margin, (height+margin)*2, 60, height);
    _label3.frame=CGRectMake(margin, (height+margin)*3, 60, height);
    
    _textField1.frame=CGRectMake(CGRectGetMaxX(_label1.frame), _label1.frame.origin.y, altW-60*2-margin*2, height);
    _textField2.frame=CGRectMake(CGRectGetMaxX(_label2.frame),  _label2.frame.origin.y, altW-60*2-margin*2, height);
    _textField3.frame=CGRectMake(CGRectGetMaxX(_label3.frame),  _label3.frame.origin.y, altW-60*2-margin*2, height);
    
    _textField1.layer.borderColor=SeparationLineColor.CGColor;
    _textField1.layer.borderWidth=1;
    _textField2.layer.borderColor=SeparationLineColor.CGColor;
    _textField2.layer.borderWidth=1;
    _textField3.layer.borderColor=SeparationLineColor.CGColor;
    _textField3.layer.borderWidth=1;
    
    _codeBtn.frame=CGRectMake(CGRectGetMaxX(_textField3.frame)+margin*0.5, _textField3.frame.origin.y, 60, height);
    _comfirmBtn.frame=CGRectMake((altW-80)*0.5, CGRectGetMaxY(_label3.frame)+margin, 80, height);
    _label4.frame=CGRectMake(10, CGRectGetMaxY(_comfirmBtn.frame)+margin, altW-20, height);
}

- (void)cancelAction:(UIButton *)cancelBtn{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)comfirmAction:(UIButton *)comfirmBtn{
    if (self.superview) {
        [self removeFromSuperview];
    }
    _comfirmBlock(_textField1.text,_textField2.text,_textField3.text);
}

- (void)codeAction:(UIButton *)codeBtn{
    _codeBlock(_textField2.text);
}

@end
