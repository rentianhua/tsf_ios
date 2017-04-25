//
//  MessageViewController.m
//  Framework
//
//  Created by lvtingyang on 16/2/22.
//  Copyright © 2016年 Framework. All rights reserved.
//

#import "MessageViewController.h"
#import "RegisteViewController.h"
#import "ForgetPswController.h"
#import "OtherHeader.h"
#import "LoginViewController.h"
#import "TSFMessageDetailVC.h"

#import "TSFMessageCell.h"

#import "ZYWHttpEngine.h"
#import "YJProgressHUD.h"

#import "Chat_Model.h"
#import <MJExtension.h>
#import <UIButton+WebCache.h>
@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)UIImageView * bgImgView;
/**button下的线条*/
@property (nonatomic,strong)UIView * lineView;

/**button下的线条*/
@property (nonatomic,assign)int lastButtonTag;

//导航条
@property (nonatomic,strong)UILabel * titleLabel;


@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * dataArray;

@property (nonatomic,strong)dispatch_source_t timer1;

@end

@implementation MessageViewController

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-44) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:@"TSFMessageCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        
    }
    return _tableView;
}
- (UILabel *)titleLabel{
    if (_titleLabel==nil) {
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 21)];
        _titleLabel.font=[UIFont systemFontOfSize:16 weight:16];
        _titleLabel.textColor=[UIColor blackColor];
        _titleLabel.text=@"消息";
        _titleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.titleView=self.titleLabel;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(messageS:) name:@"formessage" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithBgImageView];
    
    //设置导航条的背景图片
    UIImage *image=[UIImage imageNamed:@"navbarimg"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self.view addSubview:self.tableView];
   
    
    switch (self.type) {
        case MessageTypeBack:{
            
            UIButton *leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
            [leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
            [leftNavBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftNavBtn];
        }
            break;
            
        default:
            break;
    }
 
    [self loadData];
}

- (void)messageS:(NSNotification *)noti{
    NSDictionary * dict=noti.userInfo;
    NSArray * dataArr=dict[@"message"];
    self.dataArray=dataArr;
    
    if (self.dataArray.count>0) {
        self.tableView.hidden=NO;
        self.bgImgView.hidden=YES;
        [self.tableView reloadData];
    }else{
        self.tableView.hidden=YES;
        self.bgImgView.hidden=NO;
    }
    
}
- (void)loadData{
    if (NSUSER_DEF(USERINFO)==nil) {
        return;
    }
    NSDictionary * param=@{@"userid":NSUSER_DEF(USERINFO)[@"userid"]};
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    __weak typeof(self)weakSelf=self;
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=liuyan_list",URLSTR] params:param success:^(id responseObj) {
        
        [YJProgressHUD hide];
        if (responseObj) {

            NSArray * array=[responseObj allValues];
//            Chat_Model * xtmodel=nil;
//            for (int i=0; i<arrayM.count; i++) {
//                Chat_Model * model=arrayM[i];
//                if ([model.from_uid isEqualToString:@"0"]) {
//                    xtmodel=model;
//                    [arrayM removeObject:model];
//                }
//            }
            if(array.count>0)
            {
                NSMutableArray * resultArray=[[NSMutableArray alloc] initWithArray:[Chat_Model mj_objectArrayWithKeyValuesArray:array]];
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"_inputtime" ascending:NO];
                NSArray *tempArray = [resultArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                weakSelf.dataArray=tempArray;
            }
            if (weakSelf.dataArray.count>0) {
                weakSelf.tableView.hidden=NO;
                weakSelf.bgImgView.hidden=YES;
            } else{
                weakSelf.tableView.hidden=YES;
                weakSelf.bgImgView.hidden=NO;
            }
            
            [weakSelf.tableView reloadData];
        } else{
            weakSelf.tableView.hidden=YES;
            weakSelf.bgImgView.hidden=NO;
        }
        
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
    }];
}

- (void)initWithBgImageView{
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-44)];
    [imageView setImage:[UIImage imageNamed:@"message_no_01"]];
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled=YES;
    imageView.backgroundColor=[UIColor redColor];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, kMainScreenHeight*0.6, kMainScreenWidth, 21)];
    label.text=@"消息列表为空";
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:14];
    [imageView addSubview:label];
    
    UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), kMainScreenWidth, 21)];
    label1.text=@"勾搭几个经纪人或关注小区&房源吧";
    label1.textColor=[UIColor grayColor];
    label1.textAlignment=NSTextAlignmentCenter;
    label1.font=[UIFont systemFontOfSize:12];
    [imageView addSubview:label1];
    
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadMessage:)];
    tap.numberOfTouchesRequired=1;
    [imageView addGestureRecognizer:tap];
}

//imageView单击手势 重新加载数据
- (void)reloadMessage:(UITapGestureRecognizer *)sender{
    
}


- (void)buttonClick
{
    LoginViewController * vc=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**返回*/
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSFMessageCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Chat_Model * model=self.dataArray[indexPath.row];
    if ([model.from_uid isEqualToString:@"0"]) {
        cell.label.text=@"系统消息";
        [cell.button setImage:[UIImage imageNamed:@"message_xt"] forState:UIControlStateNormal];
    } else{
        cell.label.text=model.realname;
        [cell.button sd_setImageWithURL:[NSURL URLWithString:model.userpic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"myhome_icon_avatar"]];
    }
    
    cell.decripLabel.text=model.content;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.inputtime integerValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    cell.timeLabel.text=confromTimespStr;
    if ([model.yidu isEqual:@0]) {
        cell.numLab.hidden=NO;
        cell.numLab.text=@"未读";
    } else{
        cell.numLab.hidden=YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Chat_Model * model= self.dataArray[indexPath.row];
    //liuyan_yidu
    
    NSDictionary  * param=@{ @"id":model.ID,
                             @"userid":NSUSER_DEF(USERINFO)[@"userid"]};
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=liuyan_yidu",URLSTR] params:param success:^(id responseObj) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
    TSFMessageDetailVC * VC=[[TSFMessageDetailVC alloc]init];
    if ([model.from_uid isEqualToString:NSUSER_DEF(USERINFO)[@"userid"] ]) {
       VC.towho=model.to_uid;
    } else{
       VC.towho=model.from_uid;
    }
    
    VC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:VC animated:YES];
    
}

//https://www.taoshenfang.com/index.php?g=api&m=user&a=liuyan_del
//按钮显示的内容
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
    
}
//这里就是点击删除执行的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self)weakSelf=self;
    
        Chat_Model * model=self.dataArray[indexPath.row];
        NSDictionary * param=@{
                               @"id":model.ID,
                               @"userid":NSUSER_DEF(USERINFO)[@"userid"]
                    
                               };
        [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=liuyan_del",URLSTR] params:param success:^(id responseObj) {
            [YJProgressHUD hide];
            if (responseObj) {
                
                if ([responseObj[@"success"] isEqual:@195]) {//
                    [weakSelf loadData];
                }
            }
            
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
        }];
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"formessage" object:nil];
    
    
}

@end
