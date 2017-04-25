//
//  LouPanInfoController.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/25.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "LouPanInfoController.h"
#import "OtherHeader.h"
#import "LouPanXinXiCell.h"
#import "HouseModel.h"
@interface LouPanInfoController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSArray * array1;
@property (nonatomic,strong)NSArray * array2;
@property (nonatomic,strong)NSArray * array3;
@property (nonatomic,strong)NSArray * array4;

@property (nonatomic,strong)UIButton * leftNavBtn;

@end

@implementation LouPanInfoController

- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}
- (void)setInfomodel:(HouseModel *)infomodel
{
    _infomodel=infomodel;
    _dataArray=[NSMutableArray array];
    _array1=[NSArray arrayWithObjects:@{@"开发商":infomodel.kaifashang.length==0 ? @"":infomodel.kaifashang}, nil];
    _array2=[NSArray arrayWithObjects:
             @{@"参考均价":[NSString stringWithFormat:@"%@元/㎡",infomodel.junjia.length==0 ? @"":infomodel.junjia]},
             @{@"开盘时间":infomodel.kaipandate.length==0 ? @"":infomodel.kaipandate},
             @{@"交房时间":infomodel.jiaofangdate.length==0 ? @"":infomodel.jiaofangdate}, nil];
    
    //@[@"塔楼", @"板楼", @"板塔结合"];
    NSString *jianzhutype = @"";
    if([infomodel.jianzhuleixing isEqualToString:@"1"])
    {
        jianzhutype = @"塔楼";
    }
    if([infomodel.jianzhuleixing isEqualToString:@"2"])
    {
        jianzhutype = @"板楼";
    }
    if([infomodel.jianzhuleixing isEqualToString:@"3"])
    {
        jianzhutype = @"板塔结合";
    }
    _array3=[NSArray arrayWithObjects:
             @{@"物业类型":infomodel.wuyeleixing.length==0 ? @"":infomodel.wuyeleixing},
             @{@"建筑类型":jianzhutype},
             @{@"产权年限":[NSString stringWithFormat:@"%@年",infomodel.chanquannianxian.length==0 ? @"":infomodel.chanquannianxian]},
             @{@"规划户数":infomodel.guihuahushu.length==0 ? @"":infomodel.guihuahushu},
             @{@"规划车位":infomodel.guihuachewei.length==0 ? @"":infomodel.guihuachewei},
             @{@"容积率":infomodel.rongjilv.length==0 ? @"":infomodel.rongjilv},
             @{@"绿化率":infomodel.lvhualv.length==0 ? @"":infomodel.lvhualv},
             @{@"建筑面积":[NSString stringWithFormat:@"%@㎡",infomodel.jianzhumianji.length==0 ? @"":infomodel.jianzhumianji]},
             @{@"占地面价":[NSString stringWithFormat:@"%@㎡",infomodel.zhandimianji.length==0 ? @"":infomodel.zhandimianji]}, nil];
    _array4=[NSArray arrayWithObjects:
             @{@"物业公司":infomodel.wuyegongsi.length==0 ? @"无":infomodel.wuyegongsi},
             @{@"物业费":[NSString stringWithFormat:@"%@元/㎡",infomodel.wuyefei.length==0 ? @"":infomodel.wuyefei]},
             @{@"水电燃气":infomodel.shuidianranqi.length==0 ? @"无":infomodel.shuidianranqi}, nil];
    
    [_dataArray addObject:_array1];
    [_dataArray addObject:_array2];
    [_dataArray addObject:_array3];
    [_dataArray addObject:_array4];
    
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    
    [tableView registerClass:[LouPanXinXiCell class] forCellReuseIdentifier:@"cell"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"楼盘信息";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;//右滑返回
}

#pragma mark----UITableViewDelegate---

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LouPanXinXiCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary * dict=_dataArray[indexPath.section][indexPath.row];
    NSString * str= dict.allKeys[0];
    NSString * strV=dict.allValues[0];
    cell.leftLabel.text=str;
    cell.rightLabel.text=strV;
    
    return cell;
}

- (void)pop:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
