//
//  MyHandVC.m
//  TaoShenFang
//
//  Created by YXM on 16/8/28.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "MyHandVC.h"
#import "OtherHeader.h"
#import "SaleHouseVC.h"
#import "UserModel.h"
#import "BrokerSaleHouseVC.h"
#import "TSFSaleHandCell.h"
#import "ZYWHttpEngine.h"
#import "HouseModel.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "BrokerSaleHouseVC.h"
#import "KSAlertView.h"
#import "HandRoomDetailVC.h"
#import "IDModel.h"
#import "ReturnInfoModel.h"
#import "YJProgressHUD.h"
#import "TSFUploadContractVC.h"//上传合同

#define NAVBTNW 20
#define ImgViewW kMainScreenWidth *0.28
#define ImgViewH 112

@interface MyHandVC ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    BOOL isUpLoadIDCard;
}

@property (nonatomic,strong)NSArray *dataArray;

@property (nonatomic,strong)UITableView * tableView;
//导航条上的按钮
@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UIButton * rightNavBtn;

@property (nonatomic,strong)HouseModel * seleModel;

@end

@implementation MyHandVC
- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

- (UIButton *)rightNavBtn{
    if (_rightNavBtn==nil) {
        _rightNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW*2, NAVBTNW)];
        [_rightNavBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_rightNavBtn setTitleColor:ORGCOL forState:UIControlStateNormal];
        [_rightNavBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_rightNavBtn addTarget:self action:@selector(toRental) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNavBtn;
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self loadData];

}
- (void)loadView{
    [super loadView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"我要卖房";
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn];
    
    [self initWithHandListTableView];
}

- (void)loadData{
 
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];

    NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
    NSString * username=NSUSER_DEF(USERINFO)[@"username"];
    NSDictionary * param=@{
                           @"username":username,
                           @"userid":userid,
                           @"table":@"ershou"
                           };
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=house_list",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            _dataArray=[HouseModel mj_objectArrayWithKeyValuesArray:responseObj];
            [self.tableView reloadData];
        }

    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
        
    }];
}

//跳转到发布房源界面
- (void)toRental{
    if ([NSUSER_DEF(USERINFO)[@"modelid"] isEqualToString:@"35"]/*[_model.modelid isEqualToString:@"35"]*/) {//跳转到普通用户发布房源界面
        SaleHouseVC * vc=[[SaleHouseVC alloc]init];
        vc.type=IssueTypeGeneral;
        [self.navigationController pushViewController:vc animated:YES];
 
    } else{//跳转到经纪人发布房源界面
        
        BrokerSaleHouseVC * vc=[[BrokerSaleHouseVC alloc]init];
        vc.type=BrokerIssueTypeGeneral;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//有数据  显示列表页
- (void)initWithHandListTableView{

    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView=tableView;
    tableView.delegate=self;
    tableView.dataSource=self;
    
    UIView * view=[[UIView alloc]initWithFrame:CGRectZero];
    [tableView setTableFooterView:view];
    
    [tableView registerNib:[UINib nibWithNibName:@"TSFSaleHandCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark----UITableViewDelegate/UITableViewDataSource--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    return _dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HouseModel * model=_dataArray[indexPath.row];
    
    TSFSaleHandCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
    cell.label1.text=model.title;
    cell.label2.text=[NSString stringWithFormat:@"%@/%@/%@",model.cityname,model.areaname,model.xiaoquname];
    cell.label3.text=[NSString stringWithFormat:@"%@(共%@层)",model.ceng,model.zongceng];
   
    
    cell.label5.text=[NSString stringWithFormat:@"%@万",model.zongjia];
    cell.editBtn.tag=indexPath.row;
    [cell.editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn1.tag=indexPath.row;
    [cell.btn1 addTarget:self action:@selector(upLoadIDCard:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn2 addTarget:self action:@selector(upLoadContract:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn2.tag=indexPath.row;
    
    if ([model.pub_type isEqualToString:@"1"]) {
        cell.label4.text=[NSString stringWithFormat:@"%@/%@/自售",model.chenghu,model.username];
    } else if ([model.pub_type isEqualToString:@"2"]){
        cell.label4.text=[NSString stringWithFormat:@"%@/%@/委托给经纪人",model.chenghu,model.username];
    } else if ([model.pub_type isEqualToString:@"3"]){
        cell.label4.text=[NSString stringWithFormat:@"%@/%@/委托给平台",model.chenghu,model.username];
    } else{
        cell.label4.text=[NSString stringWithFormat:@"%@/%@/",model.chenghu,model.username];
    }
    
    if ([NSUSER_DEF(USERINFO)[@"modelid"] isEqualToString:@"35"]) {
        if ([model.lock isEqual:@1]) {
            cell.editBtn.hidden=YES;
            cell.deleteBtn.hidden=YES;
        } else{
            cell.editBtn.hidden=NO;
            cell.deleteBtn.hidden=NO;
        }
    } else{
        cell.editBtn.hidden=NO;
        cell.deleteBtn.hidden=NO;
    }
    if ([model.idcard isEqualToString:@""] || [model.idcard isEqualToString:@"a:0:{}"]) {//身份证未上传
        
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
    if ([model.contract isEqualToString:@""] || [model.contract isEqualToString:@"a:0:{}"] ) {
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
    cell.deleteBtn.tag=indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([model.status isEqual:@1]) {
        cell.btn3.hidden=YES;
    } else{
        cell.btn3.hidden=NO;
        if ([model.zaishou isEqualToString:@"1"]) {
            
            
            if ([model.apply_state isEqualToString:@"1"]) {
                //1.已申请
                [cell.btn3 setTitle:@"已售出申请中" forState:UIControlStateNormal];
                [cell.btn3 setTitleColor:ORGCOL forState:UIControlStateNormal];
                cell.btn3.layer.borderColor=ORGCOL.CGColor;
                cell.btn3.layer.borderWidth=1;
                cell.btn3.layer.masksToBounds=YES;
                cell.btn3.layer.cornerRadius=5;
                
            } else {
                
                //未申请
                cell.btn3.tag=indexPath.row;
                [cell.btn3 setTitle:@"申请已售出" forState:UIControlStateNormal];
                [cell.btn3 addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btn3 setTitleColor:TITLECOL forState:UIControlStateNormal];
                cell.btn3.layer.borderColor=TITLECOL.CGColor;
                cell.btn3.layer.borderWidth=1;
                cell.btn3.layer.masksToBounds=YES;
                cell.btn3.layer.cornerRadius=5;
            }
        } else{
            [cell.btn3 setTitle:@"已售出" forState:UIControlStateNormal];
            [cell.btn3 setTitleColor:RGB(26, 171, 168, 1.0) forState:UIControlStateNormal];
            cell.btn3.layer.borderColor=RGB(26, 171, 168, 1.0).CGColor;
            cell.btn3.layer.borderWidth=1;
            cell.btn3.layer.masksToBounds=YES;
            cell.btn3.layer.cornerRadius=5;
        }
    }

    return cell;
}
//申请已售出

- (void)applyAction:(UIButton *)applyBtn{
    
    
    HouseModel * model=_dataArray[applyBtn.tag];

    
    NSDictionary * param=@{@"id":model.ID,
                           @"table":@"ershou",
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
    if (_seleModel.contract.length!=0 && ![_seleModel.contract isEqualToString:@"a:0:{}"] ) {
        [YJProgressHUD showMessage:@"合同已上传" inView:self.view];
        return;
    }
    TSFUploadContractVC * VC=[[TSFUploadContractVC alloc]init];
    VC.navigationItem.title=@"上传合同";
    VC.seleModel=_seleModel;
    VC.type=UPLoadTypeContract;
    [self.navigationController pushViewController:VC animated:YES];

}

- (void)editAction:(UIButton *)button{
   
    HouseModel * model=self.dataArray[button.tag];
    if ([NSUSER_DEF(USERINFO)[@"modelid"] isEqualToString:@"35"]/*[_model.modelid isEqualToString:@"35"]*/){
        SaleHouseVC * VC=[[SaleHouseVC alloc]init];
        VC.type=IssueTypeEdit;
        VC.model=model;
        [self.navigationController pushViewController:VC animated:YES];
    } else{
    BrokerSaleHouseVC * vc=[[BrokerSaleHouseVC alloc]init];
    vc.model=model;
    vc.type=BrokerIssueTypeEdit;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    HouseModel * model=self.dataArray[indexPath.row];
    
    if ([model.status isEqual:@1]) {//待审核
        [YJProgressHUD showMessage:@"房源待审核" inView:self.view];
        return;
    }

    HandRoomDetailVC * VC=[[HandRoomDetailVC alloc]init];
    VC.model=model;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)deleteAction:(UIButton *)deleteBtn{
    
    
    __weak typeof(self)weakSelf=self;
    [KSAlertView showWithTitle:@"提示" message1:@"是否删除" cancelButton:@"取消" commitType:KSAlertViewButtonCommit commitAction:^(UIButton *button) {
        HouseModel * model=weakSelf.dataArray[deleteBtn.tag];
        if ([NSUSER_DEF(USERINFO)[@"modelid"] isEqualToString:@"35"] && [model.lock isEqual:@1]) {
            [YJProgressHUD showMessage:@"已锁定，不能删除" inView:self.view];
            return;
        }
        
        NSString * username=NSUSER_DEF(USERINFO)[@"username"];
        NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
        
        NSDictionary * param=@{@"username":username,
                               @"userid":userid,
                               @"table":@"ershou",
                               @"id":model.ID
                               };
        
        [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
        
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=house_del",URLSTR] params:param success:^(id responseObj) {
            [YJProgressHUD hide];
            if (responseObj) {
                ReturnInfoModel * infomodel=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                
                [YJProgressHUD showMessage:infomodel.info inView:self.view];
                
                if ([infomodel.success isEqual:@167]) {
                    [weakSelf loadData];
                }
                
            }
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
        }];
    }];
   }

@end
