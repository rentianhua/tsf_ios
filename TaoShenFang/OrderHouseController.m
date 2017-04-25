//
//  OrderHouseController.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/28.
//  Copyright © 2016年 qkq. All rights reserved.
//待看清单

#import "OrderHouseController.h"
#import "OtherHeader.h"
#import "TSFMapButton.h"
#import "LoginViewController.h"
#import "HandRoomViewController.h"
#define TOPVIEWH 120
#define IMGVIEWH 128
#define TIPVIEWH 228
@interface OrderHouseController ()
@property (nonatomic,strong)UIView * navgationBar;
@property (nonatomic,strong)UIView * recordView;
@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)UIView * explainView;//底部的view
@property (nonatomic,strong)TSFMapButton * button1;//挑选房源
@property (nonatomic,strong)TSFMapButton * button2;//预约时间
@property (nonatomic,strong)TSFMapButton * button3;//提交成功

@end

@implementation OrderHouseController


- (UIView *)explainView{
    if (_explainView==nil) {
        _explainView=[[UIView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight-80, kMainScreenWidth, 80)];
        UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 21)];
        label1.text=@"------------什么是带看清单------------";
        label1.textAlignment=NSTextAlignmentCenter;
        label1.textColor=[UIColor grayColor];
        label1.font=[UIFont boldSystemFontOfSize:14];
        [_explainView addSubview:label1];
        
        UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame)+10, kMainScreenWidth, 21)];
        label2.text=@"把你感兴趣的房子加入到预约看房清单后,房子就会出现在这里";
        label2.textAlignment=NSTextAlignmentCenter;
        label2.textColor=[UIColor grayColor];
        label2.font=[UIFont systemFontOfSize:12];
        [_explainView addSubview:label2];
    }
    return _explainView;
}
- (TSFMapButton *)button1{
    if (_button1==nil) {
        _button1 =[[TSFMapButton alloc]initWithFrame:CGRectMake(30, (TOPVIEWH-60)*0.5, 60, 60)];
        [_button1 setImage:[UIImage imageNamed:@"room_01"] forState:UIControlStateNormal];
        [_button1 setTitle:@"挑选房源" forState:UIControlStateNormal];
        [_button1.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _button1;
}
- (TSFMapButton *)button2{
    if (_button2==nil) {
        CGFloat margin=(kMainScreenWidth-30*2-60*3)*0.5;
        _button2 =[[TSFMapButton alloc]initWithFrame:CGRectMake(30+60+margin, (TOPVIEWH-60)*0.5, 60, 60)];
        [_button2 setImage:[UIImage imageNamed:@"dian_01"] forState:UIControlStateNormal];
        [_button2 setTitle:@"预约时间" forState:UIControlStateNormal];
        [_button2.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _button2.alpha=0.8;
    }
    return _button2;
}
- (TSFMapButton *)button3{
    if (_button3==nil) {
        CGFloat margin=(kMainScreenWidth-30*2-60*3)*0.5;
        _button3 =[[TSFMapButton alloc]initWithFrame:CGRectMake((60+margin)*2+30, (TOPVIEWH-60)*0.5, 60, 60)];
        [_button3 setImage:[UIImage imageNamed:@"dian_01"] forState:UIControlStateNormal];
        [_button3 setTitle:@"提交成功" forState:UIControlStateNormal];
        [_button3.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _button3.alpha=0.8;
    }
    return _button3;
}
- (UIView *)topView{
    if (_topView==nil) {
        _topView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, TOPVIEWH)];
        _topView.backgroundColor=NavBarColor;
        [_topView addSubview:self.button1];
        [_topView addSubview:self.button2];
        [_topView addSubview:self.button3];
    }
    return _topView;
}
- (UIView *)navgationBar{
    if (_navgationBar==nil) {
        _navgationBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64)];
        _navgationBar.backgroundColor=NavBarColor;

        UILabel * title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 21)];
        title.center=CGPointMake(_navgationBar.center.x, _navgationBar.center.y+10);
        title.text=@"待看清单";
        title.textAlignment=NSTextAlignmentCenter;
        title.textColor=[UIColor whiteColor];
        title.font=[UIFont systemFontOfSize:17];
        [_navgationBar addSubview:title];
        UIButton * leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        leftBtn.center=CGPointMake(15+15, _navgationBar.center.y+10);
        [_navgationBar addSubview:leftBtn];
        [leftBtn setImage:[UIImage imageNamed:@"barback_01"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _navgationBar;
}

- (UIView *)recordView{
    if (_recordView==nil) {
        _recordView=[[UIView alloc]initWithFrame:CGRectMake((kMainScreenWidth-IMGVIEWH)*0.5, TOPVIEWH+64+20, IMGVIEWH, TIPVIEWH)];
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, IMGVIEWH, IMGVIEWH)];
        [imageView setImage:[UIImage imageNamed:@"daikan_nodata"]];
        [_recordView addSubview:imageView];
        
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, IMGVIEWH, 21)];
        label.text=@"没有待看的房源";
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont boldSystemFontOfSize:16];
        label.textColor=[UIColor grayColor];
        [_recordView addSubview:label];
        
        UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+10, IMGVIEWH, 40)];
        button.backgroundColor=NavBarColor;
        button.layer.cornerRadius=5;
        button.layer.masksToBounds=YES;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"去选房" forState:UIControlStateNormal];
  
        [_recordView addSubview:button];
        
    }
    return _recordView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navgationBar];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.recordView];
    [self.view addSubview:self.explainView];
}

- (void)back:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
//去选房（只有二手房可以预约）
- (void)buttonClick
{
    HandRoomViewController * vc=[[HandRoomViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reload{
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
