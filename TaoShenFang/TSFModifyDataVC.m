//
//  TSFModifyDataVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/14.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFModifyDataVC.h"
#import "OtherHeader.h"
#import "UserModel.h"
#import "YJProgressHUD.h"
#import "ZYWHttpEngine.h"
#import "ReturnInfoModel.h"
#import <MJExtension.h>
#define BTNW 20
@interface TSFModifyDataVC ()

@property (nonatomic,strong)UITextField * textField;
@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UIButton * rightNavBtn;

@end

@implementation TSFModifyDataVC

- (UITextField *)textField{
    if (_textField==nil) {
        _textField=[[UITextField alloc]initWithFrame:CGRectMake(0, 40, kMainScreenWidth, 40)];
        _textField.layer.borderColor=SeparationLineColor.CGColor;
        _textField.layer.borderWidth=0.8;
        _textField.backgroundColor=[UIColor whiteColor];
        _textField.returnKeyType=UIReturnKeyDone;
    }
    return _textField;
}
- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, BTNW, BTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

- (UIButton *)rightNavBtn{
    if (_rightNavBtn==nil) {
        _rightNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, BTNW*2, BTNW)];
        [_rightNavBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_rightNavBtn setTitleColor:DESCCOL forState:UIControlStateNormal];
        [_rightNavBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNavBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn];
    
    [self.view addSubview:self.textField];
    
    if (self.modifyType==ModifyCYVCType) {
        self.textField.text=_model.info.coname;
    } else if (self.modifyType==ModifyIDVCType){
        self.textField.text=_model.info.cardnumber;
    } else if (self.modifyType==ModifyRealVCType){
       self.textField.text=_model.info.realname;
    }
    
}

- (void)pop:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction:(UIButton *)btn{
   
    NSDictionary * param=nil;
    NSString * url=@"g=api&m=user&a=api_doprofile";
    if (self.modifyType==ModifyRealVCType) {//真实姓名
       
        param=@{@"userid":_model.userid,
                @"realname":_textField.text,
                @"modelid":_model.modelid};
        
        if (_textField.text.length>10) {
            
            [YJProgressHUD showMessage:@"姓名格式有误" inView:self.view];
            return;
        } else if (_textField.text.length==0){
            [YJProgressHUD showMessage:@"请输入真实姓名" inView:self.view];
            
            return;
        }
        
    } else if (self.modifyType==ModifyIDVCType){//身份证号码18
        
        if (!(_textField.text.length==18)) {
            [YJProgressHUD showMessage:@"身份证格式有误" inView:self.view];
            
            return;
        }
        
        param=@{
                @"userid":_model.userid,
                @"cardnumber":_textField.text
                };

          } else if (self.modifyType==ModifyCYVCType){
             
              if (_textField.text.length==0){
                  [YJProgressHUD showMessage:@"请输入公司名称" inView:self.view];
                  
                  return;
              }

              
       param= @{
                @"userid":_model.userid,
                @"coname":_textField.text
                };
    }
    
    
    
    NSString * urlStr=[NSString stringWithFormat:@"%@%@",URLSTR,url];
  
    __weak typeof(self)weakSelf=self;
    [ZYWHttpEngine AllPostURL:urlStr params:param success:^(id responseObj) {
        if (responseObj) {
            ReturnInfoModel * info=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
            if ([info.success isEqual:@54]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];//请求成功了以后再跳转
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
