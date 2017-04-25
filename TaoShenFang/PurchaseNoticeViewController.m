//
//  PurchaseNoticeViewController.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/25.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "PurchaseNoticeViewController.h"
#import "OtherHeader.h"

#import "TSFNewInfoCell.h"

#import "ZYWHttpEngine.h"
#import "InformationModel.h"
#import "IDModel.h"
#import "HomeInformatiomController.h"

#import "YJProgressHUD.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>


#define NAVBTNW 20
@interface PurchaseNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)NSArray * dataArray;

@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)UIImageView * BGView;

@end

@implementation PurchaseNoticeViewController
- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

- (UIImageView *)BGView{
    if (_BGView==nil) {
        _BGView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _BGView.image=[UIImage imageNamed:@"offline_bg_01"];
        
        UITapGestureRecognizer * reconginzer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(offlineAction:)];
        reconginzer.numberOfTapsRequired=1;
        [_BGView addGestureRecognizer:reconginzer];
        
    }
    return _BGView;
}

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:@"TSFNewInfoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
  
}

- (void)pop:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"购房须知";
     self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
   
    [self.view addSubview:self.BGView];
    self.BGView.hidden=YES;
    
    [self.view addSubview:self.tableView];
    
//    self.tableView.estimatedRowHeight=50;
//    self.tableView.rowHeight=UITableViewAutomaticDimension;
    
    
    [self loadData];
    
}

- (void)loadData{
    
    __weak typeof(self)weakSelf=self;
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=house&a=house_xuzhi",URLSTR] params:nil success:^(id responseObj) {
        [YJProgressHUD hide];
        
        weakSelf.BGView.hidden=YES;
        weakSelf.tableView.hidden=NO;
        
        if (responseObj) {
            weakSelf.dataArray=[InformationModel mj_objectArrayWithKeyValuesArray:responseObj];
            
            [weakSelf.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
        weakSelf.BGView.hidden=NO;
        weakSelf.tableView.hidden=YES;

    }];
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count==0) {
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    } else{
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    }
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InformationModel * model=_dataArray[indexPath.row];
    TSFNewInfoCell * cell=[tableView  dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.label1.text=model.title;
    cell.label2.text=model.descrip;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
    cell.label3.text=@"购房须知";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeInformatiomController * vc=[[HomeInformatiomController alloc]init];
    InformationModel * model=_dataArray[indexPath.row];
    IDModel * idmodel=[[IDModel alloc]init];
    idmodel.catid=model.catid;
    idmodel.ID=model.ID;
    vc.idModel=idmodel;
    [self.navigationController pushViewController:vc animated:YES];
    
}



//重新加载数据
- (void)offlineAction:(UITapGestureRecognizer *)recognizer{
    
    [self loadData];
    
}




@end
