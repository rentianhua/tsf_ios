//
//  TSFYhqOrderVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/29.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFYhqOrderVC.h"

#import "TSFPayModel.h"
#import "ReturnInfoModel.h"

//=====================
#import "Order.h"
#import "GRpay.h"
//==========================
#import "OtherHeader.h"
#import "ZYWHttpEngine.h"
#import <Masonry.h>

#import "TSFMyCouponsVC.h"




#define NAVBTNW 26

@interface TSFYhqOrderVC (){
    Product * _product;
}

@property (nonatomic,strong)UIView * BGView;
@property (nonatomic,strong)UIView * lineView;
@property (nonatomic,strong)UILabel * label1;
@property (nonatomic,strong)UILabel * label2;
@property (nonatomic,strong)UILabel * label3;
@property (nonatomic,strong)UILabel * label4;

@property (nonatomic,strong)UIButton * confirmBtn;
@property (nonatomic,strong)UIButton * leftNavBtn;

@end

@implementation TSFYhqOrderVC

- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIButton *)confirmBtn{
    if (_confirmBtn==nil) {
        _confirmBtn=[[UIButton alloc]init];
        [_confirmBtn setTitle:@"确认付款" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_confirmBtn setBackgroundColor:NavBarColor];
        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}
- (UIView *)lineView{
    if (_lineView==nil) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=SeparationLineColor;
    }
    return _lineView;
}
- (UIView *)BGView{
    if (_BGView==nil) {
        _BGView=[[UIView alloc]init];
        _BGView.backgroundColor=[UIColor whiteColor];
        _BGView.layer.borderColor=SeparationLineColor.CGColor;
        _BGView.layer.borderWidth=1.0;
        
    }
    return _BGView;
}
- (UILabel *)label1{
    if (_label1==nil) {
        _label1=[[UILabel alloc]init];
        _label1.textColor=TITLECOL;
        _label1.font=[UIFont systemFontOfSize:14];
    }
    return _label1;
}
- (UILabel *)label2{
    if (_label2==nil) {
        _label2=[[UILabel alloc]init];
        _label2.textColor=TITLECOL;
        _label2.font=[UIFont systemFontOfSize:14];
    }
    return _label2;
}
- (UILabel *)label3{
    if (_label3==nil) {
        _label3=[[UILabel alloc]init];
        _label3.textColor=TITLECOL;
        _label3.font=[UIFont systemFontOfSize:14];
    }
    return _label3;
}
- (UILabel *)label4{
    if (_label4==nil) {
        _label4=[[UILabel alloc]init];
        _label4.textColor=TITLECOL;
        _label4.font=[UIFont systemFontOfSize:14];
    }
    return _label4;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"勾地订单";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
    [self.view addSubview:self.BGView];
    [self.BGView addSubview:self.lineView];
    [self.BGView addSubview:self.label1];
    [self.BGView addSubview:self.label2];
    [self.BGView addSubview:self.label3];
    [self.BGView addSubview:self.label4];
    
    [self.view addSubview:self.confirmBtn];
    
    __weak typeof(self)weakSelf=self;
    
    [weakSelf.BGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(80);
        make.height.mas_equalTo(200);
    }];
    
    [weakSelf.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(21);
    }];
    
    [weakSelf.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.top.equalTo(weakSelf.label1.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [weakSelf.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(weakSelf.lineView.mas_bottom).offset(10);
        make.height.mas_equalTo(21);
    }];
    
    [weakSelf.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(weakSelf.label2.mas_bottom).offset(10);
        make.height.mas_equalTo(21);
    }];
    
    [weakSelf.label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(weakSelf.label3.mas_bottom).offset(10);
        make.height.mas_equalTo(21);
    }];
    
    [weakSelf.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
    }];
    _label1.text=[NSString stringWithFormat:@"订单编号：%@",_model.result.order_no];
    _label2.text=[NSString stringWithFormat:@"房源名称：%@",_model.result.coupon_name];
    _label3.text=[NSString stringWithFormat:@"实付金额：%.2f",_model.result.shifu];
    _label4.text=@"未支付";
    
    
    
}

- (void)setModel:(ReturnInfoModel *)model{
    _model=model;
}

- (void)confirmAction:(UIButton *)payBtn{
    
    
    Product * p=[[Product alloc]init];
    p.subject=_model.result.coupon_name;
    p.price=_model.result.shifu;
    p.orderId=_model.result.order_no;
    _product=p;
    
    
    
    
    NSNotificationCenter * center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(payAction:) name:@"coupon" object:nil];
    
    
    //====================================我在这里调了支付宝去支付=====================
    [GRpay payWithProduct:p resultBlock:^(NSString *rsultString) {
        
          }];
    
}

- (void)payAction:(NSNotification *)noti{
    
    NSDictionary * userInfodict=noti.userInfo;
    
    NSString * resultStatus=userInfodict[@"resultStatus"];
    
    NSInteger status=[resultStatus integerValue];
    
    NSString * result=userInfodict[@"result"];
    
    if (status==9000) {//订单支付成功
        
        NSData  * strdata=[result dataUsingEncoding:kCFStringEncodingUTF8];
        NSDictionary * resultDict=[NSJSONSerialization JSONObjectWithData:strdata options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary * responseDict=resultDict[@"alipay_trade_app_pay_response"];
        
        NSString * out_trade_no=responseDict[@"out_trade_no"];
        NSString * total_amount=responseDict[@"total_amount"];
        NSString * trade_no=responseDict[@"trade_no"];
        
        
        
        //#define kNotifyURL @"http://www.taoshenfang.com/index.php?g=Api&m=Api&a=app_return_url"
        
        NSDictionary * param=@{@"out_trade_no":out_trade_no,
                               @"total_amount":total_amount,
                               @"trade_no":trade_no,
                               @"resultStatus":resultStatus};
        
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=Api&m=Api&a=app_return_url",URLSTR] params:param success:^(id responseObj) {
            
            TSFMyCouponsVC * VC=[[TSFMyCouponsVC alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
            
            
        } failure:^(NSError *error) {
            
        }];
        
        
    } else if (status==8000){//订单正在处理中
        
    } else if (status==4000){//订单支付失败
        
    } else if (status==6001){//订单取消
        
    } else if (status==6002){//网络链接出错
        
    }
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"coupon" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
