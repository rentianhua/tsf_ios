//
//  DescripVC.m
//  TaoShenFang
//
//  Created by YXM on 16/8/27.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "DescripVC.h"
#import "UserModel.h"
#import "ZYWHttpEngine.h"
#import "OtherHeader.h"
#import "YJProgressHUD.h"
#import <IQKeyboardManager.h>
#define BTNW 20
#define TEXTH kMainScreenHeight-40-64
@interface DescripVC ()<UITextViewDelegate>

@property (nonatomic,strong)UITextView * textView;

@property (nonatomic,strong)UIView * BGView;

@property (nonatomic,assign)NSInteger textLength;

@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UIButton * rightNavBtn;

@end

@implementation DescripVC

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
- (UIView *)BGView{
    if (_BGView==nil) {
        _BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, kMainScreenWidth, TEXTH)];
        _BGView.backgroundColor=[UIColor redColor];
    }
    return _BGView;
}

- (UITextView *)textView{
    if (_textView==nil) {
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 5, kMainScreenWidth, TEXTH)];
        _textView.backgroundColor=[UIColor whiteColor];
        _textView.delegate=self;
        _textView.font=[UIFont systemFontOfSize:14];
        [_textView becomeFirstResponder];
    }
    return _textView;
}

- (void)pop:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}


- (void)setModel:(UserModel *)model{
    _model=model;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.navigationController.navigationBar.barTintColor=[UIColor redColor];
    
    [self.view addSubview:self.textView];
    
    
    self.textView.text=_model.about;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    _textLength=range.location;
    
    if (range.location>100) {
        
        self.textView.returnKeyType=UIReturnKeyDone;
        
        
        if ([text isEqualToString:@"\n"]) {
            
            [textView resignFirstResponder];
            
            return NO;
        } else{
            
            return YES;
        }
    } else{
        if ([text isEqualToString:@"\n"]) {
            return YES;
        }
        return YES;
    }
    return YES;
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    CGRect txf=self.textView.frame;
    txf.size.height=kMainScreenHeight-64-20-height;
    self.textView.frame=txf;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    CGRect txf=self.textView.frame;
    txf.size.height=TEXTH;
    self.textView.frame=txf;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    
}

- (void)saveAction:(UIButton *)button{
    
    [_textView resignFirstResponder];
    if (_textView.text.length==0) {
        _textView.text=@"";
    } if (_textView.text.length>140) {
        [YJProgressHUD showMessage:@"不得超过140个字" inView:self.view];
        
        return;
    }
    NSDictionary * param=@{
                             @"userid":_model.userid,
                             @"about":_textView.text
                           };
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=api_doprofile",URLSTR] params:param success:^(id responseObj) {
        if (responseObj) {
         [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
