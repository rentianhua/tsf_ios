//
//  ApplyPhoneVC.m
//  TaoShenFang
//
//  Created by YXM on 16/8/27.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "ApplyPhoneVC.h"
#import "UserModel.h"
#import "ReturnInfoModel.h"
#import <MJExtension.h>
#import "OtherHeader.h"
#import "ZYWHttpEngine.h"
#import "YJProgressHUD.h"
#define NAVBTNW 20
@interface ApplyPhoneVC ()

@property (nonatomic,strong)UIButton * leftNavBtn;

@end

@implementation ApplyPhoneVC

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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColorFromRGB(0Xf0eff5);
    self.title=@"分机号管理";
    _textField.layer.borderColor=SeparationLineColor.CGColor;
    _textField.layer.borderWidth=1;
    _textField.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, self.textField.bounds.size.height)];
    _textField.leftViewMode=UITextFieldViewModeAlways;
    _textField.text=_model.username;
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    
    
    _rightBtn.backgroundColor=[UIColor lightGrayColor];
    [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.backgroundColor=NavBarColor;
    _rightBtn.layer.masksToBounds=YES;
    _rightBtn.layer.cornerRadius=5;
    if ([_model.zhuanjie isEqualToNumber:@1]) {
        [_rightBtn setTitle:@"解绑分机号" forState:UIControlStateNormal];
    } else{
         [_rightBtn setTitle:@"申请分机号" forState:UIControlStateNormal];
        
    }
}

- (void)setModel:(UserModel *)model{
    _model=model;
    _textField.textColor=[UIColor blackColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)rightClick:(id)sender {
    
    if ([_model.zhuanjie isEqualToNumber:@1 ]) {//解绑分机号
        NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=api&a=remove_vtel&tel=%@&userid=%@",URLSTR,_textField.text,_model.userid];
        
        __weak typeof(self)weakSelf=self;
        [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
        [ZYWHttpEngine AllGetURL:urlStr params:nil success:^(id responseObj) {
            
            [YJProgressHUD hide];
            if (responseObj) {
                
                ReturnInfoModel * infomodel=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                [YJProgressHUD showMessage:infomodel.info inView:weakSelf.view];
                if ([infomodel.success isEqual:@64]) {
                    
                  dispatch_time_t poptime=  dispatch_time(DISPATCH_TIME_NOW, (int64_t ) 1*NSEC_PER_SEC);
                    
                    dispatch_after(poptime, dispatch_get_main_queue(), ^{
                        [weakSelf pop];
                    });
 
                }
            }
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
            
        }];

    } else{
        //申请分机号
        __weak typeof(self)weakSelf=self;
        [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
        NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=api&a=add_vtel&tel=%@&userid=%@",URLSTR,_textField.text,_model.userid];
        [ZYWHttpEngine AllGetURL:urlStr params:nil success:^(id responseObj) {
            if (responseObj) {
                [YJProgressHUD hide];
                ReturnInfoModel * infomodel=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                [YJProgressHUD showMessage:infomodel.info inView:self.view];
                if ([infomodel.success isEqual:@57]) {
                   
                    dispatch_time_t poptime=  dispatch_time(DISPATCH_TIME_NOW, (int64_t ) 1*NSEC_PER_SEC);
                    
                    dispatch_after(poptime, dispatch_get_main_queue(), ^{
                        [weakSelf pop];
                    });
                    
                }
            }
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
        }];

    }

}



@end
