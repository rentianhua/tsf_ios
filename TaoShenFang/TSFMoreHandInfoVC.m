//
//  TSFMoreHandInfoVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/15.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFMoreHandInfoVC.h"
#import "OtherHeader.h"
#import "HouseModel.h"

#import "TSFNatureCell.h"


@interface TSFMoreHandInfoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIButton * cancelBtn;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView  * headerView;

@property (nonatomic,strong)NSArray  * leftTitleArray;


@end

@implementation TSFMoreHandInfoVC
- (NSArray *)leftTitleArray{
    if (_leftTitleArray==nil) {
        _leftTitleArray=[NSArray arrayWithObjects:@"房屋户型",@"所在楼层",@"建筑面积",@"户型结构",@"套内面积",@"建筑类型",@"房屋朝向",@"建筑结构",@"装修情况",@"梯户比例",@"配备电梯",@"挂牌时间",@"物业类型",@"上次交易",@"房屋类型",@"产权所属",@"唯一住宅",@"抵押信息",nil];
    }
    return _leftTitleArray;
}
- (UIButton *)cancelBtn{
    if (_cancelBtn==nil) {
        _cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 30, 40, 40)];
        [_cancelBtn setImage:[UIImage imageNamed:@"cancel_02"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cancelBtn;
}

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 80, kMainScreenWidth, kMainScreenHeight-80) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableHeaderView=self.headerView;
        [_tableView registerNib:[UINib nibWithNibName:@"TSFNatureCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (UIView *)headerView{
    if (_headerView==nil) {
        _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
        _headerView.backgroundColor=[UIColor whiteColor];
        
        UILabel * label= [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kMainScreenWidth-30, 40)];
        label.text=@"基础属性/交易属性";
        label.font=[UIFont boldSystemFontOfSize:20];
        label.textColor=TITLECOL;
        [_headerView addSubview:label];
    }
    return _headerView;
}

- (void)setModel:(HouseModel *)model{
    _model=model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSFNatureCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.label1.text=self.leftTitleArray[indexPath.row];
    cell.label1.textColor=TITLECOL;
    cell.label1.font=[UIFont systemFontOfSize:18];
    cell.label2.font=[UIFont systemFontOfSize:14];
    
    /*@"房屋户型",@"所在楼层",@"建筑面积",@"户型结构",@"套内面积",@"建筑类型",@"房屋朝向",@"建筑结构",@"装修情况",@"梯户比例",@"配备电梯",@"挂牌时间",@"物业类型",@"上次交易",@"房屋类型",@"产权所属",@"唯一住宅",@"抵押信息",*/
    switch (indexPath.row) {
        case 0:
            if ([_model.shi isEqualToString:@"6"]) {
                cell.label2.text=[NSString stringWithFormat:@"5室以上%@厅",_model.ting];
            } else{
                cell.label2.text=[NSString stringWithFormat:@"%@室%@厅",_model.shi,_model.ting];
            }
            break;
        case 1:
            cell.label2.text=[NSString stringWithFormat:@"%@(共%@层)",_model.ceng,_model.zongceng];
            break;
        case 2:
            cell.label2.text=[NSString stringWithFormat:@"%@㎡",_model.jianzhumianji];
            break;
        case 3:
            cell.label2.text=[NSString stringWithFormat:@"%@",_model.jiegou];
            break;
        case 4:
            cell.label2.text=[NSString stringWithFormat:@"%@㎡",_model.taoneimianji];
            break;
        case 5:
            cell.label2.text=[NSString stringWithFormat:@"%@",_model.jianzhutype];
            break;
        case 6:
            cell.label2.text=[NSString stringWithFormat:@"%@",_model.chaoxiang];
            break;
        case 7:
            cell.label2.text=[NSString stringWithFormat:@"%@",_model.jianzhujiegou];
            break;
        case 8:
            cell.label2.text=[NSString stringWithFormat:@"%@",_model.zhuangxiu];
            break;
        case 9:
            cell.label2.text=[NSString stringWithFormat:@"%@",_model.tihubili];
            break;
        case 10:
            cell.label2.text=[NSString stringWithFormat:@"%@",_model.dianti];
            break;
        case 11:
            cell.label2.text=[NSString stringWithFormat:@"%@",_model.guapaidate];
            break;
        case 12:
            cell.label2.text=[NSString stringWithFormat:@"%@",_model.jiaoyiquanshu];
            break;
        case 13:
            cell.label2.text=[NSString stringWithFormat:@"%@",_model.shangcijiaoyi];
            break;
        case 14:
            cell.label2.text=[NSString stringWithFormat:@"%@",_model.fangwuyongtu];
            break;
        case 15:
            cell.label2.text=[NSString stringWithFormat:@"%@",_model.chanquansuoshu];
            break;
        case 16:
            cell.label2.text=[NSString stringWithFormat:@"%@",_model.isweiyi];
            break;
        default:
            cell.label2.text=[NSString stringWithFormat:@"%@",_model.diyaxinxi];
            break;
    }
    
    cell.label2.textColor=DESCCOL;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)cancleAction:(UIButton *)cancelBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
