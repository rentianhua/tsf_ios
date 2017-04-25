//
//  TSFRecordVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/2.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFRecordVC.h"
#import "OtherHeader.h"
#import "ZYWHttpEngine.h"

#import "TSFRecordCell.h"
#import "TSFRecordModel.h"

#import <MJExtension.h>
#import "YJProgressHUD.h"

#import "TSFRecordHeadView.h"

#define NAVBTNW 20
@interface TSFRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * dataArray;

@end

@implementation TSFRecordVC
- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}
- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:@"TSFRecordCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        
    }
    return _tableView;
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.title=@"历史记录";

    [self.view addSubview:self.tableView];
    [self loadData];
    
}

- (void)loadData{
    __weak typeof(self)weakSelf=self;
    NSDictionary * param=@{
                           @"username":NSUSER_DEF(USERINFO)[@"username"]
                          };
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=history",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            weakSelf.dataArray=[TSFRecordModel mj_objectArrayWithKeyValuesArray:responseObj];
            
        }
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TSFRecordHeadView * head=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"head"];
    if (head==nil) {
        head=[[TSFRecordHeadView alloc]initWithReuseIdentifier:@"head"];
    }
    return head;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSFRecordCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    TSFRecordModel * model=self.dataArray[indexPath.row];
    cell.label1.text=model.type;
    cell.label2.text=model.action;
    cell.label3.text=model.inputtime;
    return cell;
}


@end
