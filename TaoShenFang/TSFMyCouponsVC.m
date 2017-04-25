//
//  TSFMyCouponsVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/2.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFMyCouponsVC.h"
#import "OtherHeader.h"
#import "ZYWHttpEngine.h"
#import "TSFPayModel.h"
#import <MJExtension.h>
#import "YJProgressHUD.h"
#import "ReturnInfoModel.h"
//=====================
#import "Order.h"
#import "GRpay.h"
//==========================

#import "TSFCouponView.h"

#import "NewRoomDetailViewController.h"

#import "TSFPayModel.h"
#import "IDModel.h"

#import "TSFCouponCell.h"
#import "TSFCouponNoPayCell.h"

#define NAVBTNW 20
@interface TSFMyCouponsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIButton * leftNavBtn;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * dataArray;

@property (nonatomic,strong)TSFCouponView * altView;

@property (nonatomic,strong)UIImageView * BGimgView;

@end

@implementation TSFMyCouponsVC

- (UIImageView *)BGimgView{
    if (_BGimgView==nil) {
        _BGimgView=[[UIImageView alloc]initWithFrame:self.view.frame];
        _BGimgView.image=[UIImage imageNamed:@"message_no_01"];
        _BGimgView.userInteractionEnabled=YES;
    }
    return _BGimgView;
}
- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:@"TSFCouponCell" bundle:nil] forCellReuseIdentifier:@"cell"];
         [_tableView registerNib:[UINib nibWithNibName:@"TSFCouponNoPayCell" bundle:nil] forCellReuseIdentifier:@"nocell"];
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
    self.navigationItem.title=@"我的优惠券";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.BGimgView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (void)loadData{
    
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
    __weak typeof(self)weakSelf=self;
   [ZYWHttpEngine AllGetURL:[NSString stringWithFormat:@"%@g=api&m=house&a=coupon_orderlist&userid=%@",URLSTR,userid] params:nil success:^(id responseObj) {
       if (responseObj) {
           [YJProgressHUD hide];
           weakSelf.dataArray=[TSFPayModel mj_objectArrayWithKeyValuesArray:responseObj];
           
           [weakSelf.tableView reloadData];
       } else{
           [YJProgressHUD showMessage:@"无优惠券" inView:weakSelf.view];
       }
       
   } failure:^(NSError *error) {
       [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
   }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count==0) {
        tableView.hidden=YES;
        self.BGimgView.hidden=NO;
    } else{
        tableView.hidden=NO;
        self.BGimgView.hidden=YES;
    }
    tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSFPayModel * model=_dataArray[indexPath.row];
    
    if ([model.pay_status isEqualToString:@"1"]) {
        return 270;
    } else{
        return 200;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSFPayModel * model=_dataArray[indexPath.row];
    
    if ([model.pay_status isEqualToString:@"1"]) {
        TSFCouponCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.label1.text=[NSString stringWithFormat:@"订单号：%@",model.order_no];
        cell.label2.text=model.house_title;
        cell.label3.text=@"已支付";
        if([model.isused intValue] == 1)
        {
            cell.labelUseState.text = @"已使用";
            cell.labelUseState.textColor = [UIColor redColor];
        }
        else
        {
            cell.labelUseState.text = @"未使用";
            cell.labelUseState.textColor = cell.label4.textColor;
        }
        cell.label4.text=[NSString stringWithFormat:@"购房人：%@",model.buyname];
        cell.label5.text=[NSString stringWithFormat:@"购房人手机号：%@",model.buytel];
        cell.label6.text=[NSString stringWithFormat:@"使用说明：%@",model.des];
        cell.label7.text=[NSString stringWithFormat:@"支付宝交易流水号：%@",model.trade_no];
        cell.label8.text=[NSString stringWithFormat:@"支付宝账号：%@",model.buyer_email];
        cell.label9.text=[NSString stringWithFormat:@"支付金额：%.2f元",model.shifu];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.paytime integerValue]];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        cell.label10.text=[NSString stringWithFormat:@"支付时间：%@",confromTimespStr];
        
        
        return cell;
    } else{
        TSFCouponNoPayCell * cell=[tableView dequeueReusableCellWithIdentifier:@"nocell" forIndexPath:indexPath];
        cell.label1.text=[NSString stringWithFormat:@"订单号：%@",model.order_no];
        cell.label2.text=model.house_title;
        cell.label3.text=model.buyname;
        cell.label4.text=[NSString stringWithFormat:@"购房人手机号：%@",model.buytel];
        cell.label5.text=[NSString stringWithFormat:@"使用说明：%@",model.des];
        
        cell.payBtn.tag=indexPath.row;
        cell.deleteBtn.tag=indexPath.row;
        [cell.payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    
    
}
- (void)payAction:(UIButton *)payBtn{
    TSFPayModel * model=_dataArray[payBtn.tag];
    
    Product * p=[[Product alloc]init];
    p.subject=model.coupon_name;
    p.price=model.shifu;
    p.orderId=model.order_no;
    
    
    NSNotificationCenter * center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(yhqAction:) name:@"yhq" object:nil];
    
    
    [GRpay payWithProduct:p resultBlock:^(NSString *rsultString) {
        
    
        
    }];

}


- (void)yhqAction:(NSNotification *)noti{
    
 
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
        
        
        
        //#define kNotifyURL @"http://www.taoshenfang.com/index.php?g=Api&m=Api&a=app_return_url"
        
        NSDictionary * param=@{@"out_trade_no":out_trade_no,
                               @"total_amount":total_amount,
                               @"trade_no":trade_no,
                               @"resultStatus":resultStatus};
        
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=Api&m=Api&a=app_return_url",URLSTR] params:param success:^(id responseObj) {
        
        
        } failure:^(NSError *error) {
            
        }];
        
        
    } else if (status==8000){//订单正在处理中
        
    } else if (status==4000){//订单支付失败
        
    } else if (status==6001){//订单取消
        
    } else if (status==6002){//网络链接出错
        
    }
    
}



- (void)deleteAction:(UIButton *)deleteBtn{
    
    TSFPayModel * model=_dataArray[deleteBtn.tag];
    
    _altView=[[TSFCouponView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_altView];
    
    __weak typeof(self)weakSelf=self;
    
    __block TSFCouponView * blockView=_altView;
    
    _altView.sendBlock=^{

        __block NSInteger time=59;
        
        
        NSDictionary * param=@{@"mob":model.buytel};
        
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=sms&a=getyzm",URLSTR] params:param success:^(id responseObj) {
            if (responseObj) {
                ReturnInfoModel * infoModel=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                [YJProgressHUD showMessage:infoModel.info inView:weakSelf.view];
            }
        } failure:^(NSError *error) {
                [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
        }];
        
        
        dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        
        dispatch_source_set_event_handler(_timer, ^{
            
            if(time <= 0){ //倒计时结束，关闭
                
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //设置按钮的样式
                    [blockView.sendCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                    [blockView.sendCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    blockView.sendCodeBtn.userInteractionEnabled = YES;
                });
                
            }else{
                
                int seconds = time % 60;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //设置按钮显示读秒效果
                    [blockView.sendCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                    [blockView.sendCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    blockView.sendCodeBtn.userInteractionEnabled = NO;
                });
                time--;
            }
        });
        dispatch_resume(_timer);
        
    };

    _altView.commitBlock=^(NSString * codetext){
        
        if ( codetext==nil || codetext.length==0) {
            [YJProgressHUD showMessage:@"验证码不能为空" inView:weakSelf.view];
            return ;
        } else{
            
            NSString * username=NSUSER_DEF(USERINFO)[@"username"];
            NSDictionary * param=@{
                                   @"id":model.ID,
                                   @"userid":model.userid,
                                   @"username":username,
                                   @"yzm":codetext
                                   };
            
            [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=house&a=coupon_del",URLSTR] params:param success:^(id responseObj) {
                
                if (responseObj) {
                    ReturnInfoModel * infoModel=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                    [YJProgressHUD showMessage:infoModel.info inView:weakSelf.view];
                    if ([infoModel.success isEqual:@76]) {
                        
                        [blockView removeFromSuperview];
                        
                        dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, (int64_t) 2.0*NSEC_PER_SEC);
                        dispatch_after(time, dispatch_get_main_queue(), ^{
                           [weakSelf loadData];
                        });
 
                    }
                }
                
            } failure:^(NSError *error) {
                [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
            }];
  
        }
 
    };
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进入详情
    TSFPayModel * model=_dataArray[indexPath.row];
    
    IDModel * idmodel=[[IDModel alloc]init];
    idmodel.catid=@3;
    idmodel.ID=model.house_id;
    
    NewRoomDetailViewController * VC=[[NewRoomDetailViewController alloc]init];
    VC.idModel=idmodel;
    [self.navigationController pushViewController:VC animated:YES];
    
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"yhq" object:nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
