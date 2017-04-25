//
//  TSFUserBuyVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/10.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFUserBuyVC.h"
#import "OtherHeader.h"
#import "ZYWHttpEngine.h"
#import <MJExtension.h>
#import "TSFRentManagerCell.h"
#import "TSFRentMangerModel.h"
#import "TSFIssueUserBuyVC.h"
#import "YJProgressHUD.h"

#import "ReturnInfoModel.h"

#define NAVBTNW 20

@interface TSFUserBuyVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray  * dataArray;
@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UIButton * rightNavBtn;

@end

@implementation TSFUserBuyVC

- (UIButton *)rightNavBtn{
    if (_rightNavBtn==nil) {
        _rightNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 21)];
        [_rightNavBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_rightNavBtn setTitleColor:ORGCOL forState:UIControlStateNormal];
        [_rightNavBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_rightNavBtn addTarget:self action:@selector(issueAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNavBtn;
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

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:@"TSFRentManagerCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
        _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadView{
    [super loadView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn];
    [self.view addSubview:self.tableView];
    
    
}

- (void)loadData{
    
    __weak typeof(self)weakSelf=self;
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    NSString * username=NSUSER_DEF(USERINFO)[@"username"];
    
    NSDictionary * param=@{
                           @"username":username,
                           @"table":@"userqiugou"
                           };
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=qiu_list",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            
            weakSelf.dataArray=[TSFRentMangerModel mj_objectArrayWithKeyValuesArray:responseObj];
            
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];

    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSFRentManagerCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    TSFRentMangerModel * model=_dataArray[indexPath.row];
    NSString * quyu=[NSString stringWithFormat:@"行政区域：%@%@%@",model.province_name,model.city_name,model.area_name];
    NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:quyu];
    NSRange range1=[quyu rangeOfString:@"行政区域："];
    [attrStr addAttribute:NSForegroundColorAttributeName value:DESCCOL range:range1];
    [cell.label1 setAttributedText:attrStr];
    
    
    //时间戳转时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:model.updatetime];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    
    NSString * time=[NSString stringWithFormat:@"%@",confromTimespStr];
    cell.timeLabel.text=time;
    
    
    NSString * tel=[NSString stringWithFormat:@"联系方式：%@ %@",model.chenghu,model.username];
    NSRange range4=[tel rangeOfString:@"联系方式："];
    NSMutableAttributedString * attrStr4=[[NSMutableAttributedString alloc]initWithString:tel];
    [attrStr4 addAttribute:NSForegroundColorAttributeName value:DESCCOL range:range4];
    [cell.label2 setAttributedText:attrStr4];
    
    if ([[[model.zongjiarange componentsSeparatedByString:@"-"] lastObject] isEqualToString:@""]) {
        NSString * zujin=[NSString stringWithFormat:@"总价范围：%@万以上",[[model.zongjiarange componentsSeparatedByString:@"-"] firstObject]];
        NSRange rangezujin=[zujin rangeOfString:@"总价范围："];
        NSRange rangeyuan=[zujin rangeOfString:@"万以上"];
        NSMutableAttributedString * attrStrzujin=[[NSMutableAttributedString alloc]initWithString:zujin];
        [attrStrzujin addAttribute:NSForegroundColorAttributeName value:DESCCOL range:rangezujin];
        [attrStrzujin addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:rangezujin];
        [attrStrzujin addAttribute:NSForegroundColorAttributeName value:TITLECOL range:rangeyuan];
        [attrStrzujin addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:rangeyuan];
        
        [cell.label3 setAttributedText:attrStrzujin];
    } else{
    
    NSString * zujin=[NSString stringWithFormat:@"总价范围：%@万",model.zongjiarange];
    NSRange rangezujin=[zujin rangeOfString:@"总价范围："];
    NSRange rangeyuan=[zujin rangeOfString:@"万"];
    NSMutableAttributedString * attrStrzujin=[[NSMutableAttributedString alloc]initWithString:zujin];
    [attrStrzujin addAttribute:NSForegroundColorAttributeName value:DESCCOL range:rangezujin];
    [attrStrzujin addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:rangezujin];
    [attrStrzujin addAttribute:NSForegroundColorAttributeName value:TITLECOL range:rangeyuan];
    [attrStrzujin addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:rangeyuan];
    
    [cell.label3 setAttributedText:attrStrzujin];
    }
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        TSFRentMangerModel * model=_dataArray[indexPath.row];
        if ([NSUSER_DEF(USERINFO)[@"modelid"] isEqualToString:@"35"] && [model.lock isEqual:@1]) {
            [YJProgressHUD showMessage:@"数据已锁定，不能删除" inView:self.view];
            return;
        }
        
        NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
        NSString * username=NSUSER_DEF(USERINFO)[@"username"];
        
        NSDictionary * param=@{@"id":model.ID,
                               @"userid":userid,
                               @"username":username
                               };
        __weak typeof(self)weakSelf=self;
        [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=qiugou_del",URLSTR] params:param success:^(id responseObj) {
            [YJProgressHUD hide];
            if (responseObj) {
                ReturnInfoModel * info=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                [YJProgressHUD showMessage:info.info inView:weakSelf.view];
                
                if ([info.success isEqual:@127]) {
                   
                    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, (int64_t) 2.0*NSEC_PER_SEC );
                    dispatch_after(time, dispatch_get_main_queue(), ^{
                        [weakSelf loadData];
                    });
 
                }
            }
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];

        }];
    }
}

//发布
- (void)issueAction:(UIButton *)button{
    
    TSFIssueUserBuyVC * VC=[[TSFIssueUserBuyVC alloc]init];
    
    
    [self.navigationController pushViewController:VC animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
