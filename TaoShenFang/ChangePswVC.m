//
//  ChangePswVC.m
//  TaoShenFang
//
//  Created by YXM on 16/8/27.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "ChangePswVC.h"
#import "OtherHeader.h"
#import "ZYWHttpEngine.h"
#import "YJProgressHUD.h"
#import "ReturnInfoModel.h"
#import <MJExtension.h>
#import <Masonry.h>
#import "LoginViewController.h"
#define BTNW 20
@interface ChangePswVC ()

@property (nonatomic,strong)UIButton * leftNavBtn;

@end

@implementation ChangePswVC

- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, BTNW, BTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

- (void)pop:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"修改密码";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    
    _textField1=[[UITextField alloc]init];
    _textField1.backgroundColor=[UIColor whiteColor];
    _textField1.secureTextEntry=YES;
    _textField1.placeholder=@"请输入原密码";
    _textField1.layer.borderWidth=0.5;
    _textField1.layer.borderColor=SeparationLineColor.CGColor;
    _textField1.font=[UIFont systemFontOfSize:15];
    _textField1.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 40)];
    _textField1.leftViewMode=UITextFieldViewModeAlways;
    [self.view addSubview:_textField1];
    __weak typeof(self)weakSelf=self;
    [weakSelf.textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(44);
    }];
    

    
    
    _textField2=[[UITextField alloc]init];
    _textField2.backgroundColor=[UIColor whiteColor];
    _textField2.placeholder=@"请输入新密码（至少6位）";
    _textField2.layer.borderWidth=0.5;
    _textField2.secureTextEntry=YES;
    _textField2.layer.borderColor=SeparationLineColor.CGColor;
    _textField2.font=[UIFont systemFontOfSize:15];
    _textField2.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 40)];
    _textField2.leftViewMode=UITextFieldViewModeAlways;
    [self.view addSubview:_textField2];
    [weakSelf.textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.textField1.mas_bottom).offset(0);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];

   
  
    
    _textField3=[[UITextField alloc]init];
    _textField3.backgroundColor=[UIColor whiteColor];
    _textField3.placeholder=@"重复新密码";
    _textField3.layer.borderWidth=0.8;
    _textField3.secureTextEntry=YES;
    _textField3.layer.borderColor=SeparationLineColor.CGColor;
    _textField3.font=[UIFont systemFontOfSize:15];
    _textField3.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 40)];
    _textField3.leftViewMode=UITextFieldViewModeAlways;
    [self.view addSubview:_textField3];
    [weakSelf.textField3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.textField2.mas_bottom).offset(0);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    

   
    
    _button=[[UIButton alloc]init];
    [self.view addSubview:_button];
    [weakSelf.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.equalTo(weakSelf.textField3.mas_bottom).offset(30);
        make.height.mas_equalTo(40);
    }];
    
    _button.layer.masksToBounds=YES;
    _button.layer.cornerRadius=5;
    [_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_button addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitle:@"确认修改" forState:UIControlStateNormal];
    _button.backgroundColor=NavBarColor;
}
- (void)commit:(UIButton *)sender {
    
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
    [_textField3 resignFirstResponder];
    
    if (_textField1.text==nil || _textField1.text.length==0) {
        [YJProgressHUD showMessage:@"当前密码不能为空" inView:self.view];
        
        return;
    }
    
   else if (_textField2.text==nil || _textField2.text.length==0) {
       [YJProgressHUD showMessage:@"新密码不能为空" inView:self.view];
       
        return;
    }
    
   else if (_textField3.text==nil || _textField3.text.length==0) {
       [YJProgressHUD showMessage:@"确认密码不能为空" inView:self.view];
       
        return;
    }
   else if (![_textField2.text isEqualToString:_textField3.text]){
       [YJProgressHUD showMessage:@"新密码与确认密码不一致" inView:self.view];
       
       return;
   }
    
    
    
    __weak typeof(self)weakSelf=self;
    
    NSDictionary * param=@{
                               @"username":NSUSER_DEF(USERINFO)[@"username"],
                               @"userid":NSUSER_DEF(USERINFO)[@"userid"],
                               @"oldpwd":_textField1.text,
                               @"pwd1":_textField2.text,
                               @"pwd2":_textField3.text
                        };
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=member&m=public&a=mod_pwd2",URLSTR] params:param success:^(id responseObj) {
        
        if (responseObj) {
            ReturnInfoModel * model=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
            [YJProgressHUD showMessage:model.info inView:weakSelf.view];
            
            
            if ([model.success isEqual:@156]) {//修改成功
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERINFO];
                [NSUSER_DEF(USERINFO) synchronize];
                
                [YJProgressHUD showMessage:@"密码修改成功，请重新登录" inView:weakSelf.view];
                
                //重新登录
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    

                });
            }
        }
       
    } failure:^(NSError *error) {
        
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
        
    }];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
