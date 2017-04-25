//
//  TSFContractView.m
//  TaoShenFang
//
//  Created by YXM on 16/11/18.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFContractView.h"
#import <Masonry.h>
#import "OtherHeader.h"

@interface TSFContractView ()

@property (nonatomic,strong)UIButton * cancelBtn;
@property (nonatomic,strong)UITextView * textView;
@property (nonatomic,strong)UIButton * aggreeBtn;
@property (nonatomic,strong)UIButton * confirmBtn;
@property (nonatomic,strong)UIView * BGView;
@property (nonatomic,strong)UILabel * titleLabel;


@end


@implementation TSFContractView

- (UILabel *)titleLabel{
    if (_titleLabel==nil) {
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.textColor=TITLECOL;
        _titleLabel.text=@"勾地须知";
        _titleLabel.font=[UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}
- (UIView *)BGView{
    if (_BGView==nil) {
        _BGView=[[UIView alloc]init];
        _BGView.backgroundColor=[UIColor whiteColor];
        _BGView.layer.cornerRadius=3;
        _BGView.layer.masksToBounds=YES;
    }
    return _BGView;
}
- (void)setContractstring:(NSString *)contractstring{
    
    _contractstring=contractstring;
    if (contractstring.length==0) {
        self.textView.text=@"";
    } else{
        self.textView.text=_contractstring; 
    }
   
    
}
- (UIButton *)cancelBtn{
    if (_cancelBtn==nil) {
        _cancelBtn=[[UIButton alloc]init];
        [_cancelBtn setImage:[UIImage imageNamed:@"cancel_02"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UITextView * )textView{
    if (_textView==nil) {
        _textView=[[UITextView alloc]init];
        _textView.layer.borderColor=SeparationLineColor.CGColor;
        _textView.layer.borderWidth=2.0;
        _textView.layer.masksToBounds=YES;
        _textView.layer.cornerRadius=3;
        
    }
    return _textView;
}


- (UIButton *)aggreeBtn{
    if (_aggreeBtn==nil) {
        _aggreeBtn=[[UIButton alloc]init];
        [_aggreeBtn setImage:[UIImage imageNamed:@"select_02"] forState:UIControlStateNormal];
        [_aggreeBtn setImage:[UIImage imageNamed:@"select_01"] forState:UIControlStateSelected];
        [_aggreeBtn setTitle:@"我同意此协议" forState:UIControlStateNormal];
        [_aggreeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_aggreeBtn setTitleColor:TITLECOL forState:UIControlStateNormal];
        [_aggreeBtn addTarget:self action:@selector(aggreeAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _aggreeBtn;
}

- (UIButton *)confirmBtn{
    if (_confirmBtn==nil) {
        _confirmBtn=[[UIButton alloc]init];
        [_confirmBtn setTitle:@"确认勾地" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_img_02"] forState:UIControlStateDisabled];
        [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_img_01"] forState:UIControlStateNormal];
        
        _confirmBtn.enabled=NO;
        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        }];

        
        
        [self addSubview:self.BGView];
        [self.BGView addSubview:self.cancelBtn];
        [self.BGView addSubview:self.titleLabel];
        [self.BGView addSubview:self.aggreeBtn];
        [self.BGView addSubview:self.confirmBtn];
        [self.BGView addSubview:self.textView];
        
        
        self.textView.textColor=TITLECOL;
        self.textView.editable=NO;
        
        
        
        __weak typeof(self)weakSelf=self;
        
        [weakSelf.BGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(40);
            make.bottom.mas_equalTo(-104);
        }];
        
        
        [weakSelf.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        [weakSelf.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.BGView.mas_centerX);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(10);
        }];
        
        [weakSelf.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.mas_centerX).offset(0);
            make.bottom.mas_equalTo(-20);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(30);
        }];
        
        [weakSelf.aggreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.equalTo(weakSelf.confirmBtn.mas_top).offset(-10);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(30);
        }];
        
        [weakSelf.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.equalTo(weakSelf.cancelBtn.mas_bottom).offset(10);
            make.right.mas_equalTo(-15);
            make.bottom.equalTo(weakSelf.aggreeBtn.mas_top).offset(-10);
            
        }];
        
        
        
    }
    return self;
}
//取消
- (void)cancelAction:(UIButton *)cancelBtn{
    if (self.superview) {
        [self removeFromSuperview];
    }
}
//同意
- (void)aggreeAction:(UIButton *)aggreeBtn{
    aggreeBtn.selected=!aggreeBtn.selected;
    
    self.confirmBtn.enabled=!self.confirmBtn.enabled;
    
}
//确定
- (void)confirmAction:(UIButton *)confirmBtn{
    
    __weak typeof(self)weakSelf=self;
    
    weakSelf.confirmblock();
}





@end
