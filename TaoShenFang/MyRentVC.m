//
//  MyRentVC.m
//  TaoShenFang
//
//  Created by YXM on 16/8/30.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "MyRentVC.h"
#import "OtherHeader.h"
#import <MJExtension.h>
#import "SaleHouseVC.h"
#import <UIImageView+WebCache.h>
#import "ZYWHttpEngine.h"
#import "TSFRentCell.h"
#import "UserModel.h"
#import "RentSaleVC.h"//普通用户发布租房
#import "BorkerRentSaleVC.h"//经纪人发布租房
#import "HouseModel.h"
#import "RentRoomDetailVC.h"
#import "IDModel.h"
#import "ReturnInfoModel.h"
#import "YJProgressHUD.h"
#import "KSAlertView.h"

#define ImgViewW kMainScreenWidth *0.25
#define ImgViewH ImgViewW *2/3
#define NAVBTNW 20
@interface MyRentVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;

//导航条上的按钮
@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UIButton * rightNavBtn;
@property (nonatomic,strong)NSArray * dataArray;


@end

@implementation MyRentVC
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
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn];
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我要出租";
    self.view.backgroundColor=SeparationLineColor;
    
    //如果有数据 ————————》显示列表
    //如果没有数据————————》显示空页面
    //[self viewToNilData];
    [self initWithHandListTableView];
}

- (void)loadData{
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    NSString * username=NSUSER_DEF(USERINFO)[@"username"];
    NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
    NSDictionary * param=@{
                           @"username":username,
                           @"userid":userid,
                           @"table":@"chuzu"
                           };
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=house_list",URLSTR] params:param success:^(id responseObj) {
        
        [YJProgressHUD hide];
        if (responseObj) {
            self.dataArray=[HouseModel mj_objectArrayWithKeyValuesArray:responseObj];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
    }];
}

//跳转到发布房源界面
- (void)toRental{
    if ([NSUSER_DEF(USERINFO)[@"modelid"] isEqualToString:@"35"]/*[_model.modelid isEqualToString:@"35"]*/) {//普通用户发布房源
        RentSaleVC * vc=[[RentSaleVC alloc]init];
        vc.type=RentIssueTypeGeneral;
        [self.navigationController pushViewController:vc animated:YES];
    } else{//经纪人发布房源
        BorkerRentSaleVC * vc=[[BorkerRentSaleVC alloc]init];
        vc.type=RentBrokerIssueTypeGeneral;
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
    // tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [tableView registerNib:[UINib nibWithNibName:@"TSFRentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    UIView * view=[[UIView alloc]initWithFrame:CGRectZero];
    [tableView setTableFooterView:view];
}

#pragma mark----UITableViewDelegate/UITableViewDataSource--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //标题、&小区名称 ---->&几室几厅  面积 朝向 ---->&楼层 总层、物业性质 ----》唯一住宅 》》》》总价 单价
    
    TSFRentCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    HouseModel * model=self.dataArray[indexPath.row];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
    cell.label1.text=model.title;
    cell.label2.text=[NSString stringWithFormat:@"%@/%@/%@",model.cityname,model.areaname,model.xiaoquname];
    if ([model.shi isEqualToString:@"6"]) {
        cell.label3.text=[NSString stringWithFormat:@"5室以上%@厅/%@㎡",model.ting,model.mianji];
    } else{
        cell.label3.text=[NSString stringWithFormat:@"%@室%@厅/%@㎡",model.shi,model.ting,model.mianji];
    }
    if ([model.pub_type isEqualToString:@"1"]) {
        cell.label4.text=@"直接出租";
    } else if ([model.pub_type isEqualToString:@"2"]){
        cell.label4.text=@"委托给经纪人";
    } else if ([model.pub_type isEqualToString:@"3"]){
        cell.label4.text=@"委托给平台";
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
    NSString * str=[NSString stringWithFormat:@"%@元/月",model.zujin];
    NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:str];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, str.length-3)];
    [cell.label5 setAttributedText:attrStr];
    cell.editBtn.tag=indexPath.row;
    [cell.editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.deleteBtn.tag=indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([model.zaizu isEqualToString:@"1"])
    {
        if ([model.apply_state isEqualToString:@"1"])
        {
            //1.已申请
            [cell.applyBtn setTitle:@"已出租申请中" forState:UIControlStateNormal];
            [cell.applyBtn setTitleColor:ORGCOL forState:UIControlStateNormal];
            cell.applyBtn.layer.borderColor=ORGCOL.CGColor;
            cell.applyBtn.layer.borderWidth=1;
            cell.applyBtn.layer.masksToBounds=YES;
            cell.applyBtn.layer.cornerRadius=5;
        } else{
            //未申请
            cell.applyBtn.tag=indexPath.row;
            [cell.applyBtn setTitle:@"申请已出租" forState:UIControlStateNormal];
            [cell.applyBtn addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.applyBtn setTitleColor:TITLECOL forState:UIControlStateNormal];
            cell.applyBtn.layer.borderColor=TITLECOL.CGColor;
            cell.applyBtn.layer.borderWidth=1;
            cell.applyBtn.layer.masksToBounds=YES;
            cell.applyBtn.layer.cornerRadius=5;
        }
    }
    else
    {
        [cell.applyBtn setTitle:@"已出租" forState:UIControlStateNormal];
        [cell.applyBtn setTitleColor:RGB(26, 171, 168, 1.0) forState:UIControlStateNormal];
        cell.applyBtn.layer.borderColor=RGB(26, 171, 168, 1.0).CGColor;
        cell.applyBtn.layer.borderWidth=1;
        cell.applyBtn.layer.masksToBounds=YES;
        cell.applyBtn.layer.cornerRadius=5;
    }
    if([model.status intValue] == 1)
    {
        cell.applyBtn.hidden = YES;
    }
    else
    {
        cell.applyBtn.hidden = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HouseModel * model=self.dataArray[indexPath.row];
    
    if ([model.status isEqual:@1]) {//待审核
        [YJProgressHUD showMessage:@"房源待审核" inView:self.view];
        return;
    }
    
    IDModel * idmodel=[[IDModel alloc]init];
    idmodel.catid=model.catid;
    idmodel.ID=model.ID;
    RentRoomDetailVC * VC=[[RentRoomDetailVC alloc]init];
    VC.model=idmodel;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)editAction:(UIButton *)button{
    HouseModel * model=self.dataArray[button.tag];
    if ([NSUSER_DEF(USERINFO)[@"modelid"] isEqualToString:@"35"]/*[_model.modelid isEqualToString:@"35"]*/) {//普通用户发布房源
        RentSaleVC * vc=[[RentSaleVC alloc]init];
        vc.model=model;
        vc.type=RentIssueTypeEdit;
        [self.navigationController pushViewController:vc animated:YES];
    } else{//经纪人发布房源
        BorkerRentSaleVC * vc=[[BorkerRentSaleVC alloc]init];
        vc.model=model;
        vc.type=RentBrokerIssueTypeEdit;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)deleteAction:(UIButton *)deleteBtn{
    
    __weak typeof(self)weakSelf=self;
    [KSAlertView showWithTitle:@"提示" message1:@"是否删除" cancelButton:@"取消" commitType:KSAlertViewButtonCommit commitAction:^(UIButton *button) {
        
        HouseModel * model=weakSelf.dataArray[deleteBtn.tag];
        
        if ([model.lock isEqual:@1]) {
            [YJProgressHUD showMessage:@"房源已锁定" inView:weakSelf.view];
            return ;
        }
        NSString * username=NSUSER_DEF(USERINFO)[@"username"];
        NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
        
        NSDictionary * param=@{@"username":username,
                               @"userid":userid,
                               @"table":@"chuzu",
                               @"id":model.ID
                               };
        
        [YJProgressHUD showProgress:@"正在加载中" inView:weakSelf.view];
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=house_del",URLSTR] params:param success:^(id responseObj) {
            [YJProgressHUD hide];
            if (responseObj) {
                ReturnInfoModel * infomodel=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                [YJProgressHUD showMessage:infomodel.info inView:weakSelf.view];
                if ([infomodel.success isEqual:@167]) {
                    
                    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, (int64_t) 1.0*NSEC_PER_SEC );
                    dispatch_after(time, dispatch_get_main_queue(), ^{
                        [weakSelf loadData];
                    });
                    
                }
            }
            
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
        }];
        
    }];
    
}
//申请已出租

- (void)applyAction:(UIButton *)applyBtn{
    
    
    HouseModel * model=_dataArray[applyBtn.tag];
    
    if (model.apply_state && model.apply_state.length>0 && ![model.apply_state isEqualToString:@"0"]) {
        return;
    }
    NSDictionary * param=@{@"id":model.ID,
                           @"table":@"chuzu",
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
