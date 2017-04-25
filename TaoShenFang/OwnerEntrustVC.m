//
//  OwnerEntrustVC.m
//  TaoShenFang
//
//  Created by YXM on 16/9/1.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "OwnerEntrustVC.h"
#import "KSAlertView.h"
#import "OtherHeader.h"
#import "LoginViewController.h"
#import "TSFEntrustCell.h"
#import "TSFHandEntrustVC.h"
#import "TSFRentEntrustVC.h"

#define NAVBTNW 20

@interface OwnerEntrustVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIButton * leftNavBtn;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)UIView * footerView;

@property (nonatomic,strong)UIImageView * imgView1;

@property (nonatomic,strong)UIImageView * imgView2;

@end

@implementation OwnerEntrustVC

- (UIImageView *)imgView1{
    if (_imgView1==nil) {
        UIImage * image=[UIImage imageNamed:@"entrust_3"];
        float ratio=image.size.width/image.size.height;
        _imgView1=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, kMainScreenWidth-30, (kMainScreenWidth-30)/ratio)];
        _imgView1.image=image;
    }
    return _imgView1;
}

- (UIImageView *)imgView2{
    if (_imgView2==nil) {
        UIImage * image=[UIImage imageNamed:@"entrust_4"];
        float ratio=image.size.width/image.size.height;
        _imgView2=[[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.imgView1.frame)+10, kMainScreenWidth-30, (kMainScreenWidth-30)/ratio)];
        _imgView2.image=image;
    }
    return _imgView2;
}

- (UIView *)footerView{
    if (_footerView==nil) {
        _footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.imgView1.bounds.size.height+self.imgView2.frame.size.height)];
        _footerView.backgroundColor=UIColorFromRGB(0Xf0eff5);
        [_footerView addSubview:self.imgView1];
        [_footerView addSubview:self.imgView2];
        
    }
    return _footerView;
}

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:@"TSFEntrustCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView=self.footerView;
    }
    return _tableView;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.title=@"业主委托";
    
    [self.view addSubview:self.tableView];
    
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSFEntrustCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor=UIColorFromRGB(0Xf0eff5);
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    if (indexPath.row==0) {
      cell.label1.text=@"二手房委托";
        [cell.imgView setImage:[UIImage imageNamed:@"entrust_1"]];
      cell.label2.text=@"淘深房二手房委托";
    } else{
        cell.label1.text=@"租房委托";
        [cell.imgView setImage:[UIImage imageNamed:@"entrust_2"]];
        cell.label2.text=@"淘深房租房委托";
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        
        if ((NSUSER_DEF(USERINFO)!=nil)) {
            NSString * modelid=NSUSER_DEF(USERINFO)[@"modelid"];
            if ([modelid isEqualToString:@"36"]) {//如果是经纪人----》提示：经纪人不能委托
                [KSAlertView showWithTitle:@"温馨提示" message1:@"经纪人没有委托权限" cancelButton:@"确定"];
                return;
            } else{
                TSFHandEntrustVC * VC=[[TSFHandEntrustVC alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
               
            }
        } else{
            LoginViewController * vc=[[LoginViewController alloc]init];
            UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }

        
    } else{
        
        if ((NSUSER_DEF(USERINFO)!=nil)) {
            NSString * modelid=NSUSER_DEF(USERINFO)[@"modelid"];
            if ([modelid isEqualToString:@"36"]) {//如果是经纪人----》提示：经纪人不能委托
                [KSAlertView showWithTitle:@"温馨提示" message1:@"经纪人没有委托权限" cancelButton:@"确定"];
                return;
                
            } else{
                TSFRentEntrustVC * VC=[[TSFRentEntrustVC alloc]init];
                [self.navigationController pushViewController:VC animated:YES];
            }
        } else{
            LoginViewController * vc=[[LoginViewController alloc]init];
            UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
