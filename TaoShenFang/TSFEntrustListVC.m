//
//  TSFEntrustListVC.m
//  TaoShenFang
//
//  Created by YXM on 17/1/5.
//  Copyright © 2017年 RA. All rights reserved.
//

#import "TSFEntrustListVC.h"
#import <UIImageView+WebCache.h>
#import "OtherHeader.h"
#import "ZYWHttpEngine.h"
#import "YJProgressHUD.h"
#import "HouseModel.h"
#import <MJExtension.h>
#import "TSFEntrustListCell.h"
#import "HandRoomDetailVC.h"
#import "RentRoomDetailVC.h"
#import "BrokerSaleHouseVC.h"
#import "BorkerRentSaleVC.h"
#import "IDModel.h"
#import "ReturnInfoModel.h"
#import "TSFUploadContractVC.h"
@interface TSFEntrustListVC ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL isUpLoadIDCard;
}

@property (nonatomic,strong)UIButton * leftNaVBtn;
@property (nonatomic,strong)UISegmentedControl * segment;
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,copy)NSString * table;
@property (nonatomic,strong)HouseModel * seleModel;

@end

@implementation TSFEntrustListVC
- (UIButton *)leftNaVBtn{
    if (_leftNaVBtn==nil) {
        _leftNaVBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_leftNaVBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNaVBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNaVBtn;
}
- (UISegmentedControl *)segment{
    if (_segment==nil) {
        _segment=[[UISegmentedControl alloc]initWithItems:@[@"二手房",@"租房"]];
        [_segment addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}
- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:@"TSFEntrustListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNaVBtn];
    self.navigationItem.titleView=self.segment;
    self.segment.selectedSegmentIndex=0;
    self.segment.tintColor=NavBarColor;
    
    [self.view addSubview:self.tableView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.segment.selectedSegmentIndex==0) {
        _table=@"ershou";
    } else{
        _table=@"chuzu";
    }
    [self loadData];
}
- (void)loadData{
    __weak typeof(self)weakSelf=self;
    NSDictionary * param=@{@"userid":NSUSER_DEF(USERINFO)[@"userid"],
                           @"table":_table};
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=weituo",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            weakSelf.dataArray=[HouseModel mj_objectArrayWithKeyValuesArray:responseObj];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
    }];
}

- (void)controlAction:(UISegmentedControl *)segment{
    if (self.segment.selectedSegmentIndex==0) {
        _table=@"ershou";
    } else{
        _table=@"chuzu";
    }

    [self loadData];
}
- (void)goback:(UIButton *)backBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark--UITableViewDelegate/UITableViewDatasource-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HouseModel * model=self.dataArray[indexPath.row];
    TSFEntrustListCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
    cell.label1.text=model.title;
    cell.label2.text=[NSString stringWithFormat:@"%@/%@/%@",model.cityname,model.areaname,model.xiaoquname];
    if (self.segment.selectedSegmentIndex==0) {
        if (model.zongjia.length!=0) {
            cell.label3.text=[NSString stringWithFormat:@"%@万",model.zongjia];
        } else{
            cell.label3.text=@"价格待定";
        }
    } else{
        if (model.zujin.length!=0) {
            cell.label3.text=[NSString stringWithFormat:@"%@元/月",model.zujin];
        } else{
            cell.label3.text=@"价格待定";
        }
    }
    
   
    cell.label4.text=[NSString stringWithFormat:@"%@共(%@)层",model.ceng,model.zongceng];
    NSString * leixing=nil;
    if ([model.pub_type isEqualToString:@"2"]) {
      leixing=@"委托给经纪人";
    }else if ([model.pub_type isEqualToString:@"3"]){
        leixing=@"委托给平台";
    }
    cell.label5.text=[NSString stringWithFormat:@"%@/%@/%@",model.chenghu,model.username,leixing];
    if (self.segment.selectedSegmentIndex==0) {
        cell.btn1.hidden=NO;
        cell.btn2.hidden=NO;
        [cell.btn4 setTitle:@"申请已售出" forState:UIControlStateNormal];
    } else{
        cell.btn1.hidden=YES;
        cell.btn2.hidden=YES;
        [cell.btn4 setTitle:@"申请已出租" forState:UIControlStateNormal];
    }
    cell.btn1.tag=indexPath.row;
    cell.btn2.tag=indexPath.row;
    cell.btn3.tag=indexPath.row;
    cell.btn4.tag=indexPath.row;
    if (self.segment.selectedSegmentIndex==0) {
        if ([model.idcard isEqualToString:@""] || [model.idcard isEqualToString:@"a:0:{}"] ) {//身份证未上传
            
            [cell.btn1 setTitle:@"上传身份证" forState:UIControlStateNormal];
            [cell.btn1 setTitleColor:TITLECOL forState:UIControlStateNormal];
            cell.btn1.layer.borderColor=TITLECOL.CGColor;
            cell.btn1.layer.borderWidth=1;
            cell.btn1.layer.masksToBounds=YES;
            cell.btn1.layer.cornerRadius=5;
            
        } else{
            
            [cell.btn1 setTitle:@"身份证已上传" forState:UIControlStateNormal];
            [cell.btn1 setTitleColor:ORGCOL forState:UIControlStateNormal];
            cell.btn1.layer.borderColor=ORGCOL.CGColor;
            cell.btn1.layer.borderWidth=1;
            cell.btn1.layer.masksToBounds=YES;
            cell.btn1.layer.cornerRadius=5;
            
        }
        if ([model.contract isEqualToString:@""]  || [model.contract isEqualToString:@"a:0:{}"] ) {
            [cell.btn2 setTitle:@"上传合同" forState:UIControlStateNormal];
            [cell.btn2 setTitleColor:TITLECOL forState:UIControlStateNormal];
            cell.btn2.layer.borderColor=TITLECOL.CGColor;
            cell.btn2.layer.borderWidth=1;
            cell.btn2.layer.masksToBounds=YES;
            cell.btn2.layer.cornerRadius=5;
            
        } else{
            [cell.btn2 setTitle:@"合同已上传" forState:UIControlStateNormal];
            [cell.btn2 setTitleColor:ORGCOL forState:UIControlStateNormal];
            cell.btn2.layer.borderColor=ORGCOL.CGColor;
            cell.btn2.layer.borderWidth=1;
            cell.btn2.layer.masksToBounds=YES;
            cell.btn2.layer.cornerRadius=5;
        }

        if ([model.zaishou isEqualToString:@"1"]) {
            if ([model.apply_state isEqualToString:@"1"]) {
                //1.已申请
                [cell.btn4 setTitle:@"已售出申请中" forState:UIControlStateNormal];
                [cell.btn4 setTitleColor:ORGCOL forState:UIControlStateNormal];
                cell.btn4.layer.borderColor=ORGCOL.CGColor;
                cell.btn4.layer.borderWidth=1;
                cell.btn4.layer.masksToBounds=YES;
                cell.btn4.layer.cornerRadius=5;
            } else {
                
                //未申请
                cell.btn4.tag=indexPath.row;
                [cell.btn4 setTitle:@"申请已售出" forState:UIControlStateNormal];
                [cell.btn4 setTitleColor:TITLECOL forState:UIControlStateNormal];
                cell.btn4.layer.borderColor=TITLECOL.CGColor;
                cell.btn4.layer.borderWidth=1;
                cell.btn4.layer.masksToBounds=YES;
                cell.btn4.layer.cornerRadius=5;
            }
        } else{
            [cell.btn4 setTitle:@"已售出" forState:UIControlStateNormal];
            [cell.btn4 setTitleColor:RGB(26, 171, 168, 1.0) forState:UIControlStateNormal];
            cell.btn4.layer.borderColor=RGB(26, 171, 168, 1.0).CGColor;
            cell.btn4.layer.borderWidth=1;
            cell.btn4.layer.masksToBounds=YES;
            cell.btn4.layer.cornerRadius=5;
        }
    } else{
        if ([model.zaizu isEqualToString:@"1"]) {
            
            if ([model.apply_state isEqualToString:@"1"]) {
                //1.已申请
                [cell.btn4 setTitle:@"已出租申请中" forState:UIControlStateNormal];
                [cell.btn4 setTitleColor:ORGCOL forState:UIControlStateNormal];
                cell.btn4.layer.borderColor=ORGCOL.CGColor;
                cell.btn4.layer.borderWidth=1;
                cell.btn4.layer.masksToBounds=YES;
                cell.btn4.layer.cornerRadius=3;
            } else{
                //未申请
                cell.btn4.tag=indexPath.row;
                [cell.btn4 setTitle:@"申请已出租" forState:UIControlStateNormal];
                [cell.btn4 setTitleColor:TITLECOL forState:UIControlStateNormal];
                cell.btn4.layer.borderColor=TITLECOL.CGColor;
                cell.btn4.layer.borderWidth=1;
                cell.btn4.layer.masksToBounds=YES;
                cell.btn4.layer.cornerRadius=5;
            }
            
        } else{
            [cell.btn4 setTitle:@"已出租" forState:UIControlStateNormal];
            [cell.btn4 setTitleColor:RGB(26, 171, 168, 1.0) forState:UIControlStateNormal];
            cell.btn4.layer.borderColor=RGB(26, 171, 168, 1.0).CGColor;
            cell.btn4.layer.borderWidth=1;
            cell.btn4.layer.masksToBounds=YES;
            cell.btn4.layer.cornerRadius=5;
            
        }
    }
    
    [cell.btn1 addTarget:self action:@selector(upLoadIDCard:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn2 addTarget:self action:@selector(upLoadContract:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn4 addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn3 addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HouseModel  * model=self.dataArray[indexPath.row];
    if ([model.status isEqual:@99]) {//审核完毕
        if (self.segment.selectedSegmentIndex==0) {
            //二手房
            HandRoomDetailVC * VC=[[HandRoomDetailVC alloc]init];
            VC.model=model;
            [self.navigationController pushViewController:VC animated:YES];
        } else{
            //出租房
            RentRoomDetailVC * VC=[[RentRoomDetailVC alloc]init];
            IDModel * idmodel=[[IDModel alloc]init];
            idmodel.ID=model.ID;
            idmodel.catid=model.catid;
            VC.model=idmodel;
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    }
}
- (void)editAction:(UIButton *)btn{
    HouseModel * model=self.dataArray[btn.tag];
    
        if (self.segment.selectedSegmentIndex==0) {
            BrokerSaleHouseVC * VC=[[BrokerSaleHouseVC alloc]init];
            VC.model=model;
            VC.type=BrokerIssueTypeEdit;
            [self.navigationController pushViewController:VC animated:YES];
        } else{
            BorkerRentSaleVC * VC=[[BorkerRentSaleVC alloc]init];
            VC.model=model;
            VC.type=BrokerIssueTypeEdit;
            [self.navigationController pushViewController:VC animated:YES];
        }
       
    
}
- (void)applyAction:(UIButton *)btn{
    HouseModel * model=self.dataArray[btn.tag];
    if (model.apply_state && model.apply_state.length>0 && ![model.apply_state isEqualToString:@"0"]) {
        return;
    }
    NSDictionary * param=@{@"id":model.ID,
                           @"table":self.table,
                           @"username":NSUSER_DEF(USERINFO)[@"username"]};
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=house&a=apply_shouchu",URLSTR] params:param success:^(id responseObj) {
        
        [YJProgressHUD hide];
        if (responseObj) {
            ReturnInfoModel * info=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
            [YJProgressHUD showMessage:info.info inView:self.view];
            
            if ([info.success isEqual:@182]) {
                [self loadData];
            }
        }
        
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
    }];
    
}
//上传身份证
- (void)upLoadIDCard:(UIButton *)btn1{
    
    _seleModel=_dataArray[btn1.tag];
    
    if (_seleModel.idcard.length!=0 && ![_seleModel.idcard isEqualToString:@"a:0:{}"] ) {
        
        [YJProgressHUD showMessage:@"身份证已上传" inView:self.view];
        return;
    }
    isUpLoadIDCard=YES;
    
    TSFUploadContractVC * VC=[[TSFUploadContractVC alloc]init];
    VC.navigationItem.title=@"上传身份证";
    VC.seleModel=_seleModel;
    VC.type=UPLoadTypeIDCard;
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (void)upLoadContract:(UIButton * )btn2{
    isUpLoadIDCard=NO;
    _seleModel=_dataArray[btn2.tag];
    if (_seleModel.contract.length!=0 && ![_seleModel.contract isEqualToString:@"a:0:{}"]) {
        [YJProgressHUD showMessage:@"合同已上传" inView:self.view];
        return;
    }
    TSFUploadContractVC * VC=[[TSFUploadContractVC alloc]init];
    VC.navigationItem.title=@"上传合同";
    VC.seleModel=_seleModel;
    VC.type=UPLoadTypeContract;
    [self.navigationController pushViewController:VC animated:YES];
   
}



@end
