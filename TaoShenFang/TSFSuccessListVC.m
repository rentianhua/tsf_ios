//
//  TSFSuccessListVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/4.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFSuccessListVC.h"
#import "ZYWHttpEngine.h"
#import "OtherHeader.h"
#import "TSFAgentSuccessCell.h"
#import "HouseModel.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "TSFAgentModel.h"
#import "TSFAgentBaseModel.h"
#import "IDModel.h"
#import "HandRoomDetailVC.h"
#define BTNW 20

@interface TSFSuccessListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,strong)UIButton * leftNavBtn;

@end

@implementation TSFSuccessListVC
- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, BTNW, BTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}
- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
        _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        
        [_tableView registerNib:[UINib nibWithNibName:@"TSFAgentSuccessCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (void)pop:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    [self.view addSubview:self.tableView];
    
    
    if (_isHand==YES) {
        self.navigationItem.title=@"经纪人二手房";
        [self loadHandData];
    } else{
        self.navigationItem.title=@"经纪人成交房源";
        [self loadSuccessData];
    }
    
}


- (void)loadSuccessData{
   
    
    NSDictionary * param=@{@"username":_model.base.username,
                           @"table":@"ershou",
                           @"userid":NSUSER_DEF(USERINFO)[@"userid"]};
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=chengjiao",URLSTR] params:param success:^(id responseObj) {
        if (responseObj) {
            _dataArray=[HouseModel mj_objectArrayWithKeyValuesArray:responseObj];
            [self.tableView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadHandData{
    NSDictionary * param=@{@"username":_model.base.username,
                           @"userid":_model.userid,
                           @"table":@"ershou"};
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=house_list",URLSTR] params:param success:^(id responseObj) {
        if (responseObj) {
            _dataArray=[HouseModel mj_objectArrayWithKeyValuesArray:responseObj];
            
            [self.tableView reloadData];
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSFAgentSuccessCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    HouseModel * model=_dataArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
    cell.label1.text=model.title;
    cell.label2.text=[NSString stringWithFormat:@"%@/%@/%@层",model.chaoxiang,model.ceng,model.zongceng];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.inputtime integerValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    if (_isHand==YES) {
       cell.label3.text=[NSString stringWithFormat:@"发布时间:%@",confromTimespStr];
    } else{
    cell.label3.text=[NSString stringWithFormat:@"签约时间:%@",confromTimespStr];
    }
    
    NSString * danjia=nil;
    if ([model.jianzhumianji isEqualToString:@"0"] || model.jianzhumianji==nil ||  [model.zongjia isEqualToString:@"0"] || model.zongjia==nil ) {
        danjia=@"价格待定";
    } else{
        danjia=[NSString stringWithFormat:@"%.f", 10000* [model.zongjia floatValue]/[model.jianzhumianji floatValue]];
    }
    
    
    NSString * price=[NSString stringWithFormat:@"%@元/平",danjia];
    NSString * zongjia=[NSString stringWithFormat:@"%@万",model.zongjia];
    NSString * string=[NSString stringWithFormat:@"%@ %@",price,zongjia];
    
    NSRange range1=[string rangeOfString:zongjia];
    NSRange range2=[string rangeOfString:danjia];
    
    NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:string];
    [attrStr setAttributes:@{NSForegroundColorAttributeName:RGB(237, 27, 36, 1.0),NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:range1];
    [attrStr setAttributes:@{NSForegroundColorAttributeName:RGB(51, 51, 51, 1.0),NSFontAttributeName:[UIFont systemFontOfSize:12]} range:range2];
    [cell.label4 setAttributedText:attrStr];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HouseModel * model=_dataArray[indexPath.row];
    HandRoomDetailVC * VC=[[HandRoomDetailVC alloc]init];
    VC.model=model;
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
