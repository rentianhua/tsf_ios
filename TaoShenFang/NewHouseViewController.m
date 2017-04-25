//
//  NewHouseViewController.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/21.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "NewHouseViewController.h"

#import "OtherHeader.h"

#import <UIImageView+WebCache.h>
#import "SDCycleScrollView.h"
#import "MJExtension.h"
#import "YJProgressHUD.h"


#import "MainSectionView.h"
#import "MoreInformationFooterView.h"
#import "XMYClassifyView.h"

#import "TSFNewInfoCell.h"
#import "TSFNewRoomCell.h"
#import "TSFNewNoDataCell.h"


#import "NewHouseListController.h"
#import "NewRoomDetailViewController.h"
#import "MapForRoomViewController.h"
#import "TSFInfoListVC.h"


#import "ZYWHttpEngine.h"

#import "TSFSearchModel.h"
#import "InformationModel.h"
#import "NewHouseModel.h"
#import "HouseModel.h"
#import "IDModel.h"


#import "HomeInformatiomController.h"
#import "NewHouseListController.h"
#import "TSFNewSearchVC.h"

#define NAVBTNW 20

@interface NewHouseViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,XMYClassifyViewDelegate>

{
    NSArray * _infoArray;
    NSArray * _newHouseArray;
}


//搜索关键字
@property (nonatomic,copy)NSString * kwds;
/**表头*/
@property (nonatomic,strong)UIView * headView;
/**图片数组*/
@property (nonatomic,strong)NSArray * imageArray;
/**数据数组*/
@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong)UITableView * tableView;

//导航条上的按钮
@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UIButton * rightNavBtn;

@property (nonatomic,strong)UIImageView * barImgView;
@property (nonatomic,strong)UIButton * searchBtn;

@end

@implementation NewHouseViewController
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

- (UIButton *)rightNavBtn{
    if (_rightNavBtn==nil) {
        _rightNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_rightNavBtn setImage:[UIImage imageNamed:@"ic_map_newtitlebar_new"] forState:UIControlStateNormal];
        [_rightNavBtn addTarget:self action:@selector(toMapVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNavBtn;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}


- (UIView *)headView
{
    if (_headView==nil) {
        _headView=[[UIView alloc]init];
        _headView.backgroundColor = UIColorFromRGB(0Xf0eff5);
    }
    return _headView;
}
- (NSArray *)imageArray
{
    if (_imageArray==nil) {
        _imageArray=[NSArray arrayWithObjects:@"school_index_bg",nil];
    }
    return _imageArray;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn];
    self.navigationItem.titleView=self.searchBtn;
    _barImgView=self.navigationController.navigationBar.subviews.firstObject;
    _barImgView.alpha=1.0;
}

//去搜索
- (void)searchAction:(UIButton *)button{
    TSFNewSearchVC * VC=[[TSFNewSearchVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithHeadView];
    [self initWithTableView];
    [self loadData];
    [self loadInfo];
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)toMapVC{
  
    MapForRoomViewController * VC=[[MapForRoomViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
    
}
- (void)loadInfo{
    
    __weak typeof(self)weakSelf=self;
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    NSString * urlInfo=[NSString stringWithFormat:@"%@g=api&m=house&a=position",URLSTR];
    NSDictionary * paramInfo=@{@"posid":@14};
    [ZYWHttpEngine AllPostURL:urlInfo params:paramInfo success:^(id responseObj) {
        
        
        if (responseObj) {
            _infoArray=[InformationModel mj_objectArrayWithKeyValuesArray:responseObj];
            
            [weakSelf.dataArray addObjectsFromArray:_infoArray];
            
            [weakSelf.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
    }];
  
}

- (void)loadData{
    __weak typeof(self)weakSelf=self;
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    NSString * url=[NSString stringWithFormat:@"%@g=api&m=house&a=position",URLSTR];
    NSDictionary * param=@{@"posid":@13};

    [ZYWHttpEngine AllPostURL:url params:param success:^(id responseObj) {
        if (responseObj) {
            
            [YJProgressHUD hide];
            _newHouseArray=[NewHouseModel mj_objectArrayWithKeyValuesArray:responseObj];
            [weakSelf.dataArray addObjectsFromArray:_newHouseArray];
            
            [weakSelf.tableView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
    }];

}

/**表头的创建*/
- (void)initWithHeadView
{
    CGFloat imageW=kMainScreenWidth;
    CGFloat imageH=kMainScreenWidth*1/3;
    if (self.imageArray!=nil) {
        UIImage * image=[UIImage imageNamed:self.imageArray[0]];
        imageH=imageW * image.size.height/image.size.width;
    }
   //滚动视图
    SDCycleScrollView * scroll=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, imageW, imageH) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    scroll.imageURLStringsGroup=self.imageArray;
    [self.headView addSubview:scroll];
    
    XMYClassifyView * classifyView=[[XMYClassifyView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(scroll.frame), kMainScreenWidth, kMainScreenWidth/3)];
    classifyView.delegate=self;
    [self.headView addSubview:classifyView];
    
    self.headView.frame=CGRectMake(0, 0, kMainScreenWidth, scroll.bounds.size.height+classifyView.bounds.size.height+20);
}

/**表的创建*/
- (void)initWithTableView
{
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.tableHeaderView=self.headView;
    self.tableView=tableView;
    
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [tableView registerNib:[UINib nibWithNibName:@"TSFNewRoomCell" bundle:nil] forCellReuseIdentifier:@"newcell"];
    
    [tableView registerNib:[UINib nibWithNibName:@"TSFNewNoDataCell" bundle:nil] forCellReuseIdentifier:@"nodata"];
    [tableView registerNib:[UINib nibWithNibName:@"TSFNewInfoCell" bundle:nil] forCellReuseIdentifier:@"infoCell"];
    
}

#pragma mark-----UITableViewDelegate-----

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_infoArray.count==0 && _newHouseArray.count==0) {
        return 0;
    }
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    NSArray * array=[NSArray arrayWithObjects:@"楼市资讯",@"热销房源", nil];
    MainSectionView * head=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"sectionHeader" ];
    if (!head) {
            head=[[MainSectionView alloc]initWithReuseIdentifier:@"sectionHeader" ];
        }
    head.leftLabel.text=array[section];
    return head;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 150;
    } else{
        return 120;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        if (_infoArray.count==0) {
            return 0.001;
        } else{
            return 60;
        }
    } else{
        if (_newHouseArray.count==0) {
            return 0.001;
        } else{
            return 60;
        }
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==0) {
        if (_infoArray.count==0) {
            return nil;
        } else{
            MoreInformationFooterView * footer=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
            if (!footer) {
                footer=[[MoreInformationFooterView alloc]initWithReuseIdentifier:@"footer"];
            }
            footer.button.tag=section;
            [footer.button addTarget:self action:@selector(moreInformation:) forControlEvents:UIControlEventTouchUpInside];
            return footer;
        }
    } else{
        if (_newHouseArray.count==0) {
            return nil;
        } else{
            MoreInformationFooterView * footer=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
            if (!footer) {
                footer=[[MoreInformationFooterView alloc]initWithReuseIdentifier:@"footer"];
            }
            footer.button.tag=section;
            [footer.button addTarget:self action:@selector(moreInformation:) forControlEvents:UIControlEventTouchUpInside];
            return footer;
        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        if (_infoArray.count==0) {
            return 1;
        } else{
        return _infoArray.count;
        }
    } else{
        if (_newHouseArray.count==0) {
            return 1;
        } else{
        return _newHouseArray.count;
        }
    }
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
 
        if (_infoArray.count==0) {
            TSFNewNoDataCell * cell=[tableView dequeueReusableCellWithIdentifier:@"nodata" forIndexPath:indexPath];
            return cell;
        } else{
            InformationModel * model=_infoArray[indexPath.row];
            
            TSFNewInfoCell * cell=[tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.data.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
            cell.label1.text=model.data.title;
            cell.label2.text=model.data.descrip;
            cell.label3.text=@"行业资讯";
            
            return cell;
        }
        
        
    } else{
        
        if (_newHouseArray.count==0) {
            TSFNewNoDataCell * cell=[tableView dequeueReusableCellWithIdentifier:@"nodata" forIndexPath:indexPath];
            return cell;
        } else{
        
        TSFNewRoomCell * cell=[tableView dequeueReusableCellWithIdentifier:@"newcell" forIndexPath:indexPath];
        NewHouseModel * model=_newHouseArray[indexPath.row];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.data.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
        cell.label1.text=model.data.title;
        NSString * str1;
        NSString * str2;
        NSArray * shiArray=[model.data.shiarea componentsSeparatedByString:@","];
       
        if (shiArray.count>3 || shiArray.count==3) {
        str1=[shiArray objectAtIndex:1];
        str2=[shiArray lastObject];
        }
       
        cell.label2.text=[NSString stringWithFormat:@"%@-%@室/%@平米",str1,str2,model.data.mianjiarea];
        cell.label3.text=[NSString stringWithFormat:@"%@ %@ %@",model.data.province_name,model.data.city_name,model.data.area_name];
        cell.label4.text=[NSString stringWithFormat:@"%@元/㎡",model.data.junjia];
        return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        HomeInformatiomController * vc=[[HomeInformatiomController alloc]init];
        InformationModel * model=_infoArray[indexPath.row];
        IDModel * idmodel=[[IDModel alloc]init];
        idmodel.catid=model.catid;
        idmodel.ID=model.ID;
        vc.idModel=idmodel;
              [self.navigationController pushViewController:vc animated:YES];
    }
    else{
      
        NewRoomDetailViewController * vc=[[NewRoomDetailViewController alloc]init];
        NewHouseModel * model=_newHouseArray[indexPath.row];
        IDModel * idmodel=[[IDModel alloc]init];
        idmodel.catid=model.catid;
        idmodel.ID=model.ID;
        vc.idModel=idmodel;
       [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark----XMYClassifyViewDelegate---
- (void)xMYClassifyViewButtonClick:(UIButton *)button{
    
    TSFSearchModel * model=[[TSFSearchModel alloc]init];
    NewHouseListController * VC=[[NewHouseListController alloc]init];
    switch (button.tag) {
        case 100:
            model.ct=@4;//福田
            break;
        case 101:
            model.ct=@8;//龙岗
            break;
        case 102:
            model.ct=@2;//罗湖
            break;
        case 103:
            model.shi=@"2";
            break;
        case 104:
            model.shi=@"3";
            break;
        case 105:
            model.shi=@"4";
            
            break;
        case 106:
            model.zx=@"精装";
            break;
        case 107:
            model.wy=@"商品房";
            break;
        case 108:
            
            break;
            
        default:
            break;
    }
    VC.searchmodel=model;
    [self.navigationController pushViewController:VC animated:YES];
    
}

/**区尾点击方法*/
- (void)moreInformation:(UIButton *)button
{
    if (button.tag==1) {
        NewHouseListController * vc=[[NewHouseListController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else{
        TSFInfoListVC * VC=[[TSFInfoListVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
