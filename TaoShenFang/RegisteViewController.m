//
//  RegisteViewController.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/21.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "RegisteViewController.h"
#import "UIView+SDAutoLayout.h"
#import "OtherHeader.h"
#import "UserModel.h"
#import <MJExtension.h>
#import "ZYWHttpEngine.h"
#import "YJProgressHUD.h"
#import "UIButton+WebCache.h"
#import <IQKeyboardManager.h>
#import <IQToolbar.h>

@interface RegisteViewController ()

@property (nonatomic,strong)UIView * codeView;
@property (nonatomic,strong)UIView * imageCodeView;
@property (nonatomic,strong)UITextField * imageCodeTextField;
@property (nonatomic,strong)UITextField * phoneTextField;
@property (nonatomic,strong)UITextField * codeTextField;
@property (nonatomic,strong)UITextField * pswTextField;
@property (nonatomic,strong)UITextField * rePswTextField;

@property (nonatomic,strong)UIView * typeBgView;
@property (nonatomic,strong)UILabel * typeLabel;
@property (nonatomic,strong)UIButton * userButton;
@property (nonatomic,strong)UIButton * borkerButton;

@property (nonatomic,strong)UIButton * registeButton;

@property (nonatomic,assign)NSInteger lastSelectTag;

@property (nonatomic,strong)IQKeyboardManager * manager;

@end

@implementation RegisteViewController


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
        [button addTarget:self action:@selector(codeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeView;
}

- (UIView *)imageCodeView
{
    if (_imageCodeView==nil) {
        _imageCodeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 50)];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 5, 130, 40);
        button.layer.borderColor=[UIColor grayColor].CGColor;
        button.layer.borderWidth=0.5;
        button.backgroundColor=SeparationLineColor;
        //button.layer.cornerRadius=3;
        //button.clipsToBounds=YES;
        [button setTitle:@"点击刷新" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_imageCodeView addSubview:button];
        [button addTarget:self action:@selector(imageCodeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *codeUrl = [NSString stringWithFormat:@"http://www.taoshenfang.com/index.php?g=Api&m=Checkcode&code_len=4&font_size=20&width=130&height=40&refresh=1&time=%f", [[NSDate date] timeIntervalSince1970]];
        [button sd_setImageWithURL:[NSURL URLWithString:codeUrl] forState:UIControlStateNormal];
    }
    return _imageCodeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"注册";

    _lastSelectTag=100;
    
    _manager=[IQKeyboardManager sharedManager];
    _manager.enable=YES;
    _manager.enableAutoToolbar=NO;
    
    CGFloat imgW=kMainScreenWidth;
    CGFloat imgH=imgW *431/1080;
    CGFloat imgY=kMainScreenHeight-imgH;
    UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, imgY, imgW, imgH)];
    imgView.image=[UIImage imageNamed:@"logo_login_bg"];
    [self.view addSubview:imgView];

    //图片验证码
    UITextField * imageCodeTextField=[[UITextField alloc]init];
    imageCodeTextField.tag=100;
    imageCodeTextField.backgroundColor=[UIColor whiteColor];
    imageCodeTextField.rightView=self.imageCodeView;
    imageCodeTextField.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    imageCodeTextField.leftViewMode=UITextFieldViewModeAlways;
    imageCodeTextField.rightViewMode=UITextFieldViewModeAlways;
    imageCodeTextField.placeholder=@"请输入验证码";
    [imageCodeTextField setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
    imageCodeTextField.keyboardType=UIKeyboardTypeASCIICapable;
    
    [self.view addSubview:imageCodeTextField];
    self.imageCodeTextField=imageCodeTextField;
    imageCodeTextField.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,64+20)
    .heightIs(50);
    
    //手机号
    UITextField * phoneTextField=[[UITextField alloc]init];
    phoneTextField.tag=100;
    phoneTextField.backgroundColor=[UIColor whiteColor];
    phoneTextField.rightView=self.codeView;
    phoneTextField.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    phoneTextField.leftViewMode=UITextFieldViewModeAlways;
    phoneTextField.rightViewMode=UITextFieldViewModeAlways;
    phoneTextField.placeholder=@"请输入手机号码";
    [phoneTextField setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
    phoneTextField.keyboardType=UIKeyboardTypePhonePad;

    [self.view addSubview:phoneTextField];
    self.phoneTextField=phoneTextField;
    phoneTextField.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(imageCodeTextField,1)
    .heightIs(50);


    
    //验证码
    UITextField * codeTextField=[[UITextField alloc]init];
    codeTextField.backgroundColor=[UIColor whiteColor];
    codeTextField.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    codeTextField.leftViewMode=UITextFieldViewModeAlways;
    codeTextField.placeholder=@"请输入短信验证码";
    codeTextField.keyboardType=UIKeyboardTypeNumberPad;
    [codeTextField setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:codeTextField];
    self.codeTextField=codeTextField;
    codeTextField.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(phoneTextField,1)
    .heightIs(50);
    
    
    //密码
    UITextField * pswTextField=[[UITextField alloc]init];
    pswTextField.backgroundColor=[UIColor whiteColor];
    pswTextField.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    pswTextField.leftViewMode=UITextFieldViewModeAlways;
    pswTextField.placeholder=@"请输入新密码(至少6位)";
    pswTextField.secureTextEntry=YES;
    pswTextField.keyboardType=UIKeyboardTypeASCIICapable;
    [pswTextField setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:pswTextField];
    self.pswTextField=pswTextField;
    pswTextField.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(codeTextField,1)
    .heightIs(50);

    //再次输入密码
    UITextField * rePswTextField=[UITextField new];
    rePswTextField.backgroundColor=[UIColor whiteColor];
    rePswTextField.placeholder=@"请再次输入密码";
    rePswTextField.secureTextEntry=YES;
    rePswTextField.keyboardType=UIKeyboardTypeASCIICapable;
    [rePswTextField setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
    rePswTextField.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    rePswTextField.leftViewMode=UITextFieldViewModeAlways;
    [self.view addSubview:rePswTextField];
    self.rePswTextField=rePswTextField;
    rePswTextField.sd_layout
    .leftEqualToView(pswTextField)
    .rightEqualToView(pswTextField)
    .topSpaceToView(pswTextField,1)
    .heightIs(50);
    
    UIView * typeView=[UIView new];
    [self.view addSubview:typeView];
    self.typeBgView=typeView;
    typeView.backgroundColor=[UIColor whiteColor];
    typeView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightRatioToView(rePswTextField,1.0)
    .topSpaceToView(rePswTextField,1);
  
    UILabel * typeLabel=[UILabel new];
    [typeView addSubview:typeLabel];
    self.typeLabel=typeLabel;
    NSAttributedString * attrStr=[[NSAttributedString alloc]initWithString:@"注册类型：" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [typeLabel setAttributedText:attrStr];
    typeLabel.sd_layout
    .leftSpaceToView(typeView,10)
    .topSpaceToView(typeView,0)
    .heightRatioToView(typeView,1.0)
    .widthIs(attrStr.size.width);
    
    UIButton * userBtn=[UIButton new];
    [typeView addSubview:userBtn];
    userBtn.tag=100;
    self.userButton=userBtn;
    [userBtn setTitle:@" 普通用户" forState:UIControlStateNormal];
    [userBtn setTitleColor:TITLECOL forState:UIControlStateNormal];
    [userBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [userBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [userBtn addTarget:self action:@selector(userTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    [userBtn setImage:[UIImage imageNamed:@"calc_unchecked_btn"] forState:UIControlStateNormal];
    userBtn.sd_layout
    .leftSpaceToView(typeLabel,5)
    .topEqualToView(typeLabel)
    .heightRatioToView(typeLabel,1.0)
    .widthIs(100);
    
    UIButton * borkerBtn=[UIButton new];
    borkerBtn.tag=101;
    [typeView addSubview:borkerBtn];
    self.borkerButton=borkerBtn;
    [borkerBtn setTitle:@" 经纪人" forState:UIControlStateNormal];
    [borkerBtn setTitleColor:TITLECOL forState:UIControlStateNormal];
    [borkerBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [borkerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [borkerBtn addTarget:self action:@selector(userTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    [borkerBtn setImage:[UIImage imageNamed:@"calc_unchecked_btn"] forState:UIControlStateNormal];
    borkerBtn.sd_layout
    .leftSpaceToView(userBtn,5)
    .topEqualToView(typeLabel)
    .heightRatioToView(typeLabel,1.0)
    .widthIs(80);

    
    
    //立即注册
    UIButton * registeButton=[UIButton new];
    registeButton.backgroundColor=NavBarColor;
    [registeButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [registeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:registeButton];
    self.registeButton=registeButton;
    
    [registeButton addTarget:self action:@selector(registe) forControlEvents:UIControlEventTouchUpInside];
    CGFloat margin=10;
    registeButton.sd_layout
    .leftSpaceToView(self.view,margin)
    .rightSpaceToView(self.view,margin)
    .topSpaceToView(typeView,margin*2)
    .heightIs(40);
    
    
    NSNotificationCenter * center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(textCheage) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
    [center addObserver:self selector:@selector(textCheage) name:UITextFieldTextDidChangeNotification object:self.codeTextField];
    [center addObserver:self selector:@selector(textCheage) name:UITextFieldTextDidChangeNotification object:self.pswTextField];
    

    UIButton * lastButton=(UIButton *)[typeView viewWithTag:_lastSelectTag];
    [lastButton setImage:[UIImage imageNamed:@"calc_checked_btn"] forState:UIControlStateNormal];
    
}

- (void)userTypeClick:(UIButton *)button
{
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    [_pswTextField resignFirstResponder];
    [_rePswTextField resignFirstResponder];
    
    UIButton * lastSelectBtn=(UIButton *)[_typeBgView viewWithTag:_lastSelectTag];
    [lastSelectBtn setImage:[UIImage imageNamed:@"calc_unchecked_btn"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"calc_checked_btn"] forState:UIControlStateNormal];
    _lastSelectTag=button.tag;

}

- (void)textCheage
{

}

- (void)imageCodeClick:(UIButton *)codeBtn
{
    NSString *codeUrl = [NSString stringWithFormat:@"http://www.taoshenfang.com/index.php?g=Api&m=Checkcode&code_len=4&font_size=20&width=130&height=40&refresh=1&time=%f", [[NSDate date] timeIntervalSince1970]];
    [codeBtn sd_setImageWithURL:[NSURL URLWithString:codeUrl] forState:UIControlStateNormal];
}

/**点击获取验证码*/
- (void)codeClick:(UIButton *)codeBtn
{
    [_imageCodeTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    
    if (self.imageCodeTextField.text.length==0) {
        [YJProgressHUD showMessage:@"验证码不能为空" inView:self.view];
        return;
    }
    if (self.imageCodeTextField.text.length!=4) {
        [YJProgressHUD showMessage:@"验证码错误" inView:self.view];
        return;
    }
    
    if (self.phoneTextField.text.length==0) {
        [YJProgressHUD showMessage:@"手机号不能为空" inView:self.view];
        return;
    }
    if (self.phoneTextField.text.length!=11) {
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
    
        NSDictionary * dict=@{@"mob":self.phoneTextField.text,
                              @"verify":self.imageCodeTextField.text};

    __weak typeof(self)weakSelf=self;
    //index.php?g=api&m=sms&a=reg
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=sms&a=reg",URLSTR] params:dict success:^(id responseObj) {
            if (responseObj) {
                
                [YJProgressHUD showMessage:responseObj[@"info"] inView:weakSelf.view];
                if (![responseObj[@"success"] isEqualToNumber:@4]) {
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

- (void)registe
{
    
    
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    [_pswTextField resignFirstResponder];
    [_rePswTextField resignFirstResponder];
    if (self.phoneTextField.text.length==0) {
        [YJProgressHUD showMessage:@"手机号不能为空" inView:self.view];
         return;
    }  if (self.phoneTextField.text.length!=11) {
        [YJProgressHUD showMessage:@"手机号格式不正确" inView:self.view];
        return;
    }
    if (self.codeTextField.text.length==0) {
        [YJProgressHUD showMessage:@"验证码不能为空" inView:self.view];
        return;
    } if (self.pswTextField.text.length==0){
        [YJProgressHUD showMessage:@"密码不能为空" inView:self.view];
         return;
    } if (self.rePswTextField.text.length==0) {
        [YJProgressHUD showMessage:@"确认密码不能为空" inView:self.view];
        return;
    } if (![self.pswTextField.text isEqualToString:self.rePswTextField.text]) {
        [YJProgressHUD showMessage:@"密码和确认密码不一致" inView:self.view];
         return;
    }
    

    NSString * modelid;
    if (_lastSelectTag==100) {//普通用户 35
        modelid=@"35";
    } else{//经纪人 36
        modelid=@"36";
    }
            NSDictionary * param=@{@"username":self.phoneTextField.text,
                                   @"password":self.pswTextField.text,
                                   @"modelid":modelid,
                                   @"password2":self.rePswTextField.text,
                                   @"yzm":self.codeTextField.text
                                   };
    
    __weak typeof(self)weakSelf=self;
            [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=Member&m=Public&a=api_register",URLSTR] params:param success:^(id responseObj) {
                
                 [YJProgressHUD showMessage:responseObj[@"info"] inView:weakSelf.view];
                
                if ([responseObj[@"success"] isEqualToNumber:@20]) {//昵称验证通过
                    
                    
                    NSDictionary * param1=@{@"userid":responseObj[@"userid"]};
                    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=Member&m=Public&a=api_getuserinfo",URLSTR] params:param1 success:^(id responseObj) {
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
                            
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"message" object:weakSelf userInfo:nil];
                            
                            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                        }
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    

                    }
                
            } failure:^(NSError *error) {
                
            }];
 
    
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
