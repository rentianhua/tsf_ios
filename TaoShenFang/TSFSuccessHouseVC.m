//
//  TSFSuccessHouseVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/1.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFSuccessHouseVC.h"
#import "TSFSuccessCell.h"
#import "OtherHeader.h"
#import "HandRoomDetailVC.h"
#import "RentRoomDetailVC.h"
#import <MJExtension.h>
#import <UIImageView+Webcache.h>
#import "ZYWHttpEngine.h"
#import "HouseModel.h"
#import "YJProgressHUD.h"
#import "IDModel.h"
#define NAVBTNW 20
@interface TSFSuccessHouseVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)UIButton * leftNavBtn;

@property (nonatomic,strong)UISegmentedControl * segment;


@end

@implementation TSFSuccessHouseVC

- (NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
- (UISegmentedControl *)segment{
    if (_segment==nil) {
        _segment=[[UISegmentedControl alloc]initWithItems:@[@"二手房",@"租房"]];
        _segment.tintColor=[UIColor redColor];
        [_segment addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}
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
        [_tableView registerNib:[UINib nibWithNibName:@"TSFSuccessCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        UIView * view=[[UIView alloc]initWithFrame:CGRectZero];
        _tableView.tableFooterView=view;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.title=@"成交房源";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.titleView=self.segment;
    self.segment.selectedSegmentIndex=0;
    [self controlAction:self.segment];
    
}

- (void)controlAction:(UISegmentedControl *)control{
    
    NSInteger x=control.selectedSegmentIndex;
    
    if (x ==0) {
        
        [self loadData];
        _segment.selectedSegmentIndex=0;
    }
    
    if (x==1) {
        [self loadchuzuData];
        _segment.selectedSegmentIndex=1;
    }
    
    
}

- (void)loadData{

    [self.dataArray removeAllObjects];
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    NSString * username=NSUSER_DEF(USERINFO)[@"username"];
    NSDictionary * param=@{
                           @"username":username,
                           @"table":@"ershou",
                           @"userid":NSUSER_DEF(USERINFO)[@"userid"]
                           };
    
    __weak typeof(self)weakSelf=self;
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=chengjiao",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            weakSelf.dataArray=[HouseModel mj_objectArrayWithKeyValuesArray:responseObj];
            
        }else{
            [YJProgressHUD showMessage:@"暂无数据" inView:weakSelf.view];
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"请检查网络" inView:weakSelf.view];
    }];

}

- (void)loadchuzuData{
    [self.dataArray removeAllObjects];
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    NSString * username=NSUSER_DEF(USERINFO)[@"username"];
    NSDictionary * param=@{
                           @"username":username,
                           @"table":@"chuzu",
                           @"userid":NSUSER_DEF(USERINFO)[@"userid"]
                           };
    
    __weak typeof(self)weakSelf=self;
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=chengjiao",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            weakSelf.dataArray=[HouseModel mj_objectArrayWithKeyValuesArray:responseObj]; 
        } else{
            [YJProgressHUD showMessage:@"暂无数据" inView:weakSelf.view];
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"请检查网络" inView:weakSelf.view];
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataArray.count==0) {
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    } else{
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    }
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSFSuccessCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    HouseModel * model=self.dataArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
    cell.label1.text=model.title;
    
    if ([model.shi isEqualToString:@"6"]) {
         cell.label2.text=[NSString stringWithFormat:@"%@5室以上%@厅%@卫",model.xiaoquname,model.ting,model.wei];
    } else{
         cell.label2.text=[NSString stringWithFormat:@"%@%@室%@厅%@卫",model.xiaoquname,model.shi,model.ting,model.wei];
    }
   
    if (self.segment.selectedSegmentIndex==0) {
        if (model.zongjia.length==0) {
            cell.label3.text=@"价格待定";
        } else{
           cell.label3.text=[NSString stringWithFormat:@"%@万",model.zongjia];
        }
      
    } else{
        if (model.zujin.length==0) {
            cell.label3.text=@"价格待定";
        } else{
             cell.label3.text=[NSString stringWithFormat:@"%@元/月",model.zujin];
        }
    }
    
    cell.label4.text=[NSString stringWithFormat:@"%@共%@层",model.ceng,model.zongceng];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (model.mianji!=0 && model.mianji!=nil && model.zongjia!=nil && model.mianji.length!=0 && model.zongjia.length!=0) {
       float danjia=[model.zongjia floatValue]/[model.mianji floatValue];
        cell.label5.text=[NSString stringWithFormat:@"%f*10000元/㎡",danjia];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HouseModel * model=self.dataArray[indexPath.row];
    
    if (_segment.selectedSegmentIndex==0) {
        HandRoomDetailVC * VC=[[HandRoomDetailVC alloc]init];
        VC.model=model;
        [self.navigationController pushViewController:VC animated:YES];
    } else{
        RentRoomDetailVC * VC=[[RentRoomDetailVC alloc]init];
        IDModel * idmodel=[[IDModel alloc]init];
        idmodel.ID=model.ID;
        idmodel.catid=model.catid;
        VC.model=idmodel;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
