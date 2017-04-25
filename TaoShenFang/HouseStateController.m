//
//  HouseStateController.m
//  TaoShenFangTest
//
//  Created by YXM on 16/8/15.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "HouseStateController.h"
#import "TSFNewDTCell.h"
#import "OtherHeader.h"

#import "TSFDTModel.h"

#import "YJProgressHUD.h"

@interface HouseStateController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIButton * leftNavBtn;

@end

@implementation HouseStateController
- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

- (void)setDongtaiArr:(NSArray *)dongtaiArr{
    _dongtaiArr=dongtaiArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"楼盘动态";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"TSFNewDTCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    if (_dongtaiArr.count==0) {
        [YJProgressHUD showMessage:@"暂无动态" inView:self.view];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dongtaiArr.count==0) {
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    } else{
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    }
    return _dongtaiArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSFDTModel *model=_dongtaiArr[indexPath.row];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil];
    CGRect rc = [model.descrip boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    if(rc.size.height>42)
    {
        return 160+(rc.size.height-42)+10;
    }
    else
    {
        return 160+10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSFNewDTCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    TSFDTModel * model=_dongtaiArr[indexPath.row];
    cell.label1.text=model.title;
    cell.label2.text=model.descrip;
    cell.label3.text=model.biaoqian;
    return cell;
}

- (void)pop:(UIButton *)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
