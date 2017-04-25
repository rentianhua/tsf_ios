//
//  PayCouponsViewController.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/27.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "PayCouponsViewController.h"
#import "OtherHeader.h"
#import "PayCouponsCell.h"
@interface PayCouponsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UILabel * headerView;

@end

@implementation PayCouponsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"支付";
    
    [self createHeader];
    [self createTableview];
    
}
/**tableview的创建*/
- (void)createTableview
{
    UITableView * tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64-40) style:UITableViewStylePlain];
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
    tableview.tableHeaderView=_headerView;
    [tableview registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"section"];
    [tableview registerClass:[PayCouponsCell class] forCellReuseIdentifier:@"cell0"];
    
    UIButton * bottomButton=[[UIButton alloc]initWithFrame:CGRectMake(0, kMainScreenHeight-40, kMainScreenWidth,40 )];
    bottomButton.backgroundColor=[UIColor redColor];
    [bottomButton setTitle:@"确认支付¥30,000,00" forState:UIControlStateNormal];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:bottomButton];
    
}

/**表头的创建*/
- (void)createHeader
{
    _headerView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kMainScreenHeight, 50)];
    _headerView.text=@"中海信众创城40平米一房3万抵8万优惠券";
    _headerView.font=[UIFont systemFontOfSize:16];
    _headerView.textColor=[UIColor blackColor];
    
}

#pragma mark----UITableviewDelegate----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    } else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 40;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 80;
    }else{
        return 60;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * sectionView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"section"];
    if (section==0) {
        sectionView.textLabel.text=@"选择支付方式";
        sectionView.textLabel.textColor=[UIColor blackColor];
        [sectionView.textLabel setFont:[UIFont systemFontOfSize:16]];
    }
    
    return sectionView;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        PayCouponsCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        return cell;
    } else{
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        }
        cell.textLabel.text=@"实付金额";
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        cell.textLabel.textColor=[UIColor blackColor];
        
        cell.detailTextLabel.text=@"¥30，000，00";
        cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
        cell.detailTextLabel.textColor=[UIColor redColor];
        cell.detailTextLabel.textAlignment=NSTextAlignmentRight;
        return cell;
    }
}





@end
