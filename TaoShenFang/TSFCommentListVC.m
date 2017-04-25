//
//  TSFCommentListVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/5.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFCommentListVC.h"
#import "OtherHeader.h"
#import "TSFAgentCommentCell.h"
#import "ZYWHttpEngine.h"
#import "TSFCommentModel.h"
#import <MJExtension.h>
#import "YJProgressHUD.h"
#import <UIImageView+WebCache.h>
#define BTNW 20
@interface TSFCommentListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,strong)UIButton * leftNavBtn;
@end

@implementation TSFCommentListVC
- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, BTNW, BTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}
- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:@"TSFAgentCommentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
        _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}
- (void)pop:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.title=@"评论";
    
    [self.view addSubview:self.tableView];
    [self loadData];
    
}

- (void)loadData{
    
    __weak typeof(self)weakSelf=self;
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    [ZYWHttpEngine AllGetURL:[NSString stringWithFormat:@"%@g=Api&m=user&a=jjr_comment&id=%@",URLSTR,_userid] params:nil success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            
            weakSelf.dataArray=[TSFCommentModel mj_objectArrayWithKeyValuesArray:responseObj];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"请检查网络设置" inView:weakSelf.view];
        
    }];
    
    
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
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSFAgentCommentCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    TSFCommentModel * model=_dataArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.userpic] placeholderImage:[UIImage imageNamed:@"card_default"]];
    
    NSString * username=[model.author stringByReplacingCharactersInRange:NSMakeRange(3, model.author.length-3) withString:@"***"];
    cell.label1.text=username;
    cell.label2.text=model.content;
    cell.label3.text=model.date;

    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
