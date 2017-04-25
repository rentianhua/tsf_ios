//
//  NewHouseListController.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/29.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "NewHouseListController.h"

#import "ZYWHttpEngine.h"
#import "OtherHeader.h"

#import "MJRefresh.h"
#import "MJExtension.h"
#import <UIImageView+WebCache.h>

#import "YJProgressHUD.h"

#import "NewHouseListCell.h"
#import "TSFNewListCell.h"

#import "TSFNewSegmentView.h"

#import "NewRoomDetailViewController.h"
#import "SearchVC.h"
#import "NewHouseViewController.h"
#import "MapForRoomViewController.h"

#import "TSFAreaModel.h"
#import "TSFSearchModel.h"
#import "IDModel.h"
#import "HouseModel.h"


#define NAVBTNW 20
#define NAVTITLEVIEWW kMainScreenWidth-NAVBTNW*3

@interface NewHouseListController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _page;
    
}

@property (nonatomic,strong)TSFNewSegmentView * topView;//下拉菜单

//实际获取的数据
@property (nonatomic,strong)NSMutableArray * dataArray;
/**表*/
@property (nonatomic,strong)UITableView * tableview;

//导航条
@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UIButton * rightNavBtn;



@property (nonatomic,strong)TSFSearchModel * searchModel;

@property (nonatomic,strong)UIButton * searchBtn;

@property (nonatomic,strong)NSArray * priceArray;
@property (nonatomic,strong)NSArray * typeArray;
@property (nonatomic,strong)NSArray * moreArray;

@property (nonatomic,strong)NSArray * secArray;
@property (nonatomic,strong)NSArray * titleArray;


@end

@implementation NewHouseListController
- (NSArray *)titleArray{
    if (_titleArray==nil) {
        _titleArray=@[@"区域",@"价格",@"房型",@"更多"];
    }
    return _titleArray;
}
- (NSArray *)secArray{
    if (_secArray==nil) {
        _secArray=@[@"装修",@"类型",@"属性",@"小区"];
    }
    return _secArray;
}
- (NSArray *)priceArray{
    if (_priceArray==nil) {
        _priceArray=@[@"不限",@"30万以下",@"30-50万",@"50-100万",@"100-150万",@"150-200万",@"200-250万",@"250-300万",@"300万以上"];
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
                     @[@"精装",@"简装",@"毛坯"],
                     @[@"居住",@"办公",@"商业",@"商住两用",@"厂房",@"综合体"],
                     @[@"商品房",@"村委统建",@"开发商建设",@"个人自建房",@"广东省军区军产房",@"武警部队军产房",@"工业长租房",@"工业产权房",@"其他"],
                     @[@"独栋",@"小区房"],
                     ];
    }
    return _moreArray;
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
        [_rightNavBtn setImage:[UIImage imageNamed:@"ic_map_newtitlebar_new"] forState:UIControlStateNormal];
        [_rightNavBtn addTarget:self action:@selector(toMapVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNavBtn;
}

- (NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.subviews.firstObject.alpha=1.0;
}

- (void)setSearchmodel:(TSFSearchModel *)searchmodel{
    _searchmodel=searchmodel;//从新房传过来的
}

- (void)setKwds:(NSString *)kwds{
    _kwds=kwds;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;

    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn];
    self.navigationItem.titleView=self.searchBtn;
    
    [self.view addSubview:self.topView];
    
    
    self.searchModel=_searchmodel;//新房跳转的搜索
    self.searchModel.kwds=_kwds;
    
    [self loadData];
    

    __weak typeof(self)weakSelf=self;
    
    weakSelf.topView.btnBlockMore = ^(NSDictionary *selDic){
        weakSelf.searchModel.zx=nil;
        weakSelf.searchModel.yt=nil;
        weakSelf.searchModel.wy=nil;
        weakSelf.searchModel.xq=nil;
        
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
                            weakSelf.searchModel.zx=moreStr;
                            break;
                        case 1:
                            weakSelf.searchModel.yt=moreStr;
                            break;
                            
                        case 2:
                            
                            if ([moreStr isEqualToString:@"村委统建"]) {
                                moreStr=@"集体用地村委统建楼";
                            }
                            if ([moreStr isEqualToString:@"开发商建设"]) {
                                moreStr=@"集体用地开发商自建楼";
                            }
                            
                            if ([moreStr isEqualToString:@"个人自建房"]) {
                                moreStr=@"集体用地个人自建房";
                            }
                            
                            if ([moreStr isEqualToString:@"广东省军区军产房"]) {
                                moreStr=@"军区建房";
                            }
                            
                            if ([moreStr isEqualToString:@"武警部队军产房"]) {
                                moreStr=@"武警部队建房";
                            }
                            if ([moreStr isEqualToString:@"武警部队军产房"]) {
                                moreStr=@"武警部队建房";
                            }
                            if ([moreStr isEqualToString:@"工业长租房"]) {
                                moreStr=@"工业属性长租物业";
                            }
                            if ([moreStr isEqualToString:@"工业产权房"]) {
                                moreStr=@"工业可分割产权物业";
                            }
                            
                            weakSelf.searchModel.wy=moreStr;
                            break;
                            
                        case 3:
                            weakSelf.searchModel.xq=moreStr;
                            break;
                            
                            
                        default:
                            break;
                    }
                }
            }
        }
        
        [weakSelf loadData];
    };
    
    self.topView.btnBlock=^(TSFAreaModel * model,NSInteger areaindex,NSString * price,NSInteger priceindex,NSString * huxing,NSInteger huxingindex,NSString * moreStr,NSInteger section){
        
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
            if ([price isEqualToString:@"30万以下"]) {
                weakSelf.searchModel.zj=@"0-30";
            } else if ([price isEqualToString:@"300万以上"]){
                weakSelf.searchModel.zj=@"300-";
            } else{
                weakSelf.searchModel.zj=[[price componentsSeparatedByString:@"万"] firstObject];
            }

        }
        
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
        
        
//        weakSelf.searchModel.zx=nil;
//        weakSelf.searchModel.yt=nil;
//        weakSelf.searchModel.wy=nil;
//        weakSelf.searchModel.xq=nil;
//        
//        if (moreStr!=nil) {
//            switch (section) {
//                case 0:
//                    weakSelf.searchModel.zx=moreStr;
//                    break;
//                case 1:
//                    weakSelf.searchModel.yt=moreStr;
//                    break;
//
//                case 2:
//                  
//                    if ([moreStr isEqualToString:@"村委统建"]) {
//                        moreStr=@"集体用地村委统建楼";
//                    }
//                    if ([moreStr isEqualToString:@"开发商建设"]) {
//                        moreStr=@"集体用地开发商自建楼";
//                    }
//                    
//                    if ([moreStr isEqualToString:@"个人自建房"]) {
//                        moreStr=@"集体用地个人自建房";
//                    }
//                    
//                    if ([moreStr isEqualToString:@"广东省军区军产房"]) {
//                        moreStr=@"军区建房";
//                    }
//                    
//                    if ([moreStr isEqualToString:@"武警部队军产房"]) {
//                        moreStr=@"武警部队建房";
//                    }
//                    if ([moreStr isEqualToString:@"武警部队军产房"]) {
//                        moreStr=@"武警部队建房";
//                    }
//                    if ([moreStr isEqualToString:@"工业长租房"]) {
//                        moreStr=@"工业属性长租物业";
//                    }
//                    if ([moreStr isEqualToString:@"工业产权房"]) {
//                        moreStr=@"工业可分割产权物业";
//                    }
//                    
//                    weakSelf.searchModel.wy=moreStr;
//                    break;
//
//                case 3:
//                    weakSelf.searchModel.xq=moreStr;
//                    break;
//
//                    
//                default:
//                    break;
//            }
//        }
        
        
        
        [weakSelf loadData];
        
        
    };
    
    
    
    
    [self initWithTableView];
    [self setUpMJRefresh];
    [self setUpMJFooter];
    
}
//搜索
- (void)searchAction:(UIButton *)button{
    SearchVC * vc=[[SearchVC alloc]init];
    __weak typeof(self)weakSelf=self;
    
    vc.kwdsBlock=^(NSString * kwds){
        
        weakSelf.searchModel.kwds=kwds;
        
        [weakSelf loadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)toMapVC{
    MapForRoomViewController * VC=[[MapForRoomViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)loadData{
    
    __weak typeof(self)weakSelf=self;
    [YJProgressHUD showProgress:@"正在加载中" inView:weakSelf.view];
    
    self.searchModel.catid=@3;
    self.searchModel.page=@1;
    
    [self.dataArray removeAllObjects];
    
    NSDictionary * param=[self.searchModel mj_keyValues];
    
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=house&a=lists",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        
        if (responseObj) {
            
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
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_header endRefreshing];

    } failure:^(NSError *error) {
        [weakSelf.tableview.mj_header endRefreshing];
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
        
        
    }];
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
    
    __weak typeof(self)weakSelf=self;
    _page=_page+1;
    self.searchModel.page=[NSNumber numberWithInteger:_page];
    
    NSDictionary * param=[self.searchModel mj_keyValues];
    
    [YJProgressHUD showProgress:@"正在加载中" inView:weakSelf.view];
    
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=house&a=lists",URLSTR] params:param success:^(id responseObj) {
        
        [YJProgressHUD hide];
        if (responseObj!=nil) {
            
            NSArray * newArray=[HouseModel mj_objectArrayWithKeyValuesArray:responseObj];
            [weakSelf.dataArray addObjectsFromArray:newArray];
            [YJProgressHUD showMessage:[NSString stringWithFormat:@"共找到%ld个房源",weakSelf.dataArray.count] inView:weakSelf.view];
           
            [weakSelf.tableview reloadData];

        } else{
            [YJProgressHUD showMessage:@"没有更多房源了" inView:weakSelf.view];
        }
        [weakSelf.tableview.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [weakSelf.tableview.mj_footer endRefreshing];
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
        
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
    
    [tableView registerNib:[UINib nibWithNibName:@"TSFNewListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
  
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSFNewListCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    HouseModel * model=self.dataArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
    cell.label1.text=model.title;
    
    NSString * shi;
    NSString * shiarea=model.shiarea;
    if (![shiarea containsString:@","]) {
        shi=[NSString stringWithFormat:@"%@室",shiarea];
    } else{
        NSArray * shiarray=[shiarea componentsSeparatedByString:@","];
        shi=[NSString stringWithFormat:@"%@-%@室",[shiarray firstObject],[shiarray lastObject]];
    }
    cell.label2.text=[NSString stringWithFormat:@"%@/%@平米",shi,model.mianjiarea];
    cell.label4.text=[NSString stringWithFormat:@"%@ %@",model.cityname,model.areaname];
    if ([model.junjia isEqualToString:@"0"]) {
        cell.label3.text=@"价格待定";
    } else{
        cell.label3.text=[NSString stringWithFormat:@"%@元/㎡",model.junjia];
    }
    NSString * kaipanStr;
    if ([model.kaipandate containsString:@"-"]) {
        kaipanStr=[model.kaipandate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    } else{
        kaipanStr=model.kaipandate;
    }
    cell.label6.text=[NSString stringWithFormat:@"开盘时间:%@",kaipanStr];
    //cell.label5.text=model.contacttel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewRoomDetailViewController * vc=[[NewRoomDetailViewController alloc]init];
    HouseModel * model=self.dataArray[indexPath.row];
    IDModel * idModel=[IDModel new];
    idModel.ID=model.ID;
    idModel.catid=model.catid;
    vc.idModel=idModel;
    [self.navigationController pushViewController:vc animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
