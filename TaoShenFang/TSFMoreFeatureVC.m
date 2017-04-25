//
//  TSFMoreFeatureVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/15.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFMoreFeatureVC.h"
#import "OtherHeader.h"
#import "HouseModel.h"

#import "HandFeatureCell.h"

#import <Masonry.h>
#import <UITableViewCell+HYBMasonryAutoCellHeight.h>

@interface TSFMoreFeatureVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIButton * cancelBtn;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView  * headerView;


@end

@implementation TSFMoreFeatureVC

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
        [_tableView registerClass:[HandFeatureCell class] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (UIView *)headerView{
    if (_headerView==nil) {
        _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
        _headerView.backgroundColor=[UIColor whiteColor];
        
        UILabel * label= [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kMainScreenWidth-30, 40)];
        label.text=@"房源特色";
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HandFeatureCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0://周边配套
            cell.title.text=@"周边配套";
            [cell configCellWithString:_model.shenghuopeitao];
            break;
        case 1://小区优势
            cell.title.text=@"小区优势";
            [cell configCellWithString:_model.xiaoquyoushi];
            break;
        case 2://教育配套
            cell.title.text=@"教育配套";
            [cell configCellWithString:_model.xuexiaomingcheng];
            break;
        case 3://投资分析
            cell.title.text=@"投资分析";
            [cell configCellWithString:_model.touzifenxi];
            break;
        case 4://核心卖点
            cell.title.text=@"核心卖点";
            [cell configCellWithString:_model.hexinmaidian];
            break;
        case 5://权属抵押
            cell.title.text=@"权属抵押";
            [cell configCellWithString:_model.quanshudiya];
            break;
        case 6://交通出行
            cell.title.text=@"交通出行";
            [cell configCellWithString:_model.jiaotong];
            break;
        case 7://税费解析
            cell.title.text=@"税费解析";
            [cell configCellWithString:_model.shuifeijiexi];
            break;
        case 8://装修描述
            cell.title.text=@"装修描述";
            [cell configCellWithString:_model.zxdesc];
            break;
            
        default://推荐理由
            cell.title.text=@"推荐理由";
            [cell configCellWithString:_model.yezhushuo];
            break;
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0://周边配套
            return [HandFeatureCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                HandFeatureCell * cell=(HandFeatureCell *)sourceCell;
                [cell configCellWithString:_model.shenghuopeitao];
            }];
            break;
        case 1://小区优势
            return [HandFeatureCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                HandFeatureCell * cell=(HandFeatureCell *)sourceCell;
                [cell configCellWithString:_model.xiaoquyoushi];
            }];
            break;
        case 2://教育配套
            return [HandFeatureCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                HandFeatureCell * cell=(HandFeatureCell *)sourceCell;
                [cell configCellWithString:_model.xuexiaomingcheng];
            }];
            break;
        case 3://投资分析
            return [HandFeatureCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                HandFeatureCell * cell=(HandFeatureCell *)sourceCell;
                [cell configCellWithString:_model.touzifenxi];
            }];
            break;
        case 4://核心卖点
            return [HandFeatureCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                HandFeatureCell * cell=(HandFeatureCell *)sourceCell;
                [cell configCellWithString:_model.hexinmaidian];
            }];
            break;
        case 5://权属抵押
            return [HandFeatureCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                HandFeatureCell * cell=(HandFeatureCell *)sourceCell;
                [cell configCellWithString:_model.quanshudiya];
            }];
            break;
        case 6://交通出行
            return [HandFeatureCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                HandFeatureCell * cell=(HandFeatureCell *)sourceCell;
                [cell configCellWithString:_model.jiaotong];
            }];
            break;
        case 7://税费解析
            return [HandFeatureCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                HandFeatureCell * cell=(HandFeatureCell *)sourceCell;
                [cell configCellWithString:_model.shuifeijiexi];
            }];
            break;
        case 8://装修描述
            return [HandFeatureCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                HandFeatureCell * cell=(HandFeatureCell *)sourceCell;
                [cell configCellWithString:_model.zhuangxiu];
            }];
            break;
        default://推荐理由
            return [HandFeatureCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                HandFeatureCell * cell=(HandFeatureCell *)sourceCell;
                [cell configCellWithString:_model.yezhushuo];
            }];

            
            break;
    }
    
    
    
}

- (void)cancleAction:(UIButton *)cancelBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
