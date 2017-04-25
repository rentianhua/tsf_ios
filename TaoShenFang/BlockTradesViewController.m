//
//  BlockTradesViewController.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/24.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "BlockTradesViewController.h"
#import <MJRefresh.h>
#import "YJProgressHUD.h"
#import "BlockTradesDetailController.h"
#import "OtherHeader.h"
#import "MapForRoomViewController.h"

#import "HouseModel.h"
#import "IDModel.h"
#import "ZYWHttpEngine.h"
#import "MJExtension.h"
#import "SearchVC.h"

#import "MapPositionController.h"
#import "MessageViewController.h"
#import "LoginViewController.h"
#import "TSFBlockCell.h"
#import <UIImageView+WebCache.h>

#import "TSFNewSegmentView.h"
#import "TSFAreaModel.h"
#import "TSFSearchModel.h"

#define NAVBTNW 20

@interface BlockTradesViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _page;
    
}



@property (nonatomic,strong)TSFNewSegmentView * topView;//下拉菜单

@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong)UITableView * tableView;



//导航条上的按钮
@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UIButton * rightNavBtn1;
@property (nonatomic,strong)UIButton * rightNavBtn2;
@property (nonatomic,strong)UIButton * searchBtn;

@property (nonatomic,strong)NSArray * priceArray;
@property (nonatomic,strong)NSArray * typeArray;
@property (nonatomic,strong)NSArray * moreArray;

@property (nonatomic,strong)NSArray * secArray;
@property (nonatomic,strong)NSArray * titleArray;
@property (nonatomic,strong)TSFSearchModel * searchModel;

@end


@implementation BlockTradesViewController

- (NSArray *)titleArray{
    if (_titleArray==nil) {
        _titleArray=@[@"区域",@"金额",@"面积",@"更多"];
    }
    return _titleArray;
}
- (NSArray *)secArray{
    if (_secArray==nil) {
        _secArray=@[@"属性",@"类型",@"方式"];
    }
    return _secArray;
}
- (NSArray *)priceArray{
    if (_priceArray==nil) {
        _priceArray=@[@"不限",@"1000万以下",@"1000-2000万",@"2000-5000万",@"5000万-1亿",@"1亿以上"];
    }
    return _priceArray;
}

- (NSArray *)typeArray{
    if (_typeArray==nil) {
        _typeArray=@[@"不限",@"1万平米以下",@"1-5万平米",@"5-10万平米",@"10万平米以上"];
    }
    return _typeArray;
}
- (NSArray *)moreArray{
    if (_moreArray==nil) {
        _moreArray=@[
                     @[@"商用/办公土地",@"商业用地",@"工业用地",@"综合用地",@"住宅用地",@"村集体用地",@"军队用地",@"林业用地"],
                     @[@"商业用房",@"住宅用房",@"写字楼",@"工业厂房",@"酒店",@"集体",@"军产房"],
                     @[@"整体转让",@"控股权转让",@"部分转让",@"股权融资",@"债权融资",@"租赁融资"],
                     ];
    }
    return _moreArray;
}

- (TSFSearchModel *)searchModel{
    if (_searchModel==nil) {
        _searchModel=[[TSFSearchModel alloc]init];
    }
    return _searchModel;
}
- (TSFNewSegmentView *)topView{
    if (_topView==nil) {
        _topView=[[TSFNewSegmentView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44) priceArr:self.priceArray typeArr:self.typeArray moreArr:self.moreArray moreSecArr:self.secArray titleArr:self.titleArray ];
    }
    return _topView;
}


- (UIButton *)searchBtn{
    if (_searchBtn==nil) {
        _searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth-90, 30)];
        _searchBtn.backgroundColor=RGB(232, 232, 232, 1.0);
        [_searchBtn setImage:[UIImage imageNamed:@"homepage_search_icon"] forState:UIControlStateNormal];
        [_searchBtn setTitle:@" 请输入小区名或商圈名" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:RGB(173, 173, 173, 1.0) forState:UIControlStateNormal];
        [_searchBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _searchBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        _searchBtn.contentEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
        [_searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

- (UIButton *)rightNavBtn1{
    if (_rightNavBtn1==nil) {
        _rightNavBtn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_rightNavBtn1 setImage:[UIImage imageNamed:@"btn_chat_new"] forState:UIControlStateNormal];
        [_rightNavBtn1 addTarget:self action:@selector(toMessageVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNavBtn1;
}

- (UIButton *)rightNavBtn2{
    if (_rightNavBtn2==nil) {
        _rightNavBtn2=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_rightNavBtn2 setImage:[UIImage imageNamed:@"ic_map_newtitlebar_new"] forState:UIControlStateNormal];
        [_rightNavBtn2 addTarget:self action:@selector(toMapVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNavBtn2;
}

- (NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

//到房源地图页
- (void)toMapVC{
    MapForRoomViewController * vc=[[MapForRoomViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//到消息列表页 /登录
- (void)toMessageVC{
    if (NSUSER_DEF(USERINFO)==nil) {
        LoginViewController * vc=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    } else{
        MessageViewController * vc=[[MessageViewController alloc]init];
        vc.type = MessageTypeBack;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//去搜索
- (void)searchAction:(UIButton *)button{
    __weak typeof(self)weakSelf=self;
    
    SearchVC * vc=[[SearchVC alloc]init];
    vc.kwdsBlock=^(NSString * kwds){
        weakSelf.searchModel.kwds=kwds;
        [weakSelf loadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    UIBarButtonItem * rightBarBtn1=[[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn1];
    
    UIBarButtonItem * rightBarBtn2=[[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn2];
    
    self.navigationItem.rightBarButtonItems=@[rightBarBtn1,rightBarBtn2];
    
    self.navigationItem.titleView=self.searchBtn;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    
    [self loadData];
    
    [self createTableView];
    
    [self.view addSubview:self.topView];
    __weak typeof(self)weakSelf=self;
    
    weakSelf.topView.btnBlockMore = ^(NSDictionary *selDic){
        weakSelf.searchModel.sx=nil;
        weakSelf.searchModel.lx=nil;
        weakSelf.searchModel.fs=nil;
        
        if (selDic!=nil && selDic.count>0)
        {
            for(NSNumber *sec in selDic.allKeys)
            {
                NSString *moreStr = [selDic objectForKey:sec];
                if(moreStr.length>0)
                {
                    switch ([sec integerValue])
                    {
                        case 0:
                            weakSelf.searchModel.sx=moreStr;
                            break;
                        case 1:
                            weakSelf.searchModel.lx=moreStr;
                            break;
                        case 2:
                            weakSelf.searchModel.fs=moreStr;
                            break;
                        default:
                            break;
                    }
                }
            }
        }
        
        [weakSelf loadData];
    };
    
    weakSelf.topView.btnBlock=^(TSFAreaModel * model,NSInteger areaindex,NSString * price,NSInteger priceindex,NSString * huxing,NSInteger huxingindex,NSString * moreStr,NSInteger section){
        
        _page=1;//每调一次 初始化page
        
        if (areaindex==100) {//不限  的时候  不传街道
            weakSelf.searchModel.ar=nil;
            if (model!=nil) {
                weakSelf.searchModel.ct=model.ID;
                
            } else{
                weakSelf.searchModel.ct=nil;
                
            }
            
        } else if (areaindex==300){
            weakSelf.searchModel.ct=nil;
            weakSelf.searchModel.ar=model.ID;
        }
        
        
        if (priceindex==100) {//不限
            weakSelf.searchModel.zj=nil;
        } else if (priceindex==200){
            
        } else if (priceindex==300) {
            if ([price isEqualToString:@"1000万以下"]) {
                weakSelf.searchModel.zj=@"0-1000";
            }else if ([price isEqualToString:@"5000万-1亿"]){
                weakSelf.searchModel.zj=@"5000-10000";
            }
            else if ([price isEqualToString:@"1亿以上"]){
                weakSelf.searchModel.zj=@"10000-";
            } else{
                if ([price containsString:@"万"]) {
                    
                    weakSelf.searchModel.zj=[[price componentsSeparatedByString:@"万"] firstObject];
                } else{
                    weakSelf.searchModel.zj=price;
                }
                
            }
            
        }
        
        if (huxingindex==100) {
            weakSelf.searchModel.mj=nil;
        } else if (huxingindex==200){
            
        } else if (huxingindex==300){
            if ([huxing isEqualToString:@"1万平米以下"]) {
                weakSelf.searchModel.mj=@"0-10000";
            } else if ([huxing isEqualToString:@"1-5万平米"]){
                weakSelf.searchModel.mj=@"10000-50000";
            } else if ([huxing isEqualToString:@"5-10万平米"]){
                weakSelf.searchModel.mj=@"50000-100000";
            }
            else if ([huxing isEqualToString:@"10万平米以上"]){
                weakSelf.searchModel.mj=@"100000-";
            }
        }
        
        //        weakSelf.searchModel.sx=nil;
        //        weakSelf.searchModel.lx=nil;
        //        weakSelf.searchModel.fs=nil;
        //
        //        if (moreStr!=nil) {
        //            switch (section) {
        //                case 0:
        //                    weakSelf.searchModel.sx=moreStr;
        //                    break;
        //                case 1:
        //                    weakSelf.searchModel.lx=moreStr;
        //                    break;
        //                case 2:
        //                    weakSelf.searchModel.fs=moreStr;
        //                    break;
        //                default:
        //                    break;
        //            }
        //        }
        
        
        
        [weakSelf loadData];
        
        
    };
    
    
    
}

- (void)setUpMJRefresh{
    __unsafe_unretained __typeof(self)weakSelf = self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    } ];
    
}

- (void)setUpMJFooter{
    __unsafe_unretained __typeof(self)weakSelf = self;
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)loadData{
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    self.searchModel.catid=@7;
    self.searchModel.page=@1;
    NSDictionary * param=[self.searchModel mj_keyValues];
    
    __weak typeof(self)weakSelf=self;
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=house&a=lists",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        
        [self.dataArray removeAllObjects];
        if (responseObj)
        {
            NSArray * newArray=[HouseModel mj_objectArrayWithKeyValuesArray:responseObj];
        
            NSRange range=NSMakeRange(0, newArray.count);
            NSIndexSet * indexSet=[NSIndexSet indexSetWithIndexesInRange:range];
            
            [weakSelf.dataArray insertObjects:newArray atIndexes:indexSet];
            if (weakSelf.dataArray.count>0)
            {
                HouseModel * model=weakSelf.dataArray[0];
                [YJProgressHUD showMessage:[NSString stringWithFormat:@"共找到%ld个房源",(long)[model.zonghe integerValue]] inView:weakSelf.view];
            }
        }
        else
        {
            [YJProgressHUD showMessage:@"没有该房源" inView:weakSelf.view];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [self.tableView.mj_header endRefreshing];
        
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
    }];
    
    
}



- (void)reloadData:(UITapGestureRecognizer *)sender{
    [self loadData];
}


//上拉加载
- (void)loadMoreData{
    
    _page=_page+1;
    self.searchModel.page=[NSNumber numberWithInteger:_page];
    
    NSDictionary * param=[self.searchModel mj_keyValues];
    
    __weak typeof(self)weakSelf=self;
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=house&a=lists",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj!=nil) {
            
            NSArray * newArray=[HouseModel mj_objectArrayWithKeyValuesArray:responseObj];
            
            [weakSelf.dataArray addObjectsFromArray:newArray];
            
            [weakSelf.tableView reloadData];
        }
        else
        {
            [YJProgressHUD showMessage:@"没有更多房源了" inView:weakSelf.view];
        }
        [weakSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [YJProgressHUD hide];
    }];
    
}

- (void)pop:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
/**表的创建*/
- (void)createTableView
{
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, kMainScreenWidth, kMainScreenHeight-64-44) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.rowHeight=150;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    
    tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    [tableView registerNib:[UINib nibWithNibName:@"TSFBlockCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self setUpMJRefresh];
    [self setUpMJFooter];
}

#pragma mark-----UITableViewDelegate-----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count==0) {
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    } else{
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    }
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSFBlockCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath ];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    HouseModel * model=self.dataArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
    cell.label1.text=model.title;
    cell.label2.text=[NSString stringWithFormat:@"%@ %@",model.cityname,model.areaname];
    cell.label3.text=[NSString stringWithFormat:@"%@万",model.zongjia];
    cell.label4.text=[NSString stringWithFormat:@"%@",model.wuyetype];
    if ([model.shiyongnianxian isEqualToString:@"999"]) {
        cell.label5.text=@"使用年限：长期";
    } else{
        cell.label5.text=[NSString stringWithFormat:@"使用年限：%@年",model.shiyongnianxian];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlockTradesDetailController * vc=[[BlockTradesDetailController alloc]init];
    HouseModel * model=self.dataArray[indexPath.row];
    
    IDModel * IDmodel=[[IDModel alloc]init];
    IDmodel.ID=model.ID;
    IDmodel.catid=model.catid;
    vc.IDmodel=IDmodel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
