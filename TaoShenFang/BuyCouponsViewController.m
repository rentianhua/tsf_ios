//
//  BuyCouponsViewController.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/26.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "BuyCouponsViewController.h"
#import "BuyCouponsCell.h"
#import "BuyCouponsPhoneCell.h"
#import "CouponsDetailCell.h"
#import "OtherHeader.h"
#import "MainSectionView.h"
#import "PayCouponsViewController.h"
@interface BuyCouponsViewController ()<UITableViewDelegate,UITableViewDataSource>

@end


@implementation BuyCouponsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"抢购优惠券";
    
    [self createTableview];
}

/**tableview的创建*/
- (void)createTableview
{
    UITableView * tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-40) style:UITableViewStyleGrouped];
    tableview.delegate=self;
    tableview.dataSource=self;
    [self.view addSubview:tableview];
    [tableview registerClass:[BuyCouponsCell class] forCellReuseIdentifier:@"cell0"];
    [tableview registerClass:[BuyCouponsPhoneCell class] forCellReuseIdentifier:@"cell1"];
    [tableview registerClass:[CouponsDetailCell class] forCellReuseIdentifier:@"cell2"];
    [tableview registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    [tableview registerClass:[MainSectionView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
    
    UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(0, kMainScreenHeight-40, kMainScreenWidth, 40)];
    button.backgroundColor=[UIColor redColor];
    [button setTitle:@"立即购买" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark----UITableviewDelegate----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    

    if (section==0) {
        return 0.01;
    } else if (section==1){
        return 0.01;
    } else{
        return 40;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    if (section==0) {
        return 10;
    } else if (section==1){
        return 40;
    } else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 100;
            break;
        case 1:
            return 50;
            break;
        case 2:
            return 150;
            break;
            
        default:
            return 0;
            break;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * footer=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    
    if (section==1) {
        footer.textLabel.textColor=[UIColor blackColor];
        footer.textLabel.text=@"淘深房承诺不会以任何形式泄露您的个人信息";
        footer.textLabel.textAlignment=NSTextAlignmentCenter;
        footer.textLabel.font=[UIFont systemFontOfSize:16];
    }
    return footer;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MainSectionView * header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (section==2) {
        header.contentView.backgroundColor=[UIColor whiteColor];
        header.leftLabel.text=@"可享受以下优惠";
        [header.leftLabel setFont:[UIFont systemFontOfSize:16]];
        }
    return header;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    switch (indexPath.section) {
        case 0:
        {
            BuyCouponsCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell0"];
            return cell;
        }
           
            break;
        case 1:
        {
            NSArray * arr=@[@"手机号",@"验证码"];
            NSArray * placeHolderArr=@[@"请填手机号",@"请输入验证码"];
            BuyCouponsPhoneCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
            cell.label.text=arr[indexPath.row];
            cell.textField.placeholder=placeHolderArr[indexPath.row];
            
            if (indexPath.row==1) {
            cell.textField.rightViewMode=UITextFieldViewModeNever;
            }

            return cell;
        }

            break;
        case 2:
        {
            CouponsDetailCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
            return cell;
        }

            break;
            
        default:
            return nil;
            break;
    }
}

/**点击立即购买*/
- (void)pay
{
    PayCouponsViewController * vc=[[PayCouponsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
