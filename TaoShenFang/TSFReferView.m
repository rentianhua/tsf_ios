//
//  TSFReferView.m
//  TaoShenFang
//
//  Created by YXM on 16/12/6.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFReferView.h"
#import "OtherHeader.h"
@interface TSFReferView ()

@property (nonatomic,strong)UIView * BGView;
@property (nonatomic,strong)UIView * altView;

@end

@implementation TSFReferView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
       
        _BGView=[[UIView alloc]init];
        _BGView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        [self addSubview:_BGView];
        
        
        _altView=[[UIView alloc]init];
        _altView.backgroundColor=[UIColor whiteColor];
        [_BGView addSubview:_altView];
        
        
        _headImg=[[UIButton alloc]init];
        [_altView addSubview:_headImg];
        
        _nameLab=[[UILabel alloc]init];
        [_altView addSubview:_nameLab];
        
        _commentLab=[[UILabel alloc]init];
        [_altView addSubview:_commentLab];
        
        _numLab=[[UILabel alloc]init];
        [_altView addSubview:_numLab];
        
        
        _messageBtn=[[UIButton alloc]init];
        [_altView addSubview:_messageBtn];
        [_messageBtn setImage:[UIImage imageNamed:@"message_liuyan"] forState:UIControlStateNormal];
        
        [_messageBtn addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _phoneBtn=[[UIButton alloc]init];
        [_altView addSubview:_phoneBtn];
        [_phoneBtn setImage:[UIImage imageNamed:@"phone_rent"] forState:UIControlStateNormal];
        
        [_phoneBtn addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
  
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    _BGView.frame=self.bounds;
    
     CGFloat width= [UIScreen mainScreen].bounds.size.width;
     CGFloat height= [UIScreen mainScreen].bounds.size.height;
    
    _altView.frame=CGRectMake(15, (height-100)*0.4, width-30, 100);
    _altView.layer.masksToBounds=YES;
    _altView.layer.cornerRadius=5;
    
    _headImg.frame=CGRectMake(10, 10, 80, 80);
    _headImg.layer.masksToBounds=YES;
    _headImg.layer.cornerRadius=40;
    [_headImg addTarget:self action:@selector(headAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _nameLab.frame=CGRectMake(CGRectGetMaxX(_headImg.frame)+10, 10, 80, 26);
    _nameLab.font=[UIFont systemFontOfSize:14];
    _nameLab.textColor=TITLECOL;
   
    
    _commentLab.frame=CGRectMake(_nameLab.frame.origin.x, CGRectGetMaxY(_nameLab.frame), 120, 26);
    _commentLab.textColor=DESCCOL;
    _commentLab.font=[UIFont systemFontOfSize:14];
    
    
    _numLab.frame=CGRectMake(_nameLab.frame.origin.x, CGRectGetMaxY(_commentLab.frame), 200,26);
    _numLab.textColor=ORGCOL;
    _numLab.font=[UIFont boldSystemFontOfSize:16];
    
    
    _phoneBtn.frame=CGRectMake(width-40-30, _commentLab.frame.origin.y, 30, 30);
    _messageBtn.frame=CGRectMake(CGRectGetMinX(_phoneBtn.frame)-40, _commentLab.frame.origin.y, 30, 30);
    
}

- (void)phoneAction:(UIButton *)phoneBtn{
    _phoneBlock();
    if (self.superview) {
        [self removeFromSuperview];
    }
    
}

- (void)messageAction:(UIButton *)messageBtn{
  
    if (self.messageBlock) {
        self.messageBlock();
    }
    if (self.superview) {
        [self removeFromSuperview];
    }
    
}


- (void)showView{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(_altView.frame, point)) {
        [self removeFromSuperview];
    }
    
}
//点击头像
- (void)headAction:(UIButton *)head{
    _headBlock();
    if (self.superview) {
        [self removeFromSuperview];
    }

    
}

@end
