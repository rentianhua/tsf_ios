//
//  ShowingsViewController.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/19.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "ShowingsViewController.h"
#import "OrderModel.h"
#import "HouseModel.h"
#import "OrderHouseModel.h"
#import <MJExtension.h>
#import "ZYWHttpEngine.h"
#import "OrderCell.h"
#import <SDCycleScrollView.h>
#import "LoginViewController.h"
#import "OtherHeader.h"
#import "HandRoomViewController.h"
#import "HandRoomDetailVC.h"
#import "YJProgressHUD.h"
#import "ReturnInfoModel.h"

@interface ShowingsViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)UIView * noDataView;

@property (nonatomic,strong)NSArray * imageArray;

@property (nonatomic,strong)NSArray * dataArray;

@property (nonatomic,strong)UISegmentedControl * segment;

@property (nonatomic,strong)UIButton * loginButton;

@property (nonatomic,strong)UILabel * titleLabel;

@property (nonatomic,strong)UIImageView * havenodataImgView;



@end

@implementation ShowingsViewController
- (UIImageView *)havenodataImgView{
    if (_havenodataImgView==nil) {//无数据显示
        _havenodataImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-44)];
        _havenodataImgView.image=[UIImage imageNamed:@"message_no_01"];
        
    }
    return _havenodataImgView;
}
- (UILabel *)titleLabel{//经纪人登录  显示带看行程
    if (_titleLabel==nil) {
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 21)];
        _titleLabel.text=@"带看行程";
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.textColor=[UIColor blackColor];
        _titleLabel.font=[UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (UIButton *)loginButton{//登录按钮
    if (_loginButton==nil) {
        
        CGFloat loginW=120;
        CGFloat loginH=40;
        CGFloat loginX=(kMainScreenWidth-loginW)*0.5;
        CGFloat loginY=kMainScreenHeight*0.7;
        _loginButton=[[UIButton alloc]initWithFrame:CGRectMake(loginX, loginY, loginW, loginH)];
        [_loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:NavBarColor];
        [_loginButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.layer.masksToBounds=YES;
        _loginButton.layer.cornerRadius=5;
    }
    return _loginButton;
}

- (UISegmentedControl *)segment{//导航条上显示 未登录/普通用户
    if (_segment==nil) {
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"看房行程",@"带看行程",nil];
        _segment=[[UISegmentedControl alloc]initWithItems:segmentedArray];
        _segment.frame=CGRectMake(0, 0, 100, 30);
        [_segment setTintColor:NavBarColor];
        _segment.selectedSegmentIndex=0;
        [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}
- (NSArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSArray array];
    }
    return _dataArray;
}
- (UITableView *)tableView{//已经登录
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-44) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}
- (NSArray *)imageArray{
    if (_imageArray==nil) {
        _imageArray=@[@"icon_kanfang_1",@"icon_kanfang_2",@"icon_kanfang_3"];
    }
    return _imageArray;
}
- (UIView *)noDataView{
    if (_noDataView==nil) {
        
        CGFloat noViewH=kMainScreenHeight*0.5+31;
        CGFloat noViewW=noViewH*557/405;
        CGFloat noViewX=(kMainScreenWidth-noViewW)*0.5;
        CGFloat noViewY=kMainScreenHeight*0.1;
        _noDataView=[[UIView alloc]initWithFrame:CGRectMake(noViewX, noViewY, noViewW, noViewH)];
        SDCycleScrollView * scroll=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, noViewW, noViewH-31) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        scroll.backgroundColor=UIColorFromRGB(0Xf0eff5);
        scroll.autoScroll=NO;
        scroll.imageURLStringsGroup=self.imageArray;
        [_noDataView addSubview:scroll];
        UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(scroll.frame)+10, noViewW, 21)];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.text=@"把房子加入待看清单";
        label1.textColor=[UIColor grayColor];
        label1.font=[UIFont systemFontOfSize:14];
        [_noDataView addSubview:label1];
      
    }
    return _noDataView;
}
//******************UISegmentedControl****************************
- (void)segmentAction:(UISegmentedControl *)segment{
    NSInteger index=segment.selectedSegmentIndex;
   
        switch (index) {
            case 0:{//看房行程
                self.select=SegmentSelectLeft;
                [self loadData];
            }
                break;
                
            default:{//带看行程
                self.select=SegmentSelectRight;
                [self loadTakeLookData];
            }
                break;
        }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (NSUSER_DEF(USERINFO)==nil ) {//未登录
        //导航栏
        self.tableView.hidden=YES;
        if (!self.titleLabel.superview) {
          self.navigationItem.titleView=self.titleLabel;
          self.titleLabel.text=@"看房";
        }
        self.noDataView.hidden=NO;
        self.havenodataImgView.hidden=YES;
        self.loginButton.hidden=NO;
        [self.loginButton setTitle:@"去登录" forState:UIControlStateNormal];
        
    } else{//已登录

        NSString * modelid=NSUSER_DEF(USERINFO)[@"modelid"];
        
        if ([modelid isEqualToString:@"35"]) {//普通用户
            [self loadData];//已经登录 加载用户数据
            //导航栏
            if (!self.segment.superview) {
                self.navigationItem.titleView=self.segment;
            }

        } else{//经纪人
            [self loadTakeLookData];//带看行程

            if (!self.titleLabel.superview) {
               self.titleLabel.text=@"带看行程";

               self.navigationItem.titleView=self.titleLabel;
            }

        }
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //设置导航条的背景图片
    UIImage *image=[UIImage imageNamed:@"navbarimg"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
   
    [self.view addSubview:self.tableView];
    self.tableView.hidden=YES;
    [self.view addSubview:self.noDataView];
    self.noDataView.hidden=YES;
    [self.view addSubview:self.havenodataImgView];
    self.havenodataImgView.hidden=YES;
    [self.view addSubview:self.loginButton];
    self.loginButton.hidden=YES;
    
    
    
}

- (void)loadData{//普通用户 看房行程
    
    self.havenodataImgView.hidden=YES;
    __weak typeof(self)weakSelf=self;
        self.segment.selectedSegmentIndex=0;
        self.select=SegmentSelectLeft;
        NSString * username=NSUSER_DEF(USERINFO)[@"username"];
        NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=user&a=yuyue",URLSTR];
        NSDictionary * param=@{@"username":username,@"t":@"2"};
    
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
        [ZYWHttpEngine AllPostURL:urlStr params:param success:^(id responseObj) {
            [YJProgressHUD hide];
            if (responseObj) {
                weakSelf.dataArray=[OrderModel mj_objectArrayWithKeyValuesArray:responseObj];

                if (weakSelf.dataArray.count>0) {
                    //显示列表
                    weakSelf.loginButton.hidden=YES;
                    weakSelf.noDataView.hidden=YES;
                    weakSelf.tableView.hidden=NO;
                    [weakSelf.tableView reloadData];
                    
                } else{//如果没有数据
                    weakSelf.tableView.hidden=YES;
                    weakSelf.noDataView.hidden=NO;
                    weakSelf.loginButton.hidden=NO;
                    [weakSelf.loginButton setTitle:@"去预约" forState:UIControlStateNormal];
  
                }
            }
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            weakSelf.tableView.hidden=YES;
            weakSelf.noDataView.hidden=YES;
            weakSelf.havenodataImgView.hidden=NO;
            weakSelf.loginButton.hidden=YES;
            [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];

        }];
    
}

- (void)loadTakeLookData{//带看行程
 
    self.noDataView.hidden=YES;
    self.loginButton.hidden=YES;
    NSString * username=NSUSER_DEF(USERINFO)[@"username"];
    NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=user&a=yuyue",URLSTR];
    NSDictionary * param=@{@"username":username,@"t":@"1"};
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    __weak typeof(self)weakSelf=self;
    [ZYWHttpEngine AllPostURL:urlStr params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            self.dataArray=[OrderModel mj_objectArrayWithKeyValuesArray:responseObj];
            if (self.dataArray.count>0) {
                //显示列表
                weakSelf.havenodataImgView.hidden=YES;
                weakSelf.tableView.hidden=NO;
                [weakSelf.tableView reloadData];
                
            } else{
                weakSelf.tableView.hidden=YES;
                weakSelf.loginButton.hidden=YES;
                weakSelf.havenodataImgView.hidden=NO;
            }
            
        }
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        
        weakSelf.tableView.hidden=YES;
        weakSelf.havenodataImgView.hidden=NO;
        
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];

    }];
}

- (void)loginAction:(UIButton *)button
{
    if (NSUSER_DEF(USERINFO) ==nil ) {
        LoginViewController * vc=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    } else{
        //去预约
        HandRoomViewController * vc=[[HandRoomViewController alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
  
}
#pragma mark-----UITableViewDelegate----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataArray.count==0) {
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    } else{
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel * model=self.dataArray[indexPath.row];
    OrderCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  
    cell.timeLabel.text=[NSString stringWithFormat:@"%@ %@",model.yuyuedate,model.yuyuetime];
    cell.stateLabel.text=model.zhuangtai;
    cell.titleLabel.text=model.house.title;
   
    
    NSString * modelid=NSUSER_DEF(USERINFO)[@"modelid"];
    if ([modelid isEqualToString:@"35"]) {
        if (self.select==SegmentSelectLeft) {
            cell.confirmBtn.hidden=YES;
            cell.phoneLabel.hidden=YES;
            
        } else{
            
            cell.confirmBtn.hidden=NO;
            cell.phoneLabel.hidden=NO;
            cell.phoneLabel.text=[NSString stringWithFormat:@"联系方式：%@",model.username];
            cell.confirmBtn.tag=indexPath.row;
            [cell.confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
            if ([model.lock isEqualToString:@"1"]) {//已经确认
                [cell.confirmBtn setTitle:@"已确认" forState:UIControlStateNormal];
                [cell.confirmBtn setBackgroundColor:DESCCOL];
                cell.confirmBtn.userInteractionEnabled=NO;
            } else{
                [cell.confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
                [cell.confirmBtn setBackgroundColor:ORGCOL];
                cell.confirmBtn.userInteractionEnabled=YES;
            }
        }
 
    } else{
        cell.confirmBtn.hidden=NO;
        cell.phoneLabel.hidden=NO;
        cell.phoneLabel.text=[NSString stringWithFormat:@"联系方式：%@",model.username];
        cell.confirmBtn.tag=indexPath.row;
        [cell.confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([model.lock isEqualToString:@"1"]) {//已经确认
            [cell.confirmBtn setTitle:@"已确认" forState:UIControlStateNormal];
            [cell.confirmBtn setBackgroundColor:DESCCOL];
            cell.confirmBtn.userInteractionEnabled=NO;
        } else{
            [cell.confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
            [cell.confirmBtn setBackgroundColor:ORGCOL];
            cell.confirmBtn.userInteractionEnabled=YES;
        }

    }
    
        //当前时间
    NSDate * now=[NSDate date];
    NSTimeZone * fromzone=[NSTimeZone systemTimeZone];
    NSInteger fromintervel=[fromzone secondsFromGMTForDate:now];
    NSDate * nowDate=[now dateByAddingTimeInterval:fromintervel];//当前时间
    //获取预约时间
    NSString * yuyuetime=model.yuyuetime;
    NSArray * array=[yuyuetime componentsSeparatedByString:@"-"];
    NSString * yuyuetime2=array[1];
    NSString * yuyueStr=[NSString stringWithFormat:@"%@ %@:00",model.yuyuedate,yuyuetime2];
    NSDateFormatter * dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * yuyue=[dateformatter dateFromString:yuyueStr];
    NSTimeZone * fromzone1=[NSTimeZone systemTimeZone];//获取当前时区
    NSInteger fromintervel1=[fromzone1 secondsFromGMTForDate:yuyue];
    NSDate * yuyueDate=[yuyue dateByAddingTimeInterval:fromintervel1];
    
    if ([yuyueDate isEqualToDate:[nowDate laterDate:yuyueDate]]) {//预约时间大于现在时间
        [cell.btn setBackgroundImage:[UIImage imageNamed:@"标签_01"] forState:UIControlStateNormal];
        [cell.btn setTitle:@"新预约" forState:UIControlStateNormal];
        [cell.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if ([yuyueDate isEqualToDate:[nowDate earlierDate:yuyueDate]]) {//预约时间小于现在时间
        [cell.btn setBackgroundImage:[UIImage imageNamed:@"标签_02"] forState:UIControlStateNormal];
        [cell.btn setTitle:@"已过期" forState:UIControlStateNormal];
        [cell.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.confirmBtn.hidden=YES;
    }
    
    
    return cell;
}

- (void)confirmAction:(UIButton *)confirmBtn{
    
   OrderModel * model=self.dataArray[confirmBtn.tag];
    /*  "username":"当前用户名",
     "id":"预约记录id"*/
    NSDictionary * param=@{@"username":NSUSER_DEF(USERINFO)[@"username"],
                           @"id":model.ID};
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    __weak typeof(self)weakSelf=self;
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=yuyue_confirm",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            ReturnInfoModel * info=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
            if ([info.success isEqual:@185]) {
                [YJProgressHUD showMessage:@"确认成功" inView:weakSelf.view];
                
                dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, (int64_t) 1.0*NSEC_PER_SEC);
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    [weakSelf loadTakeLookData];
                });
                
            }
        }
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
    }];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderModel * model=self.dataArray[indexPath.row];
    HouseModel * IDmodel=[[HouseModel alloc ]init];
    IDmodel.catid=@6;
    IDmodel.ID=model.house.ID;
    
     HandRoomDetailVC * vc=[[HandRoomDetailVC alloc]init];
     vc.model=IDmodel;
     vc.hidesBottomBarWhenPushed=YES;
     [self.navigationController pushViewController:vc animated:YES];

    
}
//按钮显示的内容
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
    
}
//这里就是点击删除执行的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self)weakSelf=self;
    if (self.select==SegmentSelectLeft) {
        OrderModel * model=self.dataArray[indexPath.row];
        NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
        NSString * username=NSUSER_DEF(USERINFO)[@"username"];
        NSDictionary * param=@{
                               @"id":model.ID,
                               @"userid":userid,
                               @"username":username
                               };
        [YJProgressHUD showProgress:@"网络不行了" inView:self.view];
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=yuyue_del",URLSTR] params:param success:^(id responseObj) {
            [YJProgressHUD hide];
            if (responseObj) {
                if ([responseObj[@"success"] isEqualToNumber:@101]) {//预约删除成功
                    
                    [YJProgressHUD showMessage:@"预约删除成功" inView:weakSelf.view];
                    
                    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, (int64_t) 1.0*NSEC_PER_SEC);
                    dispatch_after(time, dispatch_get_main_queue(), ^{
                        [weakSelf loadData];
                    });

                } else if ([responseObj[@"success"] isEqualToNumber:@113]){
                    [YJProgressHUD showMessage:@"已锁定，不能删除" inView:weakSelf.view];
                }
            }
            
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
             [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
        }];
    }

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([NSUSER_DEF(USERINFO)[@"modelid"] isEqualToString:@"35"]) {//普通用户
        if (self.select==SegmentSelectLeft) {
            return YES;
        } else{
            return NO;
        }
    } else{
        return NO;
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
