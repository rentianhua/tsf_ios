//
//  TSFOrderVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/2.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFOrderVC.h"
//=====================
#import "Order.h"
#import "GRpay.h"
//==========================
#import <MJExtension.h>

#import "OtherHeader.h"
#import "ZYWHttpEngine.h"
#import "YJProgressHUD.h"

#import "TSFPayModel.h"
#import "ReturnInfoModel.h"
#import "IDModel.h"


#import "TSFGouDiOrderCell.h"
#import "TSFGouDiNoPayCell.h"

#import "BlockTradesDetailController.h"

#import "KSAlertView.h"

#define NAVBTNW 20
@interface TSFOrderVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,strong)UITableView * tableView;


@end

@implementation TSFOrderVC

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        //TSFGouDiNoPayCell.h
        [_tableView registerNib:[UINib nibWithNibName:@"TSFGouDiOrderCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TSFGouDiNoPayCell" bundle:nil] forCellReuseIdentifier:@"nocell"];
        
        _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}
- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.title=@"勾地订单";
    [self.view addSubview:self.tableView];
}

- (void)loadData{
    //http://www.taoshenfang.com/index.php?g=api&m=house&a=goudi_orderlist&userid=83
    
    NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
    
   [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
   [ZYWHttpEngine AllGetURL:[NSString stringWithFormat:@"%@g=api&m=house&a=goudi_orderlist&userid=%@",URLSTR,userid] params:nil success:^(id responseObj) {
       if (responseObj) {
           [YJProgressHUD hide];
           
           _dataArray=[TSFPayModel mj_objectArrayWithKeyValuesArray:responseObj];
           [self.tableView reloadData];
       }
  
   } failure:^(NSError *error) {
       [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
   }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSFPayModel * model=_dataArray[indexPath.row];
    if ([model.pay_status isEqualToString:@"1"]) {
        return 220;
        
    } else{
        return 145;
    }
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
    
    TSFPayModel * model=_dataArray[indexPath.row];
    if ([model.pay_status isEqualToString:@"1"]) {
        TSFGouDiOrderCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.label1.text=[NSString stringWithFormat:@"订单号：%@",model.order_no];
        cell.label2.text=model.title;
        cell.label3.text=[NSString stringWithFormat:@"支付宝交易流水号：%@",model.trade_no];
        cell.label4.text=[NSString stringWithFormat:@"支付宝账号：%@",model.buyer_email];
        cell.label5.text=[NSString stringWithFormat:@"支付金额：%.2f元",model.jine];
        cell.label7.text=@"支付状态：已支付";
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.paytime integerValue]];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        cell.label6.text=[NSString stringWithFormat:@"支付时间：%@",confromTimespStr];
        
        return cell;
 
    } else{
        TSFGouDiNoPayCell * cell=[tableView dequeueReusableCellWithIdentifier:@"nocell" forIndexPath:indexPath];
        cell.label1.text=[NSString stringWithFormat:@"订单号：%@",model.order_no];
        cell.label2.text=model.title;
        cell.label3.text=@"未支付";
        [cell.payBnt setTitle:@"去支付" forState:UIControlStateNormal];
        cell.payBnt.tag=indexPath.row;
        [cell.payBnt addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.deleteBtn.tag=indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    
}

- (void)payAction:(UIButton *)payBtn{
    
     TSFPayModel * model=_dataArray[payBtn.tag];
    
    Product * p=[[Product alloc]init];
    p.subject=model.title;
    p.price=model.jine;
    p.orderId=model.order_no;
    
    
    
    NSNotificationCenter * center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(payResult:) name:@"order" object:nil];
    
    
    [GRpay payWithProduct:p resultBlock:^(NSString *rsultString) {
        [self loadData];
        
    }];
}

 - (void)payResult:(NSNotification *)noti{
    
    NSDictionary * userInfodict=noti.userInfo;
    
    NSString * resultStatus=userInfodict[@"resultStatus"];
    
    NSInteger status=[resultStatus integerValue];
    
    NSString * result=userInfodict[@"result"];
    
    if (status==9000) {//订单支付成功
        
        NSData  * strdata=[result dataUsingEncoding:kCFStringEncodingUTF8];
        NSDictionary * resultDict=[NSJSONSerialization JSONObjectWithData:strdata options:NSJSONReadingMutableContainers error:nil];

        NSDictionary * responseDict=resultDict[@"alipay_trade_app_pay_response"];
        
        NSString * out_trade_no=responseDict[@"out_trade_no"];
        NSString * total_amount=responseDict[@"total_amount"];
        NSString * trade_no=responseDict[@"trade_no"];
        
        
        NSDictionary * param=@{@"out_trade_no":out_trade_no,
                               @"total_amount":total_amount,
                               @"trade_no":trade_no,
                               @"resultStatus":resultStatus};
        
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=Api&m=Api&a=app_return_url",URLSTR] params:param success:^(id responseObj) {
            
            TSFOrderVC * VC=[[TSFOrderVC alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
            
            
        } failure:^(NSError *error) {
            
        }];
        
        
    } else if (status==8000){//订单正在处理中
        
    } else if (status==4000){//订单支付失败
        
    } else if (status==6001){//订单取消
        
    } else if (status==6002){//网络链接出错
        
    }
    
}



- (void)deleteAction:(UIButton * )deleteBtn{
    
        [KSAlertView showWithTitle:@"提示" message1:@"确认要删除吗？" cancelButton:@"取消" commitType:KSAlertViewButtonCommit commitAction:^(UIButton *button) {
        TSFPayModel * model=_dataArray[deleteBtn.tag];
        NSDictionary * param=@{
                               @"id":model.ID,
                               @"userid":model.userid
                               };
        __weak typeof(self)weakSelf=self;
        [YJProgressHUD showProgress:@"正在删除中" inView:self.view];
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=house&a=goudi_del",URLSTR] params:param success:^(id responseObj) {
            [YJProgressHUD hide];
            if (responseObj) {
                ReturnInfoModel * infoModel=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                
                [YJProgressHUD showMessage:infoModel.info inView:self.view];
                if ([infoModel.success isEqual:@86]) {
                    
                    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW,( int64_t ) 2.0* NSEC_PER_SEC);
                    dispatch_after(time, dispatch_get_main_queue(), ^{
                        [weakSelf loadData];
                    });

                }
            }
            
        } failure:^(NSError *error) {
            [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
        }];

    }];
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TSFPayModel * model=_dataArray[indexPath.row];
    IDModel * idmodel=[[IDModel alloc]init];
    idmodel.catid=@7;
    idmodel.ID=model.house_id;
    
    BlockTradesDetailController * VC=[[BlockTradesDetailController alloc]init];
    VC.IDmodel=idmodel;
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"order" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
