//
//  TSFCommentVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/4.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFCommentVC.h"
#import "OtherHeader.h"
//#import "MBProgressHUD+XM.h"
#import "YJProgressHUD.h"
#import "ZYWHttpEngine.h"
#import <MJExtension.h>
#import "ReturnInfoModel.h"
#import <IQKeyboardManager.h>

#define BTNW 20

@interface TSFCommentVC ()<UITextViewDelegate>

@property (nonatomic,strong)UITextView * textView;
@property (nonatomic,strong)UILabel * placeholderLabel;
@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UIButton * rightNavBtn;


@end

@implementation TSFCommentVC

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
        [_rightNavBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_rightNavBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_rightNavBtn setTitleColor:RGB(51, 51, 51, 1.0) forState:UIControlStateNormal];
        [_rightNavBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNavBtn;
}

- (UILabel *)placeholderLabel{
    if (_placeholderLabel==nil) {
        _placeholderLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 21)];
        _placeholderLabel.text=@"评论内容不得超过50个字";
        _placeholderLabel.textColor=DESCCOL;
        _placeholderLabel.font=[UIFont systemFontOfSize:12];
    }
    return _placeholderLabel;
}
- (UITextView *)textView{
    if (_textView==nil) {
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth*0.5)];
        _textView.delegate=self;
        [_textView addSubview:self.placeholderLabel];
    }
    return _textView;
}

- (void)pop:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sendAction:(UIButton *)button{
    
    if (self.textView.text.length>50) {
        [YJProgressHUD showMessage:@"评论不得多于50个字" inView:self.view];
        return;
    }
   
    NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
    NSString * username=NSUSER_DEF(USERINFO)[@"username"];
    
    NSDictionary * param=@{@"id":_ID,
                               @"user_id":userid,
                               @"author":username,
                               @"agent":@"ios",
                               @"content":self.textView.text};
    __weak typeof(self)weakSelf=self;
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=Api&m=user&a=jjr_comm_add",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            ReturnInfoModel * model=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
            if ([model.success isEqual:@172]) {
                [YJProgressHUD showMessage:model.info inView:weakSelf.view];
                dispatch_time_t popTime=dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2.0* NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }
            if ([model.success isEqual:@173]) {
                [YJProgressHUD showMessage:model.info inView:weakSelf.view];
                dispatch_time_t popTime=dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2.0* NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }
        }
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
    }];
    
    
    
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn];
    
    self.navigationItem.title=@"评论";
    
    [self.view addSubview:self.textView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self.textView];
    
    
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (textView.text.length>0) {
        self.placeholderLabel.hidden=YES;
    } else{
        self.placeholderLabel.hidden=NO;
    }
    
    return YES;
}


- (void)textViewEditChanged:(NSNotification *)obj{
    UITextView * textView=(UITextView *)obj.object;
    NSString * toBeString=textView.text;
    
    NSString * lang=[[UIApplication sharedApplication]textInputMode].primaryLanguage;//键盘输入样式
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange * selectRange=[textView markedTextRange];
        UITextPosition * position=[textView positionFromPosition:selectRange.start offset:0];
        //
        if (!position) {
            if (toBeString) {
                if (!position) {
                    if (toBeString.length>50) {
                        [YJProgressHUD showMessage:@"评论内容不得超过50个字" inView:self.view];
                        textView.text=[toBeString substringToIndex:50];
                    }
                }
            }
        }
        
    } else{
        if (toBeString.length>50) {
            [YJProgressHUD showMessage:@"评论内容不得超过50个字" inView:self.view];
            
            textView.text=[toBeString substringToIndex:50];
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable=YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
