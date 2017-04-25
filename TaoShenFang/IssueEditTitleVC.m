//
//  IssueEditTitleVC.m
//  TaoShenFang
//
//  Created by YXM on 16/10/25.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "IssueEditTitleVC.h"
#import "OtherHeader.h"
#import "YJProgressHUD.h"
#import <IQKeyboardManager.h>
#define BTNW 20
#define TEXTH kMainScreenHeight-40-64

@interface IssueEditTitleVC ()<UITextViewDelegate>

@property (nonatomic,strong)UITextView * textView;

@property (nonatomic,strong)UIView * BGView;

@property (nonatomic,assign)NSInteger textLength;

@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UIButton * rightNavBtn;

@end

@implementation IssueEditTitleVC
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
        [_rightNavBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_rightNavBtn setTitleColor:ORGCOL forState:UIControlStateNormal];
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
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 20, kMainScreenWidth, TEXTH)];
        _textView.backgroundColor=[UIColor whiteColor];
        _textView.delegate=self;
        
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
    
    self.textView.text=_string;
    
    
}

- (void)saveAction:(UIButton *)button{
    
    if (_textLength>100) {
        [YJProgressHUD showMessage:[NSString stringWithFormat:@"不能超过%d个字",100] inView:self.view];
    } else{

        self.textblock(self.textView.text);
    
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
   }
- (void)textViewDidEndEditing:(UITextView *)textView{
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [IQKeyboardManager sharedManager].enable = YES;
    
}


@end
