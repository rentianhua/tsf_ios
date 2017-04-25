//
//  ForgetPswController.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/23.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "ForgetPswController.h"
#import "UIView+SDAutoLayout.h"
#import "OtherHeader.h"
#import "ZYWHttpEngine.h"
#import "YJProgressHUD.h"

@interface ForgetPswController ()
@property (nonatomic,strong)UITextField * phoneTextField;
@property (nonatomic,strong)UITextField * codeTextField;
@property (nonatomic,strong)UITextField * pswTextField;
@property (nonatomic,strong)UITextField * rePswTextField;


@property (nonatomic,strong)UIButton * commitButton;

@end

@implementation ForgetPswController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"找回密码";
    CGFloat margin=20;
    //1080:431
    
    CGFloat imgW=kMainScreenWidth;
    CGFloat imgH=imgW *431/1080;
    CGFloat imgY=kMainScreenHeight-imgH;
    UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, imgY, imgW, imgH)];
    imgView.image=[UIImage imageNamed:@"logo_login_bg"];
    [self.view addSubview:imgView];

    //手机号码
    UITextField * phoneTextField=[[UITextField alloc]init];
    phoneTextField.backgroundColor=[UIColor whiteColor];
    phoneTextField.rightViewMode=UITextFieldViewModeAlways;
    phoneTextField.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    phoneTextField.leftViewMode=UITextFieldViewModeAlways;
    phoneTextField.placeholder=@"请输入手机号码";
    [phoneTextField setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:phoneTextField];
    self.phoneTextField=phoneTextField;
    phoneTextField.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,84)
    .heightIs(40);
    
    phoneTextField.keyboardType=UIKeyboardTypePhonePad;
    //获取验证码按钮
    UIView * codeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
    phoneTextField.rightView=codeView;
    NSString * codeStr=@"获取验证码";
    UIButton * button=[[UIButton alloc]init];
    [button setTitle:codeStr forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:DESCCOL forState:UIControlStateNormal];
    button.layer.borderColor=[UIColor lightGrayColor].CGColor;
    button.layer.borderWidth=1;
    button.layer.cornerRadius=3;
    button.clipsToBounds=YES;
    [codeView addSubview:button];
    [button addTarget:self action:@selector(codeClick:) forControlEvents:UIControlEventTouchUpInside];
    button.sd_layout
    .centerXEqualToView(codeView)
    .centerYEqualToView(codeView)
    .heightIs(30)
    .widthIs(100);
    
    //短信验证码
    UITextField * codeTextField=[[UITextField alloc]init];
    codeTextField.backgroundColor=[UIColor whiteColor];
    codeTextField.placeholder=@"请输入短信验证码";
    [codeTextField setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
    codeTextField.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    codeTextField.leftViewMode=UITextFieldViewModeAlways;
    [self.view addSubview:codeTextField];
    self.codeTextField=codeTextField;
    codeTextField.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(phoneTextField,1)
    .heightIs(40);
    codeTextField.keyboardType=UIKeyboardTypeNumberPad;
    
    //密码
    UITextField * pswTextField=[[UITextField alloc]init];
    pswTextField.backgroundColor=[UIColor whiteColor];
    pswTextField.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    pswTextField.leftViewMode=UITextFieldViewModeAlways;
    pswTextField.placeholder=@"请输入新密码(至少6位)";
    [pswTextField setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:pswTextField];
    pswTextField.secureTextEntry=YES;
    self.pswTextField=pswTextField;
    pswTextField.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(codeTextField,1)
    .heightIs(40);
    pswTextField.keyboardType=UIKeyboardTypeASCIICapable;
    //再次输入密码
    UITextField * rePswTextField=[UITextField new];
    rePswTextField.backgroundColor=[UIColor whiteColor];
    rePswTextField.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    rePswTextField.leftViewMode=UITextFieldViewModeAlways;
    rePswTextField.placeholder=@"请再次输入密码";
    [rePswTextField setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
    rePswTextField.secureTextEntry=YES;
    [self.view addSubview:rePswTextField];
    self.rePswTextField=rePswTextField;
    rePswTextField.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(pswTextField,1)
    .heightIs(40);
    rePswTextField.keyboardType=UIKeyboardTypeASCIICapable;
    
    UIButton * commitButton=[UIButton new];
    commitButton.layer.cornerRadius=5;
    commitButton.clipsToBounds=YES;
    commitButton.backgroundColor=NavBarColor;
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:commitButton];
    self.commitButton=commitButton;
    
    [commitButton addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    commitButton.sd_layout
    .leftSpaceToView(self.view,margin)
    .rightSpaceToView(self.view,margin)
    .topSpaceToView(rePswTextField,margin)
    .heightIs(40);
    
}

/**点击获取验证码*/
- (void)codeClick:(UIButton *)codeBtn
{
    [_phoneTextField resignFirstResponder];
    if (self.phoneTextField.text.length==0 ) {
        [YJProgressHUD showMessage:@"手机号不能为空" inView:self.view];
         return;
    } if (self.phoneTextField.text.length<11) {
        [YJProgressHUD showMessage:@"手机号格式错误" inView:self.view];
        return;
    }
    
    __block NSInteger time=59;
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [codeBtn setTitle:@"重发" forState:UIControlStateNormal];
                [codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                codeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [codeBtn setTitle:[NSString stringWithFormat:@"重发(%.2d)", seconds] forState:UIControlStateNormal];
                [codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                codeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
    
    NSDictionary * dict=@{@"mob":self.phoneTextField.text};
    
    __weak typeof(self)weakSelf=self;
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=sms&a=lost_getyzm",URLSTR] params:dict success:^(id responseObj) {
        if (responseObj) {
            
            [YJProgressHUD showMessage:responseObj[@"info"] inView:weakSelf.view];
            if (![responseObj[@"success"] isEqualToNumber:@11]) {
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //设置按钮的样式
                    [codeBtn setTitle:@"重发" forState:UIControlStateNormal];
                    [codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    codeBtn.userInteractionEnabled = YES;
                });
                
            }
            
        }
        
    } failure:^(NSError *error) {
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
    }];   
}

- (void)commitButtonClick
{
    
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    [_pswTextField resignFirstResponder];
    [_rePswTextField resignFirstResponder];
    
    if (self.phoneTextField.text.length==0 ) {
        [YJProgressHUD showMessage:@"手机号不能为空" inView:self.view];
         return;
    } if (self.phoneTextField.text.length!=11) {
        [YJProgressHUD showMessage:@"手机号格式错误" inView:self.view];
        return;
    }  if (self.codeTextField.text.length==0 ) {
        [YJProgressHUD showMessage:@"验证码不能为空" inView:self.view];
        return;
    } if (self.pswTextField.text.length==0) {
        [YJProgressHUD showMessage:@"密码不能为空" inView:self.view];
       return;
    }  if (self.pswTextField.text.length<6 ) {
        [YJProgressHUD showMessage:@"密码不能低于6位" inView:self.view];
       return;
    } if (self.rePswTextField.text.length==0 ) {
        [YJProgressHUD showMessage:@"新密码不能为空" inView:self.view];
        return;
    } if (self.rePswTextField.text.length<6 ) {
        [YJProgressHUD showMessage:@"密码不能低于6位" inView:self.view];
         return;
    }
    

    NSDictionary * param=@{
                           @"mob":_phoneTextField.text,
                           @"yzm":_codeTextField.text,
                           @"pwd1":_pswTextField.text,
                           @"pwd2":_rePswTextField.text
                           };
    __weak typeof(self)weakSelf=self;
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=member&m=public&a=mod_pwd",URLSTR] params:param success:^(id responseObj) {
        if (responseObj) {
            [YJProgressHUD showMessage:responseObj[@"info"] inView:weakSelf.view];
            if ([responseObj[@"success"] isEqual:@51]) {
                dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, (int64_t ) 1.0*NSEC_PER_SEC);
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }
 
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
