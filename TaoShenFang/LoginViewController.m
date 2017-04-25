//
//  LoginViewController.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/25.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisteViewController.h"
#import "ForgetPswController.h"
#import "OtherHeader.h"
#import "UIView+SDAutoLayout.h"
#import "ZYWHttpEngine.h"
#import "MJExtension.h"
#import "YJProgressHUD.h"
#import "UserModel.h"
#import "MD5DataSigner.h"

#import <IQKeyboardManager.h>
#import <IQToolbar.h>

@interface LoginViewController ()
{
    NSInteger _lastButtonTag;
}
@property (nonatomic,strong)UIView * lineView;
@property (nonatomic,strong)UITextField * textField1;
@property (nonatomic,strong)UITextField * textField2;
@property (nonatomic,strong)UIView * codeView;
@property (nonatomic,strong)UIButton * codeBtn;

@property (nonatomic,strong)IQKeyboardManager * manager;

@end

@implementation LoginViewController

- (UIView *)codeView
{
    if (_codeView==nil) {
        _codeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 110, 50)];
        UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, 90, 30)];
        button.layer.borderColor=[UIColor grayColor].CGColor;
        button.layer.borderWidth=0.5;
        button.backgroundColor=SeparationLineColor;
        button.layer.cornerRadius=3;
        button.clipsToBounds=YES;
        [button setTitle:@"发送验证码" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_codeView addSubview:button];
        _codeBtn=button;
        [button addTarget:self action:@selector(codeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登录";
    _lastButtonTag=100;
    
    _manager = [IQKeyboardManager sharedManager];
    //控制整个功能是否启用。
    _manager.enable = YES;
    _manager.enableAutoToolbar = NO;
    
    [self.navigationController.navigationBar setBarTintColor:NavBarColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName ,nil]];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registeClick)];
    
    //1080:431
    
    CGFloat imgW=kMainScreenWidth;
    CGFloat imgH=imgW *431/1080;
    CGFloat imgY=kMainScreenHeight-imgH;
    UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, imgY, imgW, imgH)];
    imgView.image=[UIImage imageNamed:@"logo_login_bg"];
    [self.view addSubview:imgView];
    
    UIView * navBar=[UIView new];
    navBar.backgroundColor=NavBarColor;
    [self.view addSubview:navBar];
    navBar.sd_layout
    .leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(64);
    
    
    UILabel * navLabel=[UILabel new];
    navLabel.text=@"登录";
    navLabel.textColor=[UIColor whiteColor];
    navLabel.textAlignment=NSTextAlignmentCenter;
    [navBar addSubview:navLabel];
    navLabel.sd_layout
    .topSpaceToView(navBar,20)
    .leftSpaceToView(navBar,0)
    .rightSpaceToView(navBar,0)
    .heightIs(44);
    
    UIButton * cancelButton=[UIButton new];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navBar addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.sd_layout
    .leftSpaceToView(navBar,0)
    .topSpaceToView(navBar,20)
    .heightIs(44)
    .widthEqualToHeight();
    
    UIButton * registeButton=[UIButton new];
    [registeButton setTitle:@"注册" forState:UIControlStateNormal];
    [registeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navBar addSubview:registeButton];
    [cancelButton addTarget:self action:@selector(registeClick) forControlEvents:UIControlEventTouchUpInside];
    registeButton.sd_layout
    .rightSpaceToView(navBar,0)
    .topSpaceToView(navBar,20)
    .heightIs(44)
    .widthEqualToHeight();

    
    
    
    
    UIView * topView=[UIView new];
    topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topView];
    
    topView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,64)
    .heightIs(50);
    
    NSArray * buttonTitleArr=@[@"普通登录",@"验证码快捷登录"];
    for (int i=0; i<2; i++) {
        UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(0+kMainScreenWidth*0.5*i, 0, kMainScreenWidth*0.5, 50)];
        [button setTitle:buttonTitleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [topView addSubview:button];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        button.tag=i+100;
        [button addTarget:self action:@selector(topClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    UIView * lineView=[UIView new];
    lineView.backgroundColor=NavBarColor;
    [self.view addSubview:lineView];
    self.lineView=lineView;
    lineView.bounds=CGRectMake(0, 0, kMainScreenWidth*0.5, 2);
    lineView.center=CGPointMake(self.view.center.x*0.5, 64+50);
    
    UIView * textBgView=[UIView new];
    textBgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:textBgView];
    textBgView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(lineView,0)
    .heightIs(100);
    
    
    //输入手机号
    UITextField * textField1=[UITextField new];
    textField1.leftViewMode=UITextFieldViewModeAlways;
    UIView * leftView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView * leftImg1=[[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 18, 18)];
    [leftImg1 setImage:[UIImage imageNamed:@"phone"]];
    [leftView1 addSubview:leftImg1];
    
    textField1.leftView=leftView1;
    
    textField1.layer.borderColor=SeparationLineColor.CGColor;
    textField1.layer.borderWidth=0.5;
    textField1.placeholder=@"请输入手机号码";
    [textField1 setValue:[UIFont systemFontOfSize:15]forKeyPath:@"_placeholderLabel.font"];
    textField1.keyboardType=UIKeyboardTypePhonePad;
    [textBgView addSubview:textField1];
    self.textField1=textField1;
    
    textField1.sd_layout
    .leftSpaceToView(textBgView,0)
    .rightSpaceToView(textBgView,0)
    .topSpaceToView(textBgView,0)
    .heightIs(50);
    
    //输入密码
    UITextField * textField2=[UITextField new];
    textField2.leftViewMode=UITextFieldViewModeAlways;
    textField2.secureTextEntry=YES;
    UIView * leftView2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView * leftImg2=[[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 18, 18)];
    [leftImg2 setImage:[UIImage imageNamed:@"psw"]];
    [leftView2 addSubview:leftImg2];
    
    textField2.leftView=leftView2;

    
    textField2.layer.borderWidth=0.5;
    textField2.layer.borderColor=SeparationLineColor.CGColor;
    textField2.placeholder=@"请输入密码";
    [textField2 setValue:[UIFont systemFontOfSize:15]forKeyPath:@"_placeholderLabel.font"];
    textField2.keyboardType=UIKeyboardTypeASCIICapable;

    [textBgView addSubview:textField2];
    self.textField2=textField2;
    textField2.sd_layout
    .leftSpaceToView(textBgView,0)
    .rightSpaceToView(textBgView,0)
    .topSpaceToView(textField1,0)
    .heightIs(50);

    UIButton * loginButton=[UIButton new];
    loginButton.backgroundColor=NavBarColor;
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:loginButton];
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    
    loginButton.sd_layout
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .topSpaceToView(textBgView,20)
    .heightIs(40);
    
    UIButton * forgetButton=[UIButton new];
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetButton.contentMode=UIViewContentModeRight;
    [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [forgetButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:forgetButton];
    [forgetButton addTarget:self action:@selector(forgetPswClick) forControlEvents:UIControlEventTouchUpInside];
    forgetButton.sd_layout
    .rightEqualToView(loginButton)
    .topSpaceToView(loginButton,20)
    .heightIs(21)
    .widthIs(80);
    
    
    
    }


/**普通登录 验证码登录*/
- (void)topClick:(UIButton *)button
{
    
    
    if (button.tag==100) {
        [UIView animateWithDuration:0.5 animations:^{
            _lineView.center=CGPointMake(button.center.x, 64+50);
        }];
        _textField2.placeholder=@"请输入密码";
        _textField1.rightViewMode=UITextFieldViewModeNever;
        _textField2.secureTextEntry=YES;
        
    } else{
        [UIView animateWithDuration:0.5 animations:^{
            _lineView.center=CGPointMake(button.center.x, 64+50);
        }];
        _textField2.placeholder=@"请输入短信验证码";
        _textField1.rightView=self.codeView;
        _textField1.rightViewMode=UITextFieldViewModeAlways;
        _textField2.secureTextEntry=NO;
    }
  
    _lastButtonTag=button.tag;
}

/**忘记密码*/
- (void)forgetPswClick
{
    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]init];
    backBtn.title=@"";
    ForgetPswController * vc=[[ForgetPswController alloc]init];
    self.navigationItem.backBarButtonItem=backBtn;
    [self.navigationController pushViewController:vc animated:YES];
}

/**立即注册*/
- (void)registeClick
{
    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]init];
    backBtn.title=@"";
    self.navigationItem.backBarButtonItem=backBtn;
    RegisteViewController * vc=[[RegisteViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**获取手机验证码*/
- (void)codeClick
{
     [_textField1 resignFirstResponder];
     
     if (self.textField1.text.length==0) {
     [YJProgressHUD showMessage:@"手机号不能为空" inView:self.view];
     return;
     }
     if (self.textField1.text.length!=11) {
     [YJProgressHUD showMessage:@"手机号格式不正确" inView:self.view];
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
     [_codeBtn setTitle:@"重发" forState:UIControlStateNormal];
     [_codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     _codeBtn.userInteractionEnabled = YES;
     });
     
     }else{
     
     int seconds = time % 60;
     dispatch_async(dispatch_get_main_queue(), ^{
     
     //设置按钮显示读秒效果
     [_codeBtn setTitle:[NSString stringWithFormat:@"重发(%.2d)", seconds] forState:UIControlStateNormal];
     [_codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     _codeBtn.userInteractionEnabled = NO;
     });
     time--;
     }
     });
     dispatch_resume(_timer);
     
     NSDictionary * dict=@{@"mob":self.textField1.text};

     __weak typeof(self)weakSelf=self;
     [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=sms&a=getyzm",URLSTR] params:dict success:^(id responseObj) {
     if (responseObj) {
     
     [YJProgressHUD showMessage:responseObj[@"info"] inView:weakSelf.view];
     if (![responseObj[@"success"] isEqualToNumber:@11]) {
     dispatch_source_cancel(_timer);
     dispatch_async(dispatch_get_main_queue(), ^{
     
     //设置按钮的样式
     [_codeBtn setTitle:@"重发" forState:UIControlStateNormal];
     [_codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     _codeBtn.userInteractionEnabled = YES;
     });

     }
     
    }

     } failure:^(NSError *error) {
     [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
    }];
    
}


- (void)cancelClick
{
    __weak typeof(self)weakSelf=self;
    if ( _completeBlock) {
        weakSelf.completeBlock(CompleteCancel);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginClick
{
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
    
    
    __weak typeof(self)weakSelf=self;
    
    if (_textField1.text.length==0) {
        [YJProgressHUD showMessage:@"手机号不能为空" inView:self.view];
         return;
    } else if (_textField1.text.length>0 && _textField1.text.length<11){
        [YJProgressHUD showMessage:@"手机号格式不正确" inView:self.view];
        return;
        
    }
    
    if (_lastButtonTag==100) {//手机号 密码登录
        if (_textField2.text.length==0) {
            [YJProgressHUD showMessage:@"密码不能为空" inView:self.view];
            return;
        }
        if (_textField2.text.length>0 && _textField2.text.length<6){
            [YJProgressHUD showMessage:@"密码不能低于6位" inView:self.view];
            return;
        }

        
        NSDictionary * param=@{@"username":_textField1.text,@"password":_textField2.text};
        NSString * url=[NSString stringWithFormat:@"%@g=Member&m=Public&a=api_dologin",URLSTR];
        
        
        [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
        [ZYWHttpEngine AllPostURL:url params:param success:^(id responseObj) {

            [YJProgressHUD hide];
            [YJProgressHUD showMessage:responseObj[@"info"] inView:weakSelf.view];
            
            if ([responseObj[@"success"] isEqualToNumber:@37]) {
                
                
                NSDictionary * param1=@{@"userid":responseObj[@"userid"]};
                [YJProgressHUD showProgress:@"正在加载中" inView:weakSelf.view];
                [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=Member&m=Public&a=api_getuserinfo",URLSTR] params:param1 success:^(id responseObj) {
                    [YJProgressHUD hide];
                    if (![responseObj isEqual:[NSNull null]]) {
                        UserModel * model=[UserModel mj_objectWithKeyValues:responseObj];
                        NSDictionary * userDict=@{
                                                  @"userid":model.userid,
                                                  @"username":model.username,
                                                  @"modelid":model.modelid,
                                                  @"userpic":model.userpic,
                                                  @"password":model.password
                                                  };
                        NSUSER_DEF_NORSET(userDict, USERINFO);
                        
                        [YJProgressHUD showMessage:@"登录成功" inView:weakSelf.view];
                        dispatch_time_t t=dispatch_time(DISPATCH_TIME_NOW, (int64_t) 2.0*NSEC_PER_SEC );
                        dispatch_after(t, dispatch_get_main_queue(), ^{
                            
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"message" object:weakSelf userInfo:nil];
                             [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                        });

                    }
                    
                } failure:^(NSError *error) {
                    [YJProgressHUD hide];
                    [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
                }];

            } else{
                [YJProgressHUD showMessage:@"用户名或密码错误" inView:weakSelf.view];
            }
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
        }];
 
    }
    
    else{//手机号 验证码登录
        
        if (_textField2.text.length==0) {
            
            [YJProgressHUD showMessage:@"验证码不能为空" inView:self.view];
             return;
        }
        NSDictionary * param=@{@"mob":_textField1.text,@"yzm":_textField2.text};
        NSString * url=[NSString stringWithFormat:@"%@g=api&m=sms&a=mob_login_yzm",URLSTR];
        
        [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
        [ZYWHttpEngine AllPostURL:url params:param success:^(id responseObj) {
    
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:responseObj[@"info"] inView:weakSelf.view];
            if ([responseObj[@"success"] isEqualToNumber:@45]) {
                //登录成功

                
                NSDictionary * param1=@{@"userid":responseObj[@"userid"]};
                [YJProgressHUD showProgress:@"正在加载中" inView:weakSelf.view];
                [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=Member&m=Public&a=api_getuserinfo",URLSTR] params:param1 success:^(id responseObj) {
                    [YJProgressHUD hide];
                    if (![responseObj isEqual:[NSNull null]]) {
                        UserModel * model=[UserModel mj_objectWithKeyValues:responseObj];
                        NSDictionary * userDict=@{
                                                  @"userid":model.userid,
                                                  @"username":model.username,
                                                  @"modelid":model.modelid,
                                                  @"userpic":model.userpic,
                                                  @"password":model.password
                                                  };
                        NSUSER_DEF_NORSET(userDict, USERINFO);
                        
                        [YJProgressHUD showMessage:@"登录成功" inView:weakSelf.view];
                        
                        dispatch_time_t t=dispatch_time(DISPATCH_TIME_NOW, (int64_t) 2.0*NSEC_PER_SEC );
                        dispatch_after(t, dispatch_get_main_queue(), ^{
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"message" object:weakSelf userInfo:nil];
                            
                            
                            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                            
                            
                        });

                    }
                    
                } failure:^(NSError *error) {
                    [YJProgressHUD hide];
                    [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
                }];

            }else{
                [YJProgressHUD showMessage:@"用户名或验证码错误" inView:weakSelf.view];
            }
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
        }];

    }
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _manager.enableAutoToolbar=YES;
    [[NSNotificationCenter defaultCenter]removeObserver:@"message"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
