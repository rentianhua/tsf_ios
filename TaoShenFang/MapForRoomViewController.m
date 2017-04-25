//
//  MapForRoomViewController.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/26.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "MapForRoomViewController.h"
#import "HandRoomDetailVC.h"
#import "RentRoomDetailVC.h"

#import "OtherHeader.h"
#import "ZYWHttpEngine.h"
#import "YJProgressHUD.h"

#import "StreetAnnotationView.h"
#import "DetailAnnotationView.h"
#import "TSFAreaPointAnnotation.h"
#import "TSFAreaAnnonationView.h"//区域标注view
#import "TSFXiaoQuAnnonation.h"//小区标注

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <MJExtension.h>
#import <Masonry.h>
#import <UIImageView+WebCache.h>


#import "TSFMapModel.h"
#import "XiaoQuModel.h"//小区模型
#import "HouseCountModel.h"//区域套数模型
#import "IDModel.h"

#import "BaseRoomCell.h"
#import "HouseModel.h"

#define NAVBTNW 20
@interface MapForRoomViewController ()<BMKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    BMKMapView * _mapView;
    BOOL isershou;
}

@property (nonatomic,strong)XiaoQuModel * xiaoqumodel;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * areaArray;//区域
@property (nonatomic,strong)NSMutableArray * streetArray;//街道
@property (nonatomic,strong)NSArray * xiaoQuArray;//小区
@property (nonatomic,strong)NSArray * houseCountArray;//返回的区域 房源套数
@property (nonatomic,strong)NSArray * cityCountArray;//返回的街道房源套数
/*
 区域 第一级
 */
@property (nonatomic,strong)NSMutableArray * ershouAnnonations;
@property (nonatomic,strong)NSMutableArray * chuzuAnnonations;
/*
 街道 第二级
 */
@property (nonatomic,strong)NSMutableArray * ershouAnnonations1;
@property (nonatomic,strong)NSMutableArray * chuzuAnnonations1;
/*
 小区 第三级
 */
@property (nonatomic,strong)NSMutableArray * ershouAnnonations2;
@property (nonatomic,strong)NSMutableArray * chuzuAnnonations2;


@property (nonatomic,strong)NSMutableArray * houseArray;//每个小区的房源数组

//导航条
@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UISegmentedControl * segment;


@end

@implementation MapForRoomViewController

- (UISegmentedControl *)segment{
    if (_segment==nil) {
        NSArray * segmentData=[NSArray arrayWithObjects:@"二手房",@"租房", nil];
        _segment=[[UISegmentedControl alloc]initWithItems:segmentData];
        _segment.frame=CGRectMake(0, 0, kMainScreenWidth/2, 30);
        /**设置按下按钮的颜色*/
        _segment.tintColor=[UIColor grayColor];
        /**设置默认选中的索引*/
        _segment.selectedSegmentIndex=0;
        /*下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等*/
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor grayColor], NSForegroundColorAttributeName, nil];
        [_segment setTitleTextAttributes:attributes forState:UIControlStateNormal];
        NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        [_segment setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
        /**设置分段控件点击相应事件*/
        [_segment addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];

    }
    return _segment;
}
- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}
- (NSMutableArray *)houseArray{
    if (_houseArray==nil) {
        _houseArray=[NSMutableArray array];
    }
    return _houseArray;
}
- (NSMutableArray *)ershouAnnonations2{
    if (_ershouAnnonations2==nil) {
        _ershouAnnonations2=[NSMutableArray array];
    }
    return _ershouAnnonations2;
}
- (NSMutableArray *)chuzuAnnonations2{
    if (_chuzuAnnonations2==nil) {
        _chuzuAnnonations2=[NSMutableArray array];
    }
    return _chuzuAnnonations2;
}

- (NSMutableArray *)ershouAnnonations1{
    if (_ershouAnnonations1==nil) {
        _ershouAnnonations1=[NSMutableArray array];
    }
    return _ershouAnnonations1;
}
- (NSMutableArray *)ershouAnnonations{
    if (_ershouAnnonations==nil) {
        _ershouAnnonations=[NSMutableArray array];
    }
    return _ershouAnnonations;
}
- (NSMutableArray *)chuzuAnnonations1{
    if (_chuzuAnnonations1==nil) {
        _chuzuAnnonations1=[NSMutableArray array];
    }
    return _chuzuAnnonations1;
}

- (NSMutableArray *)chuzuAnnonations{
    if (_chuzuAnnonations==nil) {
        _chuzuAnnonations=[NSMutableArray array];
    }
    return _chuzuAnnonations;
}
- (NSMutableArray *)areaArray{
    if (_areaArray==nil) {
        NSString * path=[[NSBundle mainBundle] pathForResource:@"Area" ofType:@"plist"];
        _areaArray=[TSFMapModel mj_objectArrayWithFile:path];
    }
    return _areaArray;
}

- (NSMutableArray *)streetArray{
    if (_streetArray==nil) {
        NSString * path=[[NSBundle mainBundle] pathForResource:@"Street" ofType:@"plist"];
        _streetArray=[TSFMapModel mj_objectArrayWithFile:path];
    }
    return _streetArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.titleView=self.segment;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isershou=YES;
    [self initWithMapView];//初始化地图
    [self initWithTableView];
    [self loadData];
 
}

//行政区域房源套数
- (void)loadData{
    [_mapView removeAnnotations:_mapView.annotations];

    NSString *fromtable;
    if (isershou==YES) {//二手房
        fromtable=@"ershou";
        if (self.ershouAnnonations.count>0) {//如果二手房的标注数组不为空 直接添加
            [_mapView addAnnotations:self.ershouAnnonations];
            return;
        }
        
    } else{
        fromtable=@"chuzu";
        if (self.chuzuAnnonations.count>0) {
            [_mapView addAnnotations:self.chuzuAnnonations];
            return;
        }
        
    }

    //二手房标注数组为空 请求获取
    
    __weak typeof(self)weakSelf=self;
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    NSDictionary * param=@{@"fromtable":fromtable};
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=map&a=city_house",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
          self.houseCountArray=[HouseCountModel mj_objectArrayWithKeyValuesArray:responseObj];
            for (int i=0; i<weakSelf.areaArray.count; i++) {
                TSFMapModel * model=weakSelf.areaArray[i];
                BMKPointAnnotation * annonation=[[BMKPointAnnotation alloc]init];
                CLLocationCoordinate2D coor;
                coor.longitude=[model.longitude floatValue];
                coor.latitude=[model.latitude floatValue];
                annonation.title=model.name;
                annonation.coordinate=coor;
                
                if (isershou==YES) {//二手房
                    for (int j=0; j<weakSelf.houseCountArray.count; j++) {
                        HouseCountModel * countModel=weakSelf.houseCountArray[j];
                        if (model.ID==countModel.ID) {
                            model.house_count=countModel.house_count;
                            annonation.subtitle=countModel.house_count;//
                        }
                    }
                    [weakSelf.ershouAnnonations addObject:annonation];
                    [_mapView addAnnotations:weakSelf.ershouAnnonations];
                } else{//出租房
                    for (int j=0; j<weakSelf.houseCountArray.count; j++) {
                        HouseCountModel * countModel=weakSelf.houseCountArray[j];
                        if (model.ID==countModel.ID) {
                            model.house_count=countModel.house_count;
                            annonation.subtitle=countModel.house_count;//
                        }
                    }
                    [weakSelf.chuzuAnnonations addObject:annonation];
                    [_mapView addAnnotations:weakSelf.chuzuAnnonations];
                }
                
               
            }
            
            
        }
        
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
    }];
}



//行政区域下一级房源套数
- (void)loadStreet{
    
    NSLog(@"请求掉了多少次");
  
    NSString *fromtable;
    if (isershou==YES) {
        fromtable=@"ershou";
        if (self.ershouAnnonations1.count>0) {//街道标注数组已经存在  直接添加
            [_mapView removeAnnotations:_mapView.annotations];
            [_mapView addAnnotations:self.ershouAnnonations1];
            return;
        }
    } else{
        fromtable=@"chuzu";
        if (self.chuzuAnnonations1.count>0) {
            [_mapView removeAnnotations:_mapView.annotations];
            [_mapView addAnnotations:self.chuzuAnnonations1];
            return;
        }
    }
    //街道数据不存在  去获取
    __weak typeof(self)weakSelf=self;
    NSDictionary * param=@{@"fromtable":fromtable};
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=map&a=area_house",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            weakSelf.cityCountArray=[HouseCountModel mj_objectArrayWithKeyValuesArray:responseObj];
         
            if (isershou==YES) {
                if (weakSelf.ershouAnnonations1.count>0) {
                    [weakSelf.ershouAnnonations1 removeAllObjects];
                }
                for (int i=0; i<weakSelf.streetArray.count; i++) {//没有 就添加标注到数组
                    TSFMapModel *model=weakSelf.streetArray[i];
                    TSFAreaPointAnnotation * annonation=[[TSFAreaPointAnnotation alloc]init];
                    CLLocationCoordinate2D coor;
                    coor.longitude=[model.longitude floatValue];
                    coor.latitude=[model.latitude floatValue];
                    annonation.title=model.name;
                    annonation.coordinate=coor;
                    for (int j=0; j<weakSelf.cityCountArray.count; j++) {
                        HouseCountModel * countmodel=weakSelf.cityCountArray[j];
                        if (countmodel.ID==model.ID) {
                            annonation.subtitle=countmodel.house_count;
                        }
                    }
                    [weakSelf.ershouAnnonations1 addObject:annonation];
                }
                [_mapView removeAnnotations:_mapView.annotations];
                [_mapView addAnnotations:weakSelf.ershouAnnonations1];
            } else{
                if (self.chuzuAnnonations1.count>0) {
                    [self.chuzuAnnonations1 removeAllObjects];
                }
                for (int i=0; i<weakSelf.streetArray.count; i++) {//没有 就添加标注到数组
                    TSFMapModel *model=weakSelf.streetArray[i];
                    TSFAreaPointAnnotation * annonation=[[TSFAreaPointAnnotation alloc]init];
                    CLLocationCoordinate2D coor;
                    coor.longitude=[model.longitude floatValue];
                    coor.latitude=[model.latitude floatValue];
                    annonation.title=model.name;
                    annonation.coordinate=coor;
                    for (int j=0; j<weakSelf.cityCountArray.count; j++) {
                        HouseCountModel * countmodel=weakSelf.cityCountArray[j];
                        if (countmodel.ID==model.ID) {
                            annonation.subtitle=countmodel.house_count;
                        }
                    }
                    [self.chuzuAnnonations1 addObject:annonation];
                }
                [_mapView removeAnnotations:_mapView.annotations];
                [_mapView addAnnotations:weakSelf.chuzuAnnonations1];
            }
        
        }
        
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
    }];
    
}

- (void)initWithTableView{
    UITableView * tableView=[[UITableView alloc]init];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [tableView setTableFooterView:v];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mapView.mas_bottom).offset(0);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(kMainScreenHeight*0.6);
    }];
    self.tableView=tableView;
    [tableView registerNib:[UINib nibWithNibName:@"BaseRoomCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}


- (void)initWithMapView{//初始化地图并添加  区域标注
    _mapView = [[BMKMapView alloc]init];
    _mapView.delegate=self;
    [self.view addSubview: _mapView];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(kMainScreenHeight);
    }];
    

    [_mapView setZoomLevel:12];
    
    CLLocationCoordinate2D centercoor;
    centercoor.longitude=114.06667;
    centercoor.latitude=22.61667;
    
    [_mapView setCenterCoordinate:centercoor animated:YES];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        TSFAreaAnnonationView *newAnnotationView=(TSFAreaAnnonationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"areaAnnotation"];
        
        if (newAnnotationView==nil) {
            newAnnotationView=[[TSFAreaAnnonationView alloc]initWithAnnotation:annotation reuseIdentifier:@"areaAnnotation"];
        }
        BMKPointAnnotation* Newannotation=(BMKPointAnnotation*)annotation;
        newAnnotationView.canShowCallout = NO;
        newAnnotationView.draggable = YES;
        newAnnotationView.label1.text= Newannotation.title;
        newAnnotationView.label2.text=Newannotation.subtitle;
        return newAnnotationView;
    } else  if ([annotation isKindOfClass:[TSFAreaPointAnnotation class]]){
        StreetAnnotationView *newAnnotationView=(StreetAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"streetAnnotation"];
        
        if (newAnnotationView==nil) {
            newAnnotationView=[[StreetAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"streetAnnotation"];
        }
        
        TSFAreaPointAnnotation* Newannotation=(TSFAreaPointAnnotation*)annotation;
        newAnnotationView.canShowCallout = NO;
        newAnnotationView.draggable = YES;
        newAnnotationView.label1.text=Newannotation.title ;
        newAnnotationView.label2.text=Newannotation.subtitle;
        return newAnnotationView;
    } else{
        
        DetailAnnotationView *newAnnotationView=(DetailAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"detailAnnotation"];
        if (newAnnotationView==nil) {
              newAnnotationView=[[DetailAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"detailAnnotation"];
        }
        
        TSFXiaoQuAnnonation* Newannotation=(TSFXiaoQuAnnonation*)annotation;
        newAnnotationView.canShowCallout = NO;
        newAnnotationView.draggable = YES;
        newAnnotationView.label.text=[NSString stringWithFormat:@"%@(%@)",Newannotation.title ,Newannotation.subtitle];
        newAnnotationView.title=[NSString stringWithFormat:@"%@%@",Newannotation.title ,Newannotation.subtitle];

        return newAnnotationView;
    }
    
}

//点击标注view
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{//选中一个区域view
    
    if ([view isKindOfClass:[TSFAreaAnnonationView class]]) {//区域
        _mapView.centerCoordinate=view.annotation.coordinate;//设置地图中心点
        [_mapView removeAnnotations:_mapView.annotations];//移除地图上的所有标注
        
        [self loadStreet];//点击区域  去加载街道数据
        _mapView.zoomLevel=14;
        
       
        
    } else if ([view isKindOfClass:[StreetAnnotationView class]]){//点击街道  去获取小区数据
        _mapView.zoomLevel=16;
        NSString *fromtable;
        NSInteger index;
        if (isershou==YES) {
            index=[self.ershouAnnonations1 indexOfObject:view.annotation];
            fromtable=@"ershou";
        } else{
            index=[self.chuzuAnnonations1 indexOfObject:view.annotation];
            fromtable=@"chuzu";
        }
        
        __weak typeof(self)weakSelf=self;
       TSFMapModel * model=self.streetArray[index];
        
        NSDictionary * param=@{@"area":model.ID,
                               @"fromtable":fromtable};
        [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=map&a=xiaoqu",URLSTR] params:param success:^(id responseObj) {
            [YJProgressHUD hide];
            if (responseObj) {
                _mapView.centerCoordinate=view.annotation.coordinate;
                [_mapView removeAnnotations:_mapView.annotations];
                
                
                weakSelf.xiaoQuArray=[XiaoQuModel mj_objectArrayWithKeyValuesArray:responseObj];
                
                if (isershou==YES) {
                    if (weakSelf.ershouAnnonations2.count>0) {
                        [weakSelf.ershouAnnonations2 removeAllObjects];
                    }
                    for (int i=0; i<weakSelf.xiaoQuArray.count; i++) {
                        XiaoQuModel * model=weakSelf.xiaoQuArray[i];
                        NSArray * array;
                        if (model.jingweidu.length!=0) {
                            array=[model.jingweidu componentsSeparatedByString:@","];
                            if(array.count>=2)
                            {
                                TSFXiaoQuAnnonation * annonation=[[TSFXiaoQuAnnonation alloc]init];
                                CLLocationCoordinate2D coor;
                                coor.longitude=[array[0] floatValue];
                                coor.latitude=[array[1] floatValue];
                                annonation.coordinate=coor;
                                annonation.title=model.title;
                                annonation.subtitle=model.house_count;
                                [weakSelf.ershouAnnonations2 addObject:annonation];
                            }
                        }
                    }
                    [_mapView removeAnnotations:_mapView.annotations];
                    [_mapView addAnnotations:weakSelf.ershouAnnonations2];
 
                } else{
                    
                    if (weakSelf.chuzuAnnonations2.count>0) {
                        [weakSelf.chuzuAnnonations2 removeAllObjects];
                    }
                    for (int i=0; i<weakSelf.xiaoQuArray.count; i++) {
                        XiaoQuModel * model=weakSelf.xiaoQuArray[i];
                        NSArray * array;
                        if (model.jingweidu.length!=0) {
                            array=[model.jingweidu componentsSeparatedByString:@","];
                            if(array.count>=2)
                            {
                                TSFXiaoQuAnnonation * annonation=[[TSFXiaoQuAnnonation alloc]init];
                                CLLocationCoordinate2D coor;
                                coor.longitude=[array[0] floatValue];
                                coor.latitude=[array[1] floatValue];
                                annonation.coordinate=coor;
                                annonation.title=model.title;
                                annonation.subtitle=model.house_count;
                                [weakSelf.chuzuAnnonations2 addObject:annonation];
                            }
                        }
                    }
                    [_mapView removeAnnotations:_mapView.annotations];
                    [_mapView addAnnotations:weakSelf.chuzuAnnonations2];

                }
                
            }
           
            
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
        }];
        
    } else{
        __weak typeof(self)weakSelf=self;
        [self.houseArray removeAllObjects];
        if (isershou==YES) {//二手房
            NSInteger index=[self.ershouAnnonations2 indexOfObject:view.annotation];
            XiaoQuModel * model=self.xiaoQuArray[index];
            _xiaoqumodel=model;
            NSDictionary * param=@{@"xiaoqu":model.ID,
                                   @"fromtable":@"ershou"};
            [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
            [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=map&a=house",URLSTR] params:param success:^(id responseObj) {
                [YJProgressHUD hide];
                //弹出tableview 地图上移
                [_mapView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(-(kMainScreenHeight*0.6+64));
                }];
                
                [UIView animateWithDuration:0.5 animations:^{
                    [weakSelf.view layoutIfNeeded];
                }];

                if (responseObj) {
                    weakSelf.houseArray=[HouseModel mj_objectArrayWithKeyValuesArray:responseObj];
                    [weakSelf.tableView reloadData];
                } else{
                    [weakSelf.tableView reloadData];
                }
            
                
            } failure:^(NSError *error) {
                [YJProgressHUD hide];
                [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
                //弹出tableview 地图上移
                [_mapView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(-(kMainScreenHeight*0.6+64));
                }];
                
                [UIView animateWithDuration:0.5 animations:^{
                    [weakSelf.view layoutIfNeeded];
                }];

            }];
            
            
        } else{//租房
            __weak typeof(self)weakSelf=self;
            NSInteger index=[self.chuzuAnnonations2 indexOfObject:view.annotation];
            XiaoQuModel * model=self.xiaoQuArray[index];
            _xiaoqumodel=model;
            NSDictionary * param=@{@"xiaoqu":model.ID,
                                   @"fromtable":@"chuzu"};
            [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
            [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=map&a=house",URLSTR] params:param success:^(id responseObj) {
                [YJProgressHUD hide];
                
                //弹出tableview 地图上移
                [_mapView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(-(kMainScreenHeight*0.6+64));
                }];
                
                [UIView animateWithDuration:0.5 animations:^{
                    [weakSelf.view layoutIfNeeded];
                }];

                
                if (responseObj) {
                    weakSelf.houseArray=[HouseModel mj_objectArrayWithKeyValuesArray:responseObj];
                    [weakSelf.tableView reloadData];
                } else{
                    [weakSelf.tableView reloadData];
                }
                
                
            } failure:^(NSError *error) {
                [YJProgressHUD hide];
                [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
                //弹出tableview 地图上移
                [_mapView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(-(kMainScreenHeight*0.6+64));
                }];
                
                [UIView animateWithDuration:0.5 animations:^{
                    [weakSelf.view layoutIfNeeded];
                }];

            }];

        }
        
        
        
        
    }
    
}

-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{//地图区域改变后 会调用
    if (_mapView.zoomLevel<13) {
        
        [_mapView removeAnnotations:_mapView.annotations];
        [self loadData];
        
    } else if (_mapView.zoomLevel>13 && _mapView.zoomLevel<15){
        
        [_mapView removeAnnotations:_mapView.annotations];//移除上一次的标注
        
        [self loadStreet];//放大地图 添加标注
        
    } else{//显示小区
        
    }
 }

//单击地图空白处 会调用
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    //弹出tableview 地图下移
    [_mapView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
 
}
//双击地图调用
- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate{
    //弹出tableview 地图下移
    [_mapView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}


/**创建Menu*/
- (void)createMenu{
    
    UIView * menu=[[UIView alloc]init];
    menu.backgroundColor=[UIColor whiteColor];
    [_mapView addSubview:menu];
    
    
[menu mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.and.right.mas_equalTo(0);
    make.top.mas_equalTo(0);
    make.height.mas_equalTo(44);
}];
    
    
}

- (void)doSomethingInSegment:(UISegmentedControl *)segment
{
    CLLocationCoordinate2D centercoor;
    centercoor.longitude=114.06667;
    centercoor.latitude=22.61667;
    
    [_mapView setCenterCoordinate:centercoor animated:YES];
    _mapView.zoomLevel=12;
    
    NSInteger index=segment.selectedSegmentIndex;
    switch (index) {
        case 0:{//二手房
            isershou=YES;
        }
            break;
        default:{//租房
            isershou=NO;
        }
            break;
    }
    [self loadData];
   
}


- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.houseArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseRoomCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    HouseModel * model=self.houseArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
    cell.label1.text=model.title;
   
    cell.label4.text=_xiaoqumodel.title;
    cell.label3.textColor=ORGCOL;
    if (isershou) {
        cell.label2.text=[NSString stringWithFormat:@"%@室%@厅 %@㎡ %@",model.shi,model.ting,model.jianzhumianji,model.chaoxiang];
        NSString * zongjia=[NSString stringWithFormat:@"%@万",model.zongjia];
        NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:zongjia attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16 weight:22]}];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 weight:16] range:NSMakeRange(attrStr.length-1, 1)];
        [cell.label3 setAttributedText:attrStr];
    } else{
        cell.label2.text=[NSString stringWithFormat:@"%@室%@厅 %@㎡ %@",model.shi,model.ting,model.mianji,model.chaoxiang];
        NSString * zongjia=[NSString stringWithFormat:@"%@元/月",model.zujin];
        NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:zongjia attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16 weight:22]}];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 weight:16] range:NSMakeRange(attrStr.length-3, 3)];
        [cell.label3 setAttributedText:attrStr];
    }
    
    
    
    NSString * biaoqian=model.biaoqian;
    cell.biaoqian=biaoqian;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView * headView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header" ];
    if (!headView) {
        headView=[[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"header"];
        
        UIButton * button=[[UIButton alloc]init];
        [button setTitle:@"收起" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14 weight:20]];
        [headView addSubview:button];
        button.tag=101;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView.mas_centerY);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(30);
        }];
        
        UILabel * titleLabel=[[UILabel alloc]init];
        titleLabel.font=[UIFont systemFontOfSize:16 weight:20];
        [headView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(headView.mas_centerY);
            make.height.mas_equalTo(30);
            make.width.mas_greaterThanOrEqualTo(60);
            
        }];
        titleLabel.tag=100;
        
        UILabel * subtitleLabel=[[UILabel alloc]init];
        subtitleLabel.font=[UIFont systemFontOfSize:14 weight:16];
        [headView addSubview:subtitleLabel];
        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(15);
            make.centerY.equalTo(headView.mas_centerY).offset(0);
            make.width.mas_greaterThanOrEqualTo(60);
            make.height.mas_equalTo(30);
        }];
        subtitleLabel.tag=102;
    }
    headView.contentView.backgroundColor=[UIColor whiteColor];
    UIButton * button=(UIButton *)[headView viewWithTag:101];
    [button addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * title=(UILabel *)[headView viewWithTag:100];
    title.text=_xiaoqumodel.title;
    
    UILabel * subTitleLabel=(UILabel *)[headView viewWithTag:102];
    
    if (isershou) {
        subTitleLabel.text=[NSString stringWithFormat:@"在售%ld套房源",self.houseArray.count];
    } else{
        subTitleLabel.text=[NSString stringWithFormat:@"在租%ld套房源",self.houseArray.count];
    }
  
    return headView;
}

- (void)cancelAction:(UIButton *)button{
    //弹出tableview 地图下移
    [_mapView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HouseModel * model=self.houseArray[indexPath.row];
    /*
     */
    if (isershou) {//二手房
        HandRoomDetailVC * VC=[[HandRoomDetailVC alloc]init];
        VC.model=model;
        [self.navigationController pushViewController:VC animated:YES];
    } else{
        IDModel * idmodel=[[IDModel alloc]init];
        idmodel.ID=model.ID;
        idmodel.catid=model.catid;
        
        RentRoomDetailVC * VC=[[RentRoomDetailVC alloc]init];
        VC.model=idmodel;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

@end
