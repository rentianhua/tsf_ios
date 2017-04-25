//
//  RentRoomViewController.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/21.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "RentRoomViewController.h"
#import "RentRoomDetailVC.h"
#import "MapForRoomViewController.h"

#import "ZYWHttpEngine.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "MJExtension.h"
#import "HouseModel.h"
#import "OtherHeader.h"
#import "MapPositionController.h"
#import "MessageViewController.h"
#import "LoginViewController.h"
#import "YJProgressHUD.h"
#import "MJRefresh.h"
#import "SearchVC.h"
#import "BaseRoomCell.h"
#import <UIImageView+WebCache.h>

#import "TSFSegmentView.h"//下拉框搜索
#import "TSFAreaModel.h"

#import "TSFSearchModel.h"

#define NAVBTNW 20

@interface RentRoomViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSInteger _page;
   
}

//实际获取的数据
@property (nonatomic,strong)NSMutableArray * dataArray;
/**表*/
@property (nonatomic,strong)UITableView * tableview;

@property (nonatomic,strong)TSFSegmentView * topView;//下拉菜单
@property (nonatomic,strong)TSFSearchModel * searchModel;

@property (nonatomic,strong)NSArray * priceArray;
@property (nonatomic,strong)NSArray * typeArray;
@property (nonatomic,strong)NSArray * moreArray;
@property (nonatomic,strong)NSArray * secArray;
@property (nonatomic,strong)NSArray * titleArray;

//导航条上的按钮
@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UIButton * rightNavBtn1;
@property (nonatomic,strong)UIButton * rightNavBtn2;
@property (nonatomic,strong)UIButton * searchBtn;

@end

@implementation RentRoomViewController
- (NSArray *)titleArray{
    if (_titleArray==nil) {
        _titleArray=@[@"区域",@"租金",@"房型",@"更多"];
    }
    return _titleArray;
}
- (NSArray *)secArray{
    if (_secArray==nil) {
        _secArray=@[@"朝向",@"面积",@"标签",@"楼层",@"物业",@"方式",@"类型"];
    }
    return _secArray;
}
- (NSArray *)priceArray{
    if (_priceArray==nil) {
        _priceArray=@[@"不限",@"500元以下",@"500-1000元",@"1000-2000元",@"2000-3000元",@"3000-5000元",@"5000-8000元",@"8000-10000元",@"10000元以上"];
    }
    return _priceArray;
}

- (NSArray *)typeArray{
    if (_typeArray==nil) {
        _typeArray=@[@"不限",@"1室",@"2室",@"3室",@"4室",@"5室",@"5室以上"];
    }
    return _typeArray;
}
- (NSArray *)moreArray{
    if (_moreArray==nil) {
        _moreArray=@[
                     @[@"朝东",@"朝南",@"朝西",@"朝北",@"南北"],
                     @[@"50平以下",@"50-70平",@"70-90平",@"90-110平",@"110-140平",@"140-170平",@"170-200平",@"200平以上"],
                     @[@"精装修",@"随时看房"],
                     @[@"低层",@"中层",@"高层"],
                     @[@"商品房",@"村委统建",@"开发商建设",@"个人自建房",@"广东省军区军产房",@"武警部队军产房",@"工业长租房",@"工业产权房",@"其他"],
                     @[@"整租",@"合租"],
                     @[@"住宅",@"公寓",@"商铺",@"写字楼",@"其他"]];
    }
    return _moreArray;
}
- (TSFSearchModel *)searchModel{
    if (_searchModel==nil) {
        _searchModel=[[TSFSearchModel alloc]init];
    }
    return _searchModel;
}
- (TSFSegmentView *)topView{
    if (_topView==nil) {
        _topView=[[TSFSegmentView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44) priceArr:self.priceArray huxingArr:self.typeArray moreArr:self.moreArray moreSecArr:self.secArray titleArr:self.titleArray];
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

- (void)setKwds:(NSString *)kwds{
    _kwds=kwds;
    
    self.searchModel.kwds=kwds;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.navigationController.navigationBar.hidden=NO;
    _page=1;
    
    
    [self.view addSubview:self.topView];
    
    __weak typeof(self)weakSelf=self;
    
    weakSelf.topView.btnBlockMore = ^(NSDictionary *selDic){
        weakSelf.searchModel.cx=nil;
        weakSelf.searchModel.mj=nil;
        weakSelf.searchModel.zx=nil;
        weakSelf.searchModel.wy=nil;
        weakSelf.searchModel.lc=nil;
        weakSelf.searchModel.qs=nil;
        weakSelf.searchModel.ly=nil;
        weakSelf.searchModel.yt=nil;
        weakSelf.searchModel.zl=nil;
        weakSelf.searchModel.kf=nil;
        
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
                            if ([moreStr containsString:@"朝"]) {
                                weakSelf.searchModel.cx=[[moreStr componentsSeparatedByString:@"朝"]lastObject];
                            } else{
                                weakSelf.searchModel.cx=moreStr;
                            }
                            break;
                        case 1:
                            if ([moreStr isEqualToString:@"50平以下"]) {
                                weakSelf.searchModel.mj=@"0-50";
                            } else if ([moreStr isEqualToString:@"200平以上"]){
                                weakSelf.searchModel.mj=@"200-";
                            } else{
                                weakSelf.searchModel.mj=[[moreStr componentsSeparatedByString:@"平"] firstObject];
                            }
                            break;
                        case 2:{
                            if ([moreStr isEqualToString:@"精装修"]) {
                                weakSelf.searchModel.zx=@"精装";
                                
                            } else if ([moreStr isEqualToString:@"随时看房"]){
                                
                                weakSelf.searchModel.kf=moreStr;
                                
                            }
                        }
                            
                            break;
                        case 3:
                            weakSelf.searchModel.lc=moreStr;
                            break;
                        case 4:
                            weakSelf.searchModel.qs=moreStr;
                            break;
                        case 5:
                            weakSelf.searchModel.zl=moreStr;
                            break;
                        case 6:
                            weakSelf.searchModel.yt=moreStr;
                            break;
                            
                        default:
                            break;
                    }
                }
            }
        }
        
        [weakSelf loadData];
    };
    
    weakSelf.topView.btnBlock=^(TSFAreaModel * model,NSInteger areaindex,NSString * ditie,NSString * price,NSInteger priceindex,NSString * huxing,NSInteger huxingindex,NSString * moreStr,NSInteger section){
        
        _page=1;
        //区域   如果点了按钮啥也没选，就不会调这个block
        if (areaindex==100) {//不限
            weakSelf.searchModel.ct=nil;
            weakSelf.searchModel.ar=nil;
            weakSelf.searchModel.dt=nil;
            
        } else if (areaindex==200){//点击空白处
            //不操作
        } else if (areaindex==300){//选择区
            if (model!=nil) {
                weakSelf.searchModel.dt=nil;
                weakSelf.searchModel.ar=nil;
                weakSelf.searchModel.ct=model.ID;
            }
            if (ditie!=nil) {
                weakSelf.searchModel.ct=nil;
                weakSelf.searchModel.ar=nil;
                NSString * dt=[[ditie componentsSeparatedByString:@"号"] firstObject];
                weakSelf.searchModel.dt=[NSString stringWithFormat:@"[%@]",dt];
            }
        } else if (areaindex==400){//选择街道
            weakSelf.searchModel.ar=model.ID;
        }
        
        
        //价格
        if (priceindex==100) {
            weakSelf.searchModel.zj=nil;
        } else if (priceindex==200){
            
        } else if (priceindex==300){
            
            if ([price isEqualToString:@"500元以下"]) {
                weakSelf.searchModel.zj=@"0-500";
            } else if ([price isEqualToString:@"10000元以上"]){
                weakSelf.searchModel.zj=@"10000-";
            } else{
                if ([price containsString:@"元"]) {
                   weakSelf.searchModel.zj=[[price componentsSeparatedByString:@"元"] firstObject];
                } else{
                    weakSelf.searchModel.zj=price;
                }
                
            }
        }
        
        //房型
        if (huxingindex==100) {
            weakSelf.searchModel.shi=nil;
        } else if (huxingindex==200){
            
        } else if (huxingindex==300){
            if ([huxing isEqualToString:@"5室以上"]) {
                weakSelf.searchModel.shi=@"6";
            } else{
                weakSelf.searchModel.shi=[[huxing componentsSeparatedByString:@"室"] firstObject];
            }
        }
        
        //更多
        
//        weakSelf.searchModel.cx=nil;
//        weakSelf.searchModel.mj=nil;
//        weakSelf.searchModel.zx=nil;
//        weakSelf.searchModel.wy=nil;
//        weakSelf.searchModel.lc=nil;
//        weakSelf.searchModel.qs=nil;
//        weakSelf.searchModel.ly=nil;
//        weakSelf.searchModel.yt=nil;
//        weakSelf.searchModel.zl=nil;
//        weakSelf.searchModel.kf=nil;
//        
//        if (moreStr!=nil) {
//            switch (section) {
//                case 0:
//                    if ([moreStr containsString:@"朝"]) {
//                        weakSelf.searchModel.cx=[[moreStr componentsSeparatedByString:@"朝"]lastObject];
//                    } else{
//                        weakSelf.searchModel.cx=moreStr;
//                    }
//                    break;
//                case 1:
//                    if ([moreStr isEqualToString:@"50平以下"]) {
//                        weakSelf.searchModel.mj=@"0-50";
//                    } else if ([moreStr isEqualToString:@"200平以上"]){
//                        weakSelf.searchModel.mj=@"200-";
//                    } else{
//                        weakSelf.searchModel.mj=[[moreStr componentsSeparatedByString:@"平"] firstObject];
//                    }
//                    break;
//                case 2:{
//                    if ([moreStr isEqualToString:@"精装修"]) {
//                        weakSelf.searchModel.zx=@"精装";
//                        
//                    } else if ([moreStr isEqualToString:@"随时看房"]){
//                        
//                        weakSelf.searchModel.kf=moreStr;
//                        
//                    }
//                }
//                    
//                    break;
//                case 3:
//                    weakSelf.searchModel.lc=moreStr;
//                    break;
//                case 4:
//                    weakSelf.searchModel.qs=moreStr;
//                    break;
//                case 5:
//                    weakSelf.searchModel.zl=moreStr;
//                    break;
//                case 6:
//                    weakSelf.searchModel.yt=moreStr;
//                    break;
//                    
//                default:
//                    break;
//            }
//        }
//        
        
        
        
        [weakSelf loadData];
    };
    
    [self initWithTableView];
    [self setUpMJRefresh];
    [self setUpMJFooter];
    [self loadData];

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

- (void)setUpMJRefresh{
    __unsafe_unretained __typeof(self)weakSelf = self;
    self.tableview.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    } ];
    
}

- (void)setUpMJFooter{
    __unsafe_unretained __typeof(self)weakSelf = self;
    self.tableview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

//上拉加载
- (void)loadMoreData{
    
    _page=_page+1;
    self.searchModel.page=[NSNumber numberWithInteger:_page];
    
    NSDictionary * param=[self.searchModel mj_keyValues];
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
   
    __weak typeof(self)weakSelf=self;
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=house&a=lists",URLSTR] params:param success:^(id responseObj) {
        
        [YJProgressHUD hide];
        [self.tableview.mj_footer endRefreshing];
        
        if (responseObj!=nil) {
            
            NSArray * newArray=[HouseModel mj_objectArrayWithKeyValuesArray:responseObj];
            
            [weakSelf.dataArray addObjectsFromArray:newArray];
            
            [weakSelf.tableview reloadData];
           
        }
        else
        {
            [YJProgressHUD showMessage:@"没有更多房源了" inView:weakSelf.view];
        }
        
    } failure:^(NSError *error) {
        [self.tableview.mj_footer endRefreshing];
        [YJProgressHUD hide];
    }];
    
}



- (void)loadData{
  
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    self.searchModel.catid=@8;
    self.searchModel.page=@1;
    
    NSDictionary * param=[self.searchModel mj_keyValues];
    
    __weak typeof(self)weakSelf=self;
    [self.dataArray removeAllObjects];
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=house&a=lists",URLSTR] params:param success:^(id responseObj) {
        [self.tableview.mj_header endRefreshing];
        [YJProgressHUD hide];
        if (responseObj!=nil) {
            
            NSArray * newArray=[HouseModel mj_objectArrayWithKeyValuesArray:responseObj];
            NSRange range=NSMakeRange(0, newArray.count);
            NSIndexSet * indexSet=[NSIndexSet indexSetWithIndexesInRange:range];
            
            [weakSelf.dataArray insertObjects:newArray atIndexes:indexSet];
            
            if (weakSelf.dataArray.count>0) {
                HouseModel * model=weakSelf.dataArray[0];
                
                [YJProgressHUD showMessage:[NSString stringWithFormat:@"共找到%ld个房源",(long)[model.zonghe integerValue]] inView:weakSelf.view];
            }
            
        }else{
            [YJProgressHUD showMessage:@"没有该房源" inView:weakSelf.view];
        }
        
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview reloadData];
    
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
    
    }];
    

}

/**表的创建*/
- (void)initWithTableView
{
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, kMainScreenWidth, kMainScreenHeight-64-44) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    self.tableview=tableView;
    tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
     [tableView registerNib:[UINib nibWithNibName:@"BaseRoomCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark-----UITableViewDelegate-----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseRoomCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.hidenLine=YES;
    HouseModel * model=self.dataArray[indexPath.row];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
    cell.label1.text=model.title;
    cell.label2.text=[NSString stringWithFormat:@"%@室%@厅 %@㎡ %@",model.shi,model.ting,model.mianji,model.chaoxiang];
    NSString * zongjia=[NSString stringWithFormat:@"%@元/月",model.zujin];
    NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:zongjia attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:22]}];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 weight:16] range:NSMakeRange(attrStr.length-1, 1)];
    [cell.label3 setAttributedText:attrStr];
    
    cell.label4.text=[NSString stringWithFormat:@"%@ %@",model.cityname,model.areaname];
    NSString * biaoqian=model.biaoqian;
    cell.biaoqian=biaoqian;
    
   
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RentRoomDetailVC * vc=[[RentRoomDetailVC alloc]init];
    vc.model=self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


/**返回*/
- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

//到房源地图页
- (void)toMapVC
{
    MapForRoomViewController * vc=[[MapForRoomViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//到消息列表页 /登录
- (void)toMessageVC
{
    if (NSUSER_DEF(USERINFO)==nil) {
        LoginViewController * vc=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    } else{
        MessageViewController * vc=[[MessageViewController alloc]init];
        vc.type=MessageTypeBack;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
