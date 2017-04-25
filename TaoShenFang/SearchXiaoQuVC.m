//
//  SearchXiaoQuVC.m
//  TaoShenFang
//
//  Created by YXM on 16/10/25.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "SearchXiaoQuVC.h"
#import "OtherHeader.h"
#import "ZYWHttpEngine.h"
#import <MJExtension.h>
#import "AreaModel.h"
#import "ReturnInfoModel.h"
#import "YJProgressHUD.h"

@interface SearchXiaoQuVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)UITextField * textField;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * dataArray;


@end

@implementation SearchXiaoQuVC

- (UITextField *)textField{
    if (_textField==nil) {
        _textField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth-60, 30)];
        [_textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        _textField.placeholder=@"  请输入小区名";
        _textField.font=[UIFont systemFontOfSize:14];
        [_textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        [_textField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        _textField.layer.masksToBounds=YES;
        _textField.layer.cornerRadius=3;
        _textField.backgroundColor=[UIColor lightGrayColor];
        _textField.delegate=self;
        _textField.returnKeyType=UIReturnKeyDone;
    }
    return _textField;
}

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
        UIView * view=[[UIView alloc]initWithFrame:CGRectZero];
        _tableView.tableFooterView=view;
    }
    return _tableView;
}


- (void)textChange:(UITextField *)textField{
    __weak typeof(self)weakSelf=self;
    NSDictionary * param=@{
                           @"area":_area,
                           @"key":textField.text
                           };
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=xiaoqu_search",URLSTR] params:param success:^(id responseObj) {
        
        if (responseObj) {
            if ([responseObj containsObject:@"success"]) {//无数据 或数据不完整
                ReturnInfoModel * infomodel=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                [YJProgressHUD showMessage:infomodel.info inView:weakSelf.view];
                
                
            } else{
                _dataArray=[AreaModel mj_objectArrayWithKeyValuesArray:responseObj];
                [weakSelf.tableView reloadData];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.titleView=self.textField;
    [self.textField becomeFirstResponder];
    UIButton * cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:DESCCOL forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    [self.view addSubview:self.tableView];
   

    
}

- (void)cancelAction:(UIButton *)cancelBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count==0) {
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    } else{
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    }
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    AreaModel * model=_dataArray[indexPath.row];
    cell.textLabel.text=model.title;
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AreaModel * model=_dataArray[indexPath.row];
    
    self.xiaoquBlock(model.title);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//南山 珍珠花苑
#pragma mark----UITextFieldDelegate------


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    self.xiaoquBlock(textField.text);
    
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}


@end
