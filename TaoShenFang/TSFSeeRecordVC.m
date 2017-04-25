//
//  TSFSeeRecordVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/17.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFSeeRecordVC.h"
#import "TSFSeeHouseModel.h"
#import "OtherHeader.h"

#import "TSFSeeRecordCell.h"
#define NAVBTNW 20


@interface TSFSeeRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tabelView;
@property (nonatomic,strong)UIView * Head;
@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UILabel * label11;//近七天带看
@property (nonatomic,strong)UILabel * label22;//总带看


@end

@implementation TSFSeeRecordVC

- (UILabel *)label11{
    if (_label11==nil) {
        _label11=[[UILabel alloc]initWithFrame:CGRectMake(15, 20, (kMainScreenWidth-45)*0.5, 40)];
        _label11.textColor=DESCCOL;
        _label11.font=[UIFont boldSystemFontOfSize:18];
        _label11.textAlignment=NSTextAlignmentCenter;
        
    }
    return _label11;
}
- (UILabel *)label22{
    if (_label22==nil) {
        _label22=[[UILabel alloc]initWithFrame:CGRectMake(15*2+(kMainScreenWidth-45)*0.5, 20, (kMainScreenWidth-45)*0.5, 40)];
        _label22.textColor=DESCCOL;
        _label22.font=[UIFont boldSystemFontOfSize:18];
        _label22.textAlignment=NSTextAlignmentCenter;
        
    }
    return _label22;
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
- (UIView *)Head{
    if (_Head==nil) {
        _Head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 120)];
        
        [_Head addSubview:self.label11];
        [_Head addSubview:self.label22];
        UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(15, 60, (kMainScreenWidth-45)*0.5, 60)];
        label1.text=@"近七天带看(次)";
        label1.textColor=TITLECOL;
        label1.font=[UIFont systemFontOfSize:14];
        label1.textAlignment=NSTextAlignmentCenter;
        [_Head addSubview:label1];
        
        UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+15, 60, (kMainScreenWidth-45)*0.5, 60)];
        label2.text=@"总带看(次)";
        label2.textColor=TITLECOL;
        label2.textAlignment=NSTextAlignmentCenter;
        label2.font=[UIFont systemFontOfSize:14];
        [_Head addSubview:label2];
        
    }
    return _Head;
}
- (UITableView * )tabelView{
    if (_tabelView==nil) {
        _tabelView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        _tabelView.delegate=self;
        _tabelView.dataSource=self;
        [_tabelView registerNib:[UINib nibWithNibName:@"TSFSeeRecordCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tabelView.tableHeaderView=self.Head;
        
        _tabelView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tabelView;
}

- (void)setDaikanArray:(NSArray *)daikanArray{
    _daikanArray=daikanArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tabelView];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.title=@"带看记录";
    
    [self showHeadView];
}
- (void)showHeadView{
    NSMutableArray * jinqidaikan=[NSMutableArray array];
    for (int i=0; i<self.daikanArray.count;i++) {
        NSDateFormatter *format=[[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        TSFSeeHouseModel * daikanM=self.daikanArray[i];
        NSDate *fromdate=[format dateFromString:daikanM.yuyuedate];
        if (fabs([fromdate timeIntervalSinceNow])<=60*60*24*7) {//时间大于七天前的时间
            [jinqidaikan addObject:daikanM];
        }
    }
    _label11.text=[NSString stringWithFormat:@"%ld",jinqidaikan.count];
    _label22.text=[NSString stringWithFormat:@"%ld",_daikanArray.count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _daikanArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSFSeeRecordCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    TSFSeeHouseModel * model=self.daikanArray[indexPath.row];
    cell.label1.text=model.yuyuedate;
    cell.label2.text=model.realname;
    NSRange range=NSMakeRange(4, 4);
    cell.label3.text=[model.username stringByReplacingCharactersInRange:range withString:@"****"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    headView.backgroundColor=[UIColor whiteColor];
    headView.layer.borderColor=SeparationLineColor.CGColor;
    headView.layer.borderWidth=0.8;
    UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 90, 44)];
    label1.text=@"看房日期";
    label1.textColor=DESCCOL;
    label1.font=[UIFont systemFontOfSize:14];
    [headView addSubview:label1];
    
    UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 44)];
    label2.text=@"看房人";
    label2.textColor=DESCCOL;
    label2.font=[UIFont systemFontOfSize:14];
    [headView addSubview:label2];
    label2.center=CGPointMake(headView.center.x, headView.center.y);

    
    UILabel * label3=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame)+15, 0, 90, 44)];
    label3.text=@"看房人电话";
    label3.textColor=DESCCOL;
    label3.font=[UIFont systemFontOfSize:14];
    [headView addSubview:label3];

    return headView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
