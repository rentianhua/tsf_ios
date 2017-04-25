//
//  HomeViewController.m
//  Framework
//
//  Created by lvtingyang on 16/2/22.
//  Copyright © 2016年 Framework. All rights reserved.
//

#import "HomeViewController.h"
#import <Masonry.h>
/**二手房*/
#import "HandRoomViewController.h"
/**宏文件*/
#import "OtherHeader.h"
/**二手市场行情*/
#import "FleaMarketTableCell.h"
/**自定义区头*/
#import "MainSectionView.h"
/**租房界面*/
#import "RentRoomViewController.h"
/**新房*/
#import "NewHouseViewController.h"
/**经纪人*/
#import "BorkerViewController.h"
/**大宗交易*/
#import "BlockTradesViewController.h"
/**购物须知*/
#import "PurchaseNoticeViewController.h"
/**图表*/
#import "ChartViewController.h"
/**业主委托*/
#import "OwnerEntrustVC.h"
/**地图找房*/
#import "MapForRoomViewController.h"
/**购房指南cell*/
#import "RoomsGuideTableCell.h"
/**0区的cell*/
#import "HomeButtonCell.h"

#import "TSFSearchView.h"
#import "HomeInformatiomController.h"

#import "ZYWHttpEngine.h"
#import "MJExtension.h"

#import "TSFAvgModel.h"
#import "InformationModel.h"
#import "TSFHomeTitleModel.h"
#import "IDModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import <SDCycleScrollView.h>

#import "TSFHomeSearchVC.h"

/**顶部背景图片高度*/
#define TopImgHeight kMainScreenHeight*0.32

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MainSectionViewDelegate,HomeButtonCellDelegate>
/**资讯*/
@property (nonatomic,strong)NSArray * infoArray;
/**表*/
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)UIView * header;

@property (nonatomic,strong)UIImageView * imgView;

@property (nonatomic,strong)UIImageView * barImgView;

@property (nonatomic,strong)TSFSearchView * topSearchView;//顶部的搜索框

@property (nonatomic,strong)TSFSearchView * searchView;//背景图上的搜索框

@property (nonatomic,strong)SDCycleScrollView * scrollView;

@property (nonatomic,strong)NSArray * imgArr;

@property (nonatomic,strong)NSArray * titleArr;

@property (nonatomic,strong)UILabel * titleLab;
@property (nonatomic,strong)UILabel * titleLab1;


@property (nonatomic,strong)NSArray * junjiaArray;

@end

@implementation HomeViewController
- (NSArray *)imgArr{
    if (_imgArr==nil) {
        _imgArr=[NSArray arrayWithObjects:@"home_scroll_01",@"home_scroll_02", nil];
    }
    return _imgArr;
}
- (SDCycleScrollView *)scrollView{
    if (_scrollView==nil) {
        _scrollView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth*0.3) imageNamesGroup:self.imgArr];
        _scrollView.autoScrollTimeInterval=3;
        _scrollView.currentPageDotColor=RGB(0, 174, 102, 1.0);
        _scrollView.pageDotColor=RGB(209, 211, 212, 1.0);
    }
    return _scrollView;
}
- (UIView *)header{
    if (_header==nil) {
        _header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, TopImgHeight)];
        UIImageView * imgView=[UIImageView new];
        imgView.image=[UIImage imageNamed:@"home01"];
        imgView.userInteractionEnabled=YES;
        [_header addSubview:imgView];
        self.imgView=imgView;
        _header.backgroundColor=[UIColor whiteColor];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.right.mas_equalTo(0);
            make.height.mas_equalTo(TopImgHeight);
        }];
        
        UILabel * title=[UILabel new];
        title.text=@"聚焦深圳总价300万以下房源";
        title.textAlignment=NSTextAlignmentCenter;
        title.textColor=[UIColor whiteColor];
        title.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
        [imgView addSubview:title];
        _titleLab=title;
        
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(64);
            make.height.mas_equalTo(35);
        }];
        
        UILabel * titleO=[UILabel new];
        titleO.text=@"买房 卖房 找淘深房";
        titleO.textAlignment=NSTextAlignmentCenter;
        titleO.textColor=[UIColor whiteColor];
        titleO.font=[UIFont boldSystemFontOfSize:16];
        [imgView addSubview:titleO];
        _titleLab1=titleO;
        
        [titleO mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(title.mas_bottom).offset(0);
            make.height.mas_equalTo(30);
        }];
        
        TSFSearchView * search=[[TSFSearchView alloc]initWithFrame:CGRectMake(15, TopImgHeight-54, kMainScreenWidth-30, 34)];
        search.backgroundColor=[UIColor whiteColor];
        search.title=@"深圳";
        search.label.textAlignment=NSTextAlignmentCenter;
        search.placeholder=@"请输入小区名/房名/地域名";
        [imgView addSubview:search];
        self.searchView=search;

    }
    return _header;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self loadData];
    if (_tableView.contentOffset.y==0) {
        self.navigationController.navigationBarHidden=YES;
    }
    
}


- (void)loadData{
    
    __weak typeof(self)weakSelf=self;
    /**获取资讯*/
    NSString * url=[NSString stringWithFormat:@"%@g=api&m=house&a=position",URLSTR];
    NSDictionary * param=@{@"posid":@12};
    [ZYWHttpEngine AllPostURL:url params:param success:^(id responseObj) {
        
        weakSelf.infoArray=[InformationModel mj_objectArrayWithKeyValuesArray:responseObj];
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
 
    [ZYWHttpEngine AllGetURL:[NSString stringWithFormat:@"%@g=api&m=house&a=webconfig",URLSTR] params:nil success:^(id responseObj) {
       
        if (responseObj) {
            weakSelf.titleArr=[TSFHomeTitleModel mj_objectArrayWithKeyValuesArray:responseObj];
            
            if (weakSelf.titleArr.count==2) {
                
                
                TSFHomeTitleModel * model=weakSelf.titleArr[0];
                weakSelf.titleLab.text=model.value;
                
                TSFHomeTitleModel * model1=weakSelf.titleArr[1];
                weakSelf.titleLab1.text=model1.value;
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    [ZYWHttpEngine AllGetURL:[NSString stringWithFormat:@"%@g=api&m=house&a=tracy",URLSTR] params:nil success:^(id responseObj) {
        
        if (responseObj) {
            weakSelf.junjiaArray=[TSFAvgModel mj_objectArrayWithKeyValuesArray:responseObj];
            
            [weakSelf.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.extendedLayoutIncludesOpaqueBars=YES;
    self.navigationController.navigationBarHidden=YES;
    //设置导航条的背景图片
    UIImage *image=[UIImage imageNamed:@"navbarimg"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
    
    TSFSearchView * searchView=[[TSFSearchView alloc]initWithFrame:CGRectMake(15, 5, kMainScreenWidth-30, 34)];
    searchView.title=@"深圳";
    searchView.tag=100;
    searchView.placeholder=@"请输入小区名/房名/地域名";
    self.topSearchView=searchView;
    self.navigationItem.titleView=searchView;
    
    __weak typeof(self)weakSelf=self;
    
    _topSearchView.searchBlock=^{//点击搜索框
        
        TSFHomeSearchVC * VC=[[TSFHomeSearchVC alloc]init];
        VC.hidesBottomBarWhenPushed=YES;
        [weakSelf.navigationController pushViewController:VC animated:YES];
        
    };


    
    [self createTableView];
    
   
}

/**表的创建*/
- (void)createTableView
{
    UITableView * tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-49) style:UITableViewStylePlain];
    tableview.dataSource=self;
    tableview.delegate=self;
    [self.view addSubview:tableview];
   
    self.tableView=tableview;
    
    self.tableView.tableHeaderView=self.header;
    
    __weak typeof(self)weakSelf=self;
    
    self.searchView.searchBlock=^{//点击搜索框
        
        TSFHomeSearchVC * VC=[[TSFHomeSearchVC alloc]init];
        VC.hidesBottomBarWhenPushed=YES;
        [weakSelf.navigationController pushViewController:VC animated:YES];
        
    };
    
    [_tableView registerNib:[UINib nibWithNibName:@"FleaMarketTableCell" bundle:nil] forCellReuseIdentifier:@"felaCell"];
    [_tableView registerClass:[RoomsGuideTableCell class] forCellReuseIdentifier:@"guideCell"];
    [_tableView registerClass:[HomeButtonCell class] forCellReuseIdentifier:@"buttonCell"];
    
}


#pragma mark----UITableViewDelegate---


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0 || section==1) {
        return 0;
    } else{
        return 50;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_infoArray.count==0) {
        return 3;
    } else{
        return 4;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==2 || section==3) {
        MainSectionView * header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
        if (!header) {
            header=[[MainSectionView alloc]initWithReuseIdentifier:@"header"];
        }
        header.section=section;
        header.delegate=self;
        header.rightButton.hidden=YES;
        header.leftLabel.font=[UIFont systemFontOfSize:20];
        switch (section) {
            case 2:
                header.leftLabel.text=@"房价行情";
                break;
            case 3:
                header.leftLabel.text=@"购房指南";
                break;
                
            default:
                break;
        }
        return header;
    } else{
        return nil;
    }
    
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==3) {
         return _infoArray.count;
    } else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    if (indexPath.section==0) {
        HomeButtonCell * cell=[tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        cell.delegate=self;
        return cell;
    } if (indexPath.section==1) {
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            [cell addSubview:self.scrollView];
        }
        return cell;
        
    }
    if (indexPath.section==2) {
        FleaMarketTableCell * cell=[tableView dequeueReusableCellWithIdentifier:@"felaCell" forIndexPath:indexPath];
        if (self.junjiaArray!=nil) {
            TSFAvgModel * model=self.junjiaArray[0];
            cell.model=model;
        }
        return cell;
        
    } else{
        RoomsGuideTableCell * cell=[tableView dequeueReusableCellWithIdentifier:@"guideCell" forIndexPath:indexPath];
        InformationModel * model=_infoArray[indexPath.row];
        cell.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15);
        cell.model=model;
        
        return cell;
    
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        NSString * str=@"二手房";
        
        UIFont * buttonTitleFont=[UIFont systemFontOfSize:12];
        if (iPhone5) {
            buttonTitleFont=[UIFont systemFontOfSize:10];
        }
        NSDictionary * attributes=@{NSFontAttributeName:buttonTitleFont};
        CGSize size=[str sizeWithAttributes:attributes];
        
        return (kMainScreenWidth*0.09+size.height+30 +20)*2;
        
    }
    else if (indexPath.section==1){
        return kMainScreenWidth*0.3;
    }else if (indexPath.section==2){
        return 100;
    } else{
        return [self.tableView cellHeightForIndexPath:indexPath model:_infoArray[indexPath.row] keyPath:@"model" cellClass:[RoomsGuideTableCell class] contentViewWidth:[self cellContentViewWith]];
        
    }
}

- (CGFloat)cellContentViewWith
{
    CGFloat width=[UIScreen mainScreen].bounds.size.width;
    return width;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) {
        InformationModel * model=_infoArray[indexPath.row];
        
        IDModel * idModel=[IDModel new];
        idModel.ID=model.ID;
        idModel.catid=model.catid;
        HomeInformatiomController * vc=[[HomeInformatiomController alloc]init];
        vc.idModel=idModel;
        [self push:vc];
    } else{
        return;
    }
}
#pragma mark-----UIScrollViewDelegate----
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y>0) {
        if (scrollView.contentOffset.y>100) {
            [UIView animateWithDuration:0.5 animations:^{
                self.navigationController.navigationBarHidden=NO;
            }];
            
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                self.navigationController.navigationBarHidden=YES;
            }];
            
        }
    } else{
        return;
    }
   
    
}


/**表头按钮的点击,二手房，新房。。。*/
#pragma mark-----HeaderBtnVewDelegate------
- (void)homeButtonCellSelectBtnTag:(NSInteger)buttonTag
{
    switch (buttonTag) {
        case 100:{
            HandRoomViewController * vc =[[HandRoomViewController alloc ]init ];
            [self push:vc];
        }
            break;
        case 101:{
            NewHouseViewController * vc=[[NewHouseViewController alloc]init];
            [self.navigationItem.backBarButtonItem setTitle:@""];
            [self push:vc];
        }
            break;
        case 102:{
            RentRoomViewController * vc =[[RentRoomViewController alloc ]init ];
            [self push:vc];
        }
            break;
        case 103:{
            BorkerViewController * vc=[[BorkerViewController alloc]init];
            [self push:vc];
        }
            break;
        case 104:{
            OwnerEntrustVC * vc=[[OwnerEntrustVC alloc]init];
           [self push:vc];
            
        }
            break;
        case 105:{
            BlockTradesViewController * vc=[[BlockTradesViewController alloc]init];
            [self push:vc];
        }
            break;
        case 106:{
            MapForRoomViewController * vc=[[MapForRoomViewController alloc]init];
            [self push:vc];
            
        }
            break;
        case 107:{
            PurchaseNoticeViewController * vc=[[PurchaseNoticeViewController alloc]init];
            [self push:vc];
        }
            break;
            
        default:
            break;
    }
 
}


- (void)push:(UIViewController *)VC{
    VC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark----MainSectionViewDelegate---
- (void)tableView:(UITableView *)tableView sectionDidSelected:(NSInteger)section{
//    if (section==2) {
//        ChartViewController * vc=[[ChartViewController alloc]init];
//        vc.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden=NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
