//
//  MyViewController.m
//  Framework
//
//  Created by lvtingyang on 16/2/22.
//  Copyright © 2016年 Framework. All rights reserved.
//

#import "MyViewController.h"
#import <Masonry.h>
#import "UserModel.h"
#import "PersonalController.h"
#import "OtherHeader.h"
#import "SetupController.h"
#import "LoginViewController.h"
#import "SetupController.h"
#import "ZYWHttpEngine.h"
#import "UserModel.h"
#import "MJExtension.h"
#import "UIButton+WebCache.h"
#import "ApplyPhoneVC.h"
#import "TSFEntrustListVC.h"

#import "MyHandVC.h"//我的二手房
#import "MyRentVC.h"//我的出租
#import "MyAttentionVC.h"
#import "AppointVC.h"
#import "TSFSuccessHouseVC.h"
#import "TSFOrderVC.h"//勾地订单
#import "TSFMyCouponsVC.h"//我的优惠券
#import "TSFRecordVC.h"//历史记录
#import "TSFRentManageVC.h"//求租管理
#import "TSFBuyManagerVC.h"//求购管理
#import "TSFUserRentVC.h"//我要租房
#import "TSFUserBuyVC.h"//我要买房

#define IMGHEIGHT kMainScreenWidth*0.6

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray * rowTitleArr;
@property (nonatomic,strong)UIButton * headButton;
@property (nonatomic,strong)UIButton * nickName;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UserModel * model;
@property (nonatomic,strong)UIView * topView;

@property (nonatomic,strong)NSArray * offLineArray;//未登录
@property (nonatomic,strong)NSArray * userArray;//用户
@property (nonatomic,strong)NSArray * borkerArray;//经纪人

@property (nonatomic,strong)NSArray * offLineImgArr;//未登录
@property (nonatomic,strong)NSArray * userImgArr;//用户
@property (nonatomic,strong)NSArray * borkerImgArr;//经纪人
@property (nonatomic,strong)NSArray * imgArr;


@end

@implementation MyViewController

- (NSArray *)offLineImgArr{
    if (_offLineImgArr==nil) {
        _offLineImgArr=[NSArray arrayWithObjects:@"maifang_01",@"chuzu_01",@"weituo_01",@"guanzhu_01",@"youhui_01",@"lishi_01", nil];
    }
    return _offLineImgArr;
}

- (NSArray *)userImgArr{
    if (_userImgArr==nil) {
        _userImgArr=[NSArray arrayWithObjects:@"guanzhu_01",@"maifang_01",@"chuzu_01",@"qiuzu_01",@"maifang_10",@"youhui_01",@"goudi_01",@"lishi_01", nil];
    }
    return _userImgArr;
}
- (NSArray *)borkerImgArr{
    if (_borkerImgArr==nil) {
        _borkerImgArr=[NSArray arrayWithObjects:@"maifang_01",@"chuzu_01",@"chengjiao_01",@"qiuzu_01",@"maifang_10",@"entrustlist_01",@"goudi_01",@"youhui_01",@"lishi_01", nil];
    }
    return _borkerImgArr;
}


- (UIView *)topView{
    if (_topView==nil) {
        _topView=[[UIView alloc]initWithFrame:CGRectMake(0, -IMGHEIGHT, kMainScreenWidth, IMGHEIGHT)];
        
        UIImageView * imgView=[UIImageView new];
        imgView.image=[UIImage imageNamed:@"myvc_01"];
        imgView.userInteractionEnabled=YES;
        [_topView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.and.bottom.mas_equalTo(0);
        }];
        UIButton * button=[UIButton new];
       
        [button setImage:[UIImage imageNamed:@"myhome_icon_avatar"] forState:UIControlStateNormal];
       
        [imgView addSubview:button];
        self.headButton=button;
        [button addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_topView.mas_centerX);
            make.centerY.equalTo(_topView.mas_centerY);
            make.width.mas_offset(60);
            make.height.mas_offset(60);
        }];
        
        button.layer.cornerRadius=30;
        button.layer.masksToBounds=YES;
        
        UIButton * login=[UIButton new];
        [login setTitle:@"登录/注册" forState:UIControlStateNormal];
        
        [login.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [imgView addSubview:login];
        [login addTarget:self action:@selector(nickClick:) forControlEvents:UIControlEventTouchUpInside];
        self.nickName=login;
        [login mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_topView.mas_centerX);
            make.width.mas_equalTo(150);
            make.top.equalTo(button.mas_bottom).offset(10);
            make.height.mas_equalTo(30);
        }];
    }
    return _topView;
}
- (NSArray *)offLineArray{
    if (_offLineArray==nil) {
        _offLineArray=@[@"我的二手房",@"我的出租",@"我的委托",@"我的关注",@"我的优惠券",@"历史记录"];
    }
    return _offLineArray;
}

- (NSArray * )userArray{
    if (_userArray==nil) {
        _userArray=@[@"我的关注",@"我要卖房",@"我要出租",@"我要租房",@"我要买房",@"我的优惠券",@"勾地订单",@"历史记录"];
    }
    return _userArray;
}

- (NSArray *)borkerArray{
    if (_borkerArray==nil) {
        _borkerArray=@[@"二手房管理",@"出租房管理",@"成交房源",@"求租管理",@"求购管理",@"委托管理",@"勾地订单",@"我的优惠券",@"历史记录"];
    }
    return _borkerArray;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    
    if (NSUSER_DEF(USERINFO)) {
        if ([NSUSER_DEF(USERINFO)[@"modelid"] isEqualToString:@"35"]) {
            _rowTitleArr=self.userArray;//普通用户
            _imgArr=self.userImgArr;
        } else{
            _rowTitleArr=self.borkerArray;//经纪人
            _imgArr=self.borkerImgArr;
        }
    } else{
        _rowTitleArr=self.offLineArray;//未登录
        _imgArr=self.offLineImgArr;
    }
    [self initWithTableView];

    [self loadData];
    
}

- (void)loadData{
    __weak typeof(self)weakSelf=self;
    NSDictionary * dict=NSUSER_DEF(USERINFO);//取出个人id
    if (dict==nil) {
        [self.headButton setImage:[UIImage imageNamed:@"myhome_icon_avatar"] forState:UIControlStateNormal];
        [self.nickName setTitle:@"登录/注册" forState:UIControlStateNormal];
        return;
    } else{
        NSString * urlStr=[NSString stringWithFormat:@"%@g=Member&m=Public&a=api_getuserinfo",URLSTR];
        NSDictionary * params=@{@"userid":dict[@"userid"]};
        
        [ZYWHttpEngine AllPostURL:urlStr params:params success:^(id responseObj) {
            if (responseObj) {
                UserModel * model=[UserModel mj_objectWithKeyValues:responseObj];
                weakSelf.model=model;
            [weakSelf.headButton sd_setImageWithURL:[NSURL URLWithString:model.userpic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"myhome_icon_avatar"]];
                
                if (model.info.realname.length!=0) {
                    [weakSelf.nickName setTitle:model.info.realname forState:UIControlStateNormal];
                } else{
                    [weakSelf.nickName setTitle:model.username forState:UIControlStateNormal];
                }
                
            }
          
        } failure:^(NSError *error) {
            if (NSUSER_DEF(USERINFO)!=nil) {
                [weakSelf.nickName setTitle:NSUSER_DEF(USERINFO)[@"username"] forState:UIControlStateNormal];
            }
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置导航条的背景图片
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.extendedLayoutIncludesOpaqueBars=YES;
    //设置导航条的背景图片
    UIImage *image=[UIImage imageNamed:@"navbarimg"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

    
    
    
    
}
- (void)initWithTableView
{
    
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.contentInset=UIEdgeInsetsMake(IMGHEIGHT, 0, 0, 0);
    [self.view addSubview:tableView];
    self.tableView=tableView;
    
   [self.tableView addSubview:self.topView];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
      return [_rowTitleArr count];
    } else{
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text=_rowTitleArr[indexPath.row];
            [cell.imageView setImage:[UIImage imageNamed:self.imgArr[indexPath.row]]];
            break;
        default:
            cell.textLabel.text=@"设置";
            [cell.imageView setImage:[UIImage imageNamed:@"setting_01"]];
            break;
    }
    
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (NSUSER_DEF(USERINFO)==nil) {//未登录
        //跳出登录界面
        LoginViewController * vc=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }  else{//已经登录----》判断登录的是普通用户/经纪人
    
        if (indexPath.section==0) {//0区
            if ([_model.modelid isEqualToString:@"35"]) {//普通用户
                switch (indexPath.row) {
                        
                    case 0:{//我的关注
                        MyAttentionVC * vc=[[MyAttentionVC alloc]init];
                        [self push:vc];
                    }
                        break;
                    case 1:{//我的二手房-----》我要卖房
                        MyHandVC * vc=[[MyHandVC alloc]init];
                        //vc.model=_model;
                        [self push:vc];
                    }
                        break;
                    case 2:{//我的出租房
                        MyRentVC * vc=[[MyRentVC alloc]init];
                        vc.model=_model;

                        [self push:vc];
                    }
                        break;
                        
                    case 3:{
                        TSFUserRentVC * vc=[[TSFUserRentVC alloc]init];
                        vc.navigationItem.title=@"我要租房";
                        [self push:vc];
                    }
                        break;
                        
                    case 4:{
                        TSFUserBuyVC * vc=[[TSFUserBuyVC alloc]init];
                        vc.navigationItem.title=@"我要买房";
                        [self push:vc];
                    }
                        
                        break;
                    
                    
                    case 5:{//我的优惠券
                        TSFMyCouponsVC * VC=[[TSFMyCouponsVC alloc]init];
                        [self push:VC];
                    }
                        break;
                    case 6:{//勾地订单
                        TSFOrderVC * VC=[[TSFOrderVC alloc]init];
                        [self push:VC];
                    }
                        break;
                    default:{//历史记录
                        TSFRecordVC * VC=[[TSFRecordVC alloc]init];
                        [self push:VC];
                    }
                        break;
                }

            } else{
                //经纪人
                switch (indexPath.row) {
                    
                    case 1:{//出租房管理
                        MyRentVC * vc=[[MyRentVC alloc]init];
                        vc.navigationItem.title=@"出租房管理";
                        vc.model=_model;
                        [self push:vc];
                    }
                        break;
                        
                    case 0:{//二手房管理
                        MyHandVC * vc=[[MyHandVC alloc]init];
                        vc.navigationItem.title=@"二手房管理";
                        //vc.model=_model;
                        [self push:vc];
                    }
                        break;
                    case 2:{//成交房源
                        TSFSuccessHouseVC * VC=[[TSFSuccessHouseVC alloc]init];
                        [self push:VC];
                    }
                        break;
                    case 3:{//求租管理
                        TSFRentManageVC * vc=[[TSFRentManageVC alloc]init];
                        vc.navigationItem.title=@"求租管理";
                        [self push:vc];
                    }
                        break;
                     
                    case 4:{//求购管理
                        TSFBuyManagerVC * vc=[[TSFBuyManagerVC alloc]init];
                        vc.navigationItem.title=@"求购管理";
                        [self push:vc];
                    }
                        break;
                    case 5:{//委托管理
                        TSFEntrustListVC * VC=[[TSFEntrustListVC alloc]init];
                        [self push:VC];
                    }
                        break;
                    case 6:{//勾地订单
                        TSFOrderVC * VC=[[TSFOrderVC alloc]init];
                        [self push:VC];
                    }
                        break;
                    case 7:{//我的优惠券
                        TSFMyCouponsVC * VC=[[TSFMyCouponsVC alloc]init];
                        [self push:VC];
                    }
                        break;
                    default:{//历史记录
                        TSFRecordVC * VC=[[TSFRecordVC alloc]init];
                        [self push:VC];
                    }
                        break;
                        
                }
 
            }
        } else{//1区、 设置
            SetupController * vc=[[SetupController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
        
}

//登录按钮点击
- (void)nickClick:(UIButton *)button
{
    if (NSUSER_DEF(USERINFO)==nil) {
        LoginViewController * vc=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:vc];
        vc.hidesBottomBarWhenPushed=YES;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

//提出来的push操作 传VC
- (void)push:(UIViewController *)vc{
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}


//头像按钮点击
- (void)headButtonClick:(UIButton *)button
{
    if (NSUSER_DEF(USERINFO)!=nil) {
        PersonalController * vc=[[PersonalController alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        vc.userid=NSUSER_DEF(USERINFO)[@"userid"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   }


@end
