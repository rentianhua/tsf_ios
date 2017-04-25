//
//  TSFInfoListVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/25.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFInfoListVC.h"
#import "OtherHeader.h"
#import "ZYWHttpEngine.h"

#import "YJProgressHUD.h"
#import <UIImageView+WebCache.h>
#import <MJExtension.h>

#import "InformationModel.h"
#import "IDModel.h"

#import "TSFNewInfoCell.h"

#import "HomeInformatiomController.h"

@interface TSFInfoListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * dataArray;


@property (nonatomic,strong)UIButton * leftNavBtn;

@end

@implementation TSFInfoListVC

- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
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
        
        [_tableView registerNib:[UINib nibWithNibName:@"TSFNewInfoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
       
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"新房资讯";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    
    [self.view addSubview:self.tableView];
    [self loadInfo];
    
}

- (void)loadInfo{
    
    __weak typeof(self)weakSelf=self;
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    NSString * urlInfo=[NSString stringWithFormat:@"%@g=api&m=house&a=position",URLSTR];
    NSDictionary * paramInfo=@{@"posid":@14};
    [ZYWHttpEngine AllPostURL:urlInfo params:paramInfo success:^(id responseObj) {
        [YJProgressHUD hide];
        
        if (responseObj) {
            weakSelf.dataArray=[InformationModel mj_objectArrayWithKeyValuesArray:responseObj];
            [weakSelf.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InformationModel * model=self.dataArray[indexPath.row];
    TSFNewInfoCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.data.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
    cell.label1.text=model.data.title;
    cell.label2.text=model.data.descrip;
    cell.label3.text=@"行业资讯";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeInformatiomController * vc=[[HomeInformatiomController alloc]init];
    InformationModel * model=self.dataArray[indexPath.row];
    IDModel * idmodel=[[IDModel alloc]init];
    idmodel.catid=model.catid;
    idmodel.ID=model.ID;
    vc.idModel=idmodel;
    [self.navigationController pushViewController:vc animated:YES];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (void)pop:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
