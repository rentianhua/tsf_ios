//
//  SearchVC.m
//  TaoShenFang
//
//  Created by YXM on 16/9/8.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "SearchVC.h"
#import "ZYWHttpEngine.h"
#import "OtherHeader.h"
#import "NewHouseListController.h"
#define BTNWIDTH 50
#define TITLEVIEWW kMainScreenWidth-BTNWIDTH

@interface SearchVC ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate,UITextFieldDelegate>

@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic,strong)UITextField * textField;
@property (nonatomic,strong)UIButton * button;

@end

@implementation SearchVC
- (UIButton *)button{
    if (_button==nil) {
        _button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, BTNWIDTH, 30)];
        [_button setTitle:@"取消" forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
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
        _textField.returnKeyType=UIReturnKeySearch;
    }
    return _textField;
}

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.titleView=self.textField;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.button];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}

- (void)cancel:(UIButton *)button{
    self.kwdsBlock(@"");
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
 //如果是新房搜索
        self.kwdsBlock(textField.text);
        [self.navigationController popViewControllerAnimated:YES];
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
