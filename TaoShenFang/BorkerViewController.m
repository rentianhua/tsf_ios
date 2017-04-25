//
//  BorkerViewController.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/23.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "BorkerViewController.h"
#import "MessageViewController.h"
#import "TSFMessageDetailVC.h"
#import "TSFAgentVC.h"
#import "BokerSectionView.h"
#import "OtherHeader.h"
#import "TSFAgentCell.h"
#import "ZYWHttpEngine.h"
#import "BorkerModel.h"
#import "UserModel.h"
#import "UserInfoModel.h"
#import "MJExtension.h"
#import "YJProgressHUD.h"
#import "MJRefresh.h"
#import <UIImageView+WebCache.h>

#import "TSFAgentSecView.h"
#import "TSFAgentSearchModel.h"
#import "TSFAgentSearchVC.h"

#import "LoginViewController.h"

#define NAVBTNW 20
@interface  BorkerViewController()<UITableViewDelegate,UITableViewDataSource>

/**表头*/
@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;

//导航条上的按钮
@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UIButton * rightNavBtn;
@property (nonatomic,strong)UIImageView * BGView;

@property (nonatomic,strong)TSFAgentSearchModel * searchmodel;
@property (nonatomic,copy)NSString *kws;
@property (nonatomic,copy) NSString *sortStr;
@end

@implementation BorkerViewController

- (NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

- (UIImageView *)BGView{
    if (_BGView==nil) {
        _BGView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _BGView.image=[UIImage imageNamed:@"offline_bg_01"];
        _BGView.userInteractionEnabled=YES;
        UITapGestureRecognizer * recongnizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(offlineAction:)];
        recongnizer.numberOfTapsRequired=1;
        [_BGView addGestureRecognizer:recongnizer];
        
    }
    return _BGView;
}

- (TSFAgentSearchModel *)searchmodel{
    if (_searchmodel==nil) {
        _searchmodel=[[TSFAgentSearchModel alloc]init];
    }
    return _searchmodel;
}
- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

- (UIButton *)rightNavBtn{
    if (_rightNavBtn==nil) {
        _rightNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_rightNavBtn setImage:[UIImage imageNamed:@"btn_chat_new"] forState:UIControlStateNormal];
        [_rightNavBtn addTarget:self action:@selector(toMessageVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNavBtn;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn];
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)toMessageVC{
    if (NSUSER_DEF(USERINFO)==nil) {
        LoginViewController * VC=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:VC];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    MessageViewController * vc=[[MessageViewController alloc]init];
    vc.type = MessageTypeBack;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWithHeaderView];
    self.navigationItem.title=@"经纪人";
    
    [self.view addSubview:self.BGView];
    self.BGView.hidden=YES;
    
    [self initWithTableView];
    
    [self loadData];
    
}


- (void)loadData{
    
    self.searchmodel.catid=@52;
    
    __weak typeof(self)weakSelf=self;
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    
    NSDictionary * param=[self.searchmodel mj_keyValues];
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=Api&m=user&a=jjrlist",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        weakSelf.tableView.hidden=NO;
        weakSelf.BGView.hidden=YES;
        if (responseObj)
        {
            //_array3=[NSArray arrayWithObjects:@"成交量从高到低",@"好评率从高到低",@"带看量从高到低", nil];
            NSArray *lt =[BorkerModel mj_objectArrayWithKeyValuesArray:responseObj];
            if([lt count]>0)
            {
                NSMutableArray *sortlt = [NSMutableArray arrayWithArray:lt];
                
                NSString *sortKey = nil;
                if([self.sortStr isEqualToString:@"成交量从高到低"])
                {
                    sortKey = @"_chengjiao_count";
                }
                if([self.sortStr isEqualToString:@"好评率从高到低"])
                {
                    sortKey = @"_fb_rate";
                }
                if([self.sortStr isEqualToString:@"带看量从高到低"])
                {
                    sortKey = @"_daikan_count";
                }
                
                if(sortKey != nil)
                {
                    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:NO];
                    NSArray *tempArray = [sortlt sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                    weakSelf.dataArray = [NSMutableArray arrayWithArray:tempArray];
                }
                else
                {
                    weakSelf.dataArray = sortlt;
                }
            }
            else
            {
                [weakSelf.dataArray removeAllObjects];
                [YJProgressHUD showMessage:@"找不到符合条件的经纪人" inView:weakSelf.view];
            }
        }
        else
        {
            [weakSelf.dataArray removeAllObjects];
            [YJProgressHUD showMessage:@"找不到符合条件的经纪人" inView:weakSelf.view];
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
        weakSelf.tableView.hidden=YES;
        weakSelf.BGView.hidden=NO;
    }];
}

/**表头的创建*/
- (void)initWithHeaderView
{
    _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    _headerView.backgroundColor=OtherNavBarColor;
    
    
    UIButton * searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(30, 10, kMainScreenWidth-60, 40)];
    searchBtn.layer.masksToBounds=YES;
    searchBtn.layer.cornerRadius=3;
    searchBtn.backgroundColor=[UIColor whiteColor];
    [searchBtn setImage:[UIImage imageNamed:@"homepage_search_icon"] forState:UIControlStateNormal];
    [searchBtn setTitle:@"  请输入经纪人的姓名" forState:UIControlStateNormal];
    [searchBtn setTitleColor:RGB(173, 173, 173, 1.0) forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    searchBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    searchBtn.contentEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:searchBtn];
    
}

//去搜索
- (void)searchAction:(UIButton *)button{
    TSFAgentSearchVC * vc=[[TSFAgentSearchVC alloc]init];
    vc.house_type=@"new";
    __weak typeof(self)weakSelf=self;
    
    vc.kwdsBlock=^(NSString * kwds){
        weakSelf.searchmodel.kw=kwds;
        
        [weakSelf loadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

/**表的创建*/
- (void)initWithTableView
{
    UITableView * tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    tableview.delegate=self;
    tableview.dataSource=self;
    [self.view addSubview:tableview];
    self.tableView=tableview;
    tableview.tableHeaderView=_headerView;
    [tableview registerNib:[UINib nibWithNibName:@"TSFAgentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
    tableview.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
}

#pragma mark----UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TSFAgentSecView * header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!header) {
        header=[[TSFAgentSecView alloc]initWithReuseIdentifier:@"header"];
    }
    
    __weak typeof(self)weakSelf=self;
    header.secBlock=^(int index, NSString * string1,NSString * string2,NSString * string3){
        [weakSelf.tableView setContentOffset:CGPointMake(0, 60) animated:YES];
        
        //区域
        if(index == 1)
        {
            if (string1!=nil)
            {
                if ([string1 isEqualToString:@"不限"])
                {
                    weakSelf.searchmodel.ct=nil;
                }
                else
                {
                    weakSelf.searchmodel.ct=string1;
                }
            }
            else
            {
                weakSelf.searchmodel.ct=nil;
            }
        }

        //筛选
        if(index == 2)
        {
            if (string2!=nil)
            {
                weakSelf.searchmodel.bq=string2;
            }
            else
            {
                weakSelf.searchmodel.bq = nil;
            }
        }

        //排序
        if(index == 3)
        {
            self.sortStr = string3;
        }
        
        [weakSelf loadData];
    };
    
    return header;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count==0) {
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    } else{
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSFAgentCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.imgView.layer.masksToBounds=YES;
    cell.imgView.layer.cornerRadius=40;
    
    
    BorkerModel * model=self.dataArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.info.userpic] placeholderImage:[UIImage imageNamed:@"img_no_agent"]];
    NSString * dengji=nil;
    if ([model.dengji isEqualToString:@"1"]) {
        dengji=@"普通经纪人";
    } else if ([model.dengji isEqualToString:@"2"]){
        dengji=@"优秀经纪人";
    }
    else if ([model.dengji isEqualToString:@"2"]){
        dengji=@"高级经纪人";
    } else{
        dengji=@"资深经纪人";
    }
    
    NSString * str1=[NSString stringWithFormat:@"%@ %@",model.realname,dengji];
    NSRange range=[str1 rangeOfString:dengji];
    NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:str1];
    [attrStr setAttributes:@{NSForegroundColorAttributeName:RGB(237, 27, 36, 1.0),NSFontAttributeName:[UIFont systemFontOfSize:14]} range:range];
    
    [cell.label1 setAttributedText:attrStr];
    cell.label2.text=[NSString stringWithFormat:@"%@",model.mainarea];
    NSString * str3=[NSString stringWithFormat:@"好评率:%@%% 评论:%@条", model.fb_rate, model.comm_count];
    NSRange range1=[str3 rangeOfString:[NSString stringWithFormat:@"%@%%", model.fb_rate]];
    NSRange range2=[str3 rangeOfString:[NSString stringWithFormat:@"%@条", model.comm_count]];
    NSMutableAttributedString * attr3=[[NSMutableAttributedString alloc]initWithString:str3];
    [attr3 addAttribute:NSForegroundColorAttributeName value:RGB(237, 27, 36, 1.0) range:range1];
    [attr3 addAttribute:NSForegroundColorAttributeName value:RGB(237, 27, 36, 1.0) range:range2];
    [cell.label3 setAttributedText:attr3];
    cell.biaoqian=model.biaoqian;
    
    cell.phoneBtn.tag=indexPath.row;
    [cell.phoneBtn addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.messageBtn.tag=indexPath.row;
    [cell.messageBtn addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BorkerModel * model=self.dataArray[indexPath.row];
    
    TSFAgentVC * vc=[[TSFAgentVC alloc]init];
    vc.userid=model.userid;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messageAction:(UIButton *)button{
    if (NSUSER_DEF(USERINFO)==nil) {
        LoginViewController * VC=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:VC];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    BorkerModel * model=self.dataArray[button.tag];
    NSNumber * userid=[NSNumber numberWithInteger:[NSUSER_DEF(USERINFO)[@"userid"] integerValue]];
    if ([model.userid isEqualToNumber:userid]) {
        [YJProgressHUD showMessage:@"亲，不能给自己留言" inView:self.view];
        return;
    }
    
    TSFMessageDetailVC * VC=[[TSFMessageDetailVC alloc]init];
    VC.towho=[NSString stringWithFormat:@"%@",model.userid];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)phoneAction:(UIButton *)button{
    BorkerModel * model=self.dataArray[button.tag];
    NSMutableString * str=[[NSMutableString alloc]initWithFormat:@"tel:%@",model.info.ctel];
    UIWebView * callWebView=[[UIWebView alloc]init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebView];
    
}

//无网络
- (void)offlineAction:(UITapGestureRecognizer *)recongnizer{
    [self loadData];
}

@end
