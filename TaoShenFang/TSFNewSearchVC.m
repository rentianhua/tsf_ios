//
//  TSFNewSearchVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/28.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFNewSearchVC.h"
#import "OtherHeader.h"
#import "NewHouseListController.h"

#define BTNWIDTH 50
#define TITLEVIEWW kMainScreenWidth-BTNWIDTH


@interface TSFNewSearchVC ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField * textField;
@property (nonatomic,strong)UIButton * button;


@end

@implementation TSFNewSearchVC

- (UIButton *)button{
    if (_button==nil) {
        _button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, BTNWIDTH, 30)];
        [_button setTitle:@"取消" forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
- (UITextField *)textField{
    if (_textField==nil) {
        _textField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, TITLEVIEWW, 30)];
        _textField.placeholder=@"请输入小区名";
        UILabel *placeholder = [_textField valueForKeyPath:@"_placeholderLabel"];
        placeholder.textColor=[UIColor whiteColor];
        placeholder.font=[UIFont systemFontOfSize:14];
        _textField.backgroundColor=[UIColor lightGrayColor];
        _textField.layer.cornerRadius=3;
        _textField.layer.masksToBounds=YES;
        _textField.font=[UIFont systemFontOfSize:14];
        [_textField becomeFirstResponder];
        _textField.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
        _textField.leftViewMode=UITextFieldViewModeAlways;
        _textField.delegate=self;
    }
    return _textField;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * leftView=[[UIView alloc]initWithFrame:CGRectZero];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.titleView=self.textField;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.button];
}

- (void)cancel:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark---------------UITextFieldDelegate--------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NewHouseListController * VC=[[NewHouseListController alloc]init];
    VC.kwds=textField.text;
    [self.navigationController pushViewController:VC animated:YES];
 
    return YES;
}

- (void)cancelAction:(UIButton *)cancelBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
