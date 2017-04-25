//
//  TSFRentFeatureVC.m
//  TaoShenFang
//
//  Created by YXM on 16/12/6.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFRentFeatureVC.h"
#import "OtherHeader.h"
#import "TSFRentFeatureCell.h"
#import "HouseModel.h"
@interface TSFRentFeatureVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * array;

@end

@implementation TSFRentFeatureVC

- (NSArray *)array{
    if (_array==nil) {
        _array=[NSArray arrayWithObjects:@"小区介绍",@"房屋配套",@"生活配套",@"装修描述",@"出租原因",@"业主说", nil];
    }
    return _array;
}
- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=50;
        _tableView.rowHeight=UITableViewAutomaticDimension;
        [_tableView registerNib:[UINib nibWithNibName:@"TSFRentFeatureCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (void)setModel:(HouseModel *)model{
    _model=model;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self initHeader];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSFRentFeatureCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.label1.text=self.array[indexPath.row];
    //@"小区介绍",@"房屋配套",@"生活配套",@"装修描述",@"出租原因",@"业主说"
    switch (indexPath.row) {
        case 0:
            cell.label2.text=_model.xiaoquintro.length==0 ? @"暂无数据":_model.xiaoquintro;
            break;
        case 1:
            cell.label2.text=_model.fangwupeitao.length==0 ? @"暂无数据":_model.fangwupeitao;
            break;
        case 2:
            cell.label2.text=_model.shenghuopeitao.length==0 ? @"暂无数据":_model.shenghuopeitao;
            break;
        case 3:
            cell.label2.text=_model.zxdesc.length==0 ? @"暂无数据":_model.zxdesc;
            break;
        case 4:
            cell.label2.text=_model.czreason.length==0 ? @"暂无数据":_model.czreason;
            break;
        case 5:
            cell.label2.text=_model.yezhushuo.length==0 ? @"暂无数据":_model.yezhushuo;
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)initHeader{
    UIView * header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 100)];
    UIButton * cancel=[[UIButton alloc]initWithFrame:CGRectMake(15, 30, 30, 30)];
    [cancel setImage:[UIImage imageNamed:@"cancel_02"] forState:UIControlStateNormal];
    [cancel setTitleColor:TITLECOL forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cancel];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(cancel.frame)+10, kMainScreenWidth-30, 21)];
    label.text=@"房源特色";
    label.font=[UIFont boldSystemFontOfSize:20];
    label.textColor=TITLECOL;
    [header addSubview:label];
    _tableView.tableHeaderView=header;
}

- (void)dismissAction:(UIButton *)cancelBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
