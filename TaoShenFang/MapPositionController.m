//
//  MapPositionController.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/19.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "MapPositionController.h"
#import "OtherHeader.h"
#import <Masonry.h>
#import "TSFMapButton.h"
#import "TSFMapPostionCell.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "LatAndLonModel.h"
#import "TSFIssueAnnotationView.h"
#import "TSFAreaPointAnnotation.h"


#define BOTTOMH 50
#define NAVBTNW 20
@interface MapPositionController ()<BMKMapViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BMKPoiSearchDelegate>
{
    BMKMapView * _mapView;
    TSFAreaPointAnnotation* _pointAnnotation;
    NSInteger selectIndex;
    NSInteger num;
    
    BMKGeoCodeSearch* _geocodesearch;
    BMKPoiSearch* _poisearch;
    NSString * _kwds;
}

@property (nonatomic,strong)NSArray * array;
@property (nonatomic,strong)NSArray * imgArray;
@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)NSArray * normal_Array;
@property (nonatomic,strong)NSArray * select_Array;
@property (nonatomic,strong)NSMutableArray * selectIndexArr;//记录上次选中的


@property (nonatomic,strong)NSMutableArray * annonations;

@property (nonatomic,strong)UIButton * leftNavBtn;

@end

@implementation MapPositionController

- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}
- (NSMutableArray *)annonations{
    if (_annonations==nil) {
        _annonations =[NSMutableArray array];
    }
    return _annonations;
}

- (NSMutableArray *)selectIndexArr{
    if (_selectIndexArr==nil) {
        _selectIndexArr=[NSMutableArray array];
    }
    return _selectIndexArr;
}
- (NSArray *)normal_Array{
    if (_normal_Array==nil) {
        _normal_Array=@[@"map_icon_bank_normal",@"map_icon_bus_normal",@"map_icon_eating_normal",@"map_icon_education_normal",@"map_icon_game_normal",@"map_icon_hospital_normal",@"map_icon_shopping_normal",@"map_icon_sport_normal",@"map_icon_subway_normal"];
    }
    return _normal_Array;
}
- (NSArray *)select_Array{
    if (_select_Array==nil) {
        _select_Array=@[@"map_icon_bank_selected",@"map_icon_bus_selected",@"map_icon_eating_selected",@"map_icon_education_selected",@"map_icon_game_selected",@"map_icon_hospital_selected",@"map_icon_shopping_selected",@"map_icon_sport_selected",@"map_icon_subway_selected"];
    }
    return _select_Array;
}

- (NSArray *)imgArray{
    if (_imgArray==nil) {
        _imgArray=[NSArray arrayWithObjects:@"map_pin_icon_bank",@"map_pin_icon_transportation",@"map_pin_icon_subway",@"map_pin_icon_education",@"map_pin_icon_hospital",@"map_pin_icon_entertainment",@"map_pin_icon_shopping",@"map_pin_icon_sport",@"map_pin_icon_restaraunt", nil];
    }
    return _imgArray;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poisearch.delegate=self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _poisearch.delegate=self;
}

- (NSArray *)array
{
    if (_array==nil) {
        _array=[NSArray arrayWithObjects:@"银行",@"公交",@"地铁",@"教育",@"医院",@"休闲",@"购物",@"健身",@"美食", nil];
    }
    return _array;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    
    self.navigationItem.title=@"位置及周边";
   
    selectIndex=-1;
    
    _mapView=[[BMKMapView alloc]init];
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-BOTTOMH);
    }];
    
    
    //设置地图缩放级别
    [_mapView setZoomLevel:14];
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
    
    _pointAnnotation=[[TSFAreaPointAnnotation alloc]init];
    CLLocationCoordinate2D coor=(CLLocationCoordinate2D){0,0};
    if ([_coorstr containsString:@","]) {
        NSArray * array=[_coorstr componentsSeparatedByString:@","];
        if (array[1]!=nil && array[0]!=nil) {
            coor=(CLLocationCoordinate2D){[array[1] floatValue],[array[0] floatValue]};
        }
    }
    _pointAnnotation.coordinate=coor;
    
    [_mapView addAnnotation:_pointAnnotation];
    _mapView.centerCoordinate=_pointAnnotation.coordinate;
    
    
    _poisearch=[[BMKPoiSearch alloc]init];
    
      [self initCollectionView];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[TSFAreaPointAnnotation class]]) {
        BMKPinAnnotationView * annotationView=(BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        if (!annotationView) {
            annotationView=[[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
        }
        return annotationView;
    }  else{
        TSFIssueAnnotationView * annotationView=(TSFIssueAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"anno"];
        if (!annotationView) {
            annotationView=[[TSFIssueAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"anno"];
        }
         annotationView.imgView.image=[UIImage imageNamed:@"ic_location"];
    
        annotationView.imgView.image=[UIImage imageNamed:self.imgArray[selectIndex]];
    
        return annotationView;
    }
}


// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}

- (void)initCollectionView {
    UICollectionViewFlowLayout * collectionLayout=[[UICollectionViewFlowLayout alloc]init];
    collectionLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60) collectionViewLayout:collectionLayout];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(BOTTOMH);
    }];
    [_collectionView registerNib:[UINib nibWithNibName:@"TSFMapPostionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark----UICollectionViewDataSource---
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TSFMapPostionCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
        if (selectIndex==indexPath.row) {//如果包含
            [cell.imgView setImage:[UIImage imageNamed:self.select_Array[indexPath.row]]];
            
        } else{
            [cell.imgView setImage:[UIImage imageNamed:self.normal_Array[indexPath.row]]];
        }
    
    
    cell.label.text=self.array[indexPath.row];
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
#pragma mark---UICollectionViewFlowLayout------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(44, 44);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 1, 10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    selectIndex=indexPath.row;
    _kwds=self.array[indexPath.row];
    
    
    
    
    BMKNearbySearchOption * nearbySearchOption=[[BMKNearbySearchOption alloc]init];
    if ([_coorstr componentsSeparatedByString:@","]) {
        NSArray * array=[_coorstr componentsSeparatedByString:@","];
        CLLocationCoordinate2D coor=(CLLocationCoordinate2D ){0,0};
        if (array[0]!=nil && array[1]!=nil) {
            coor=(CLLocationCoordinate2D ){[array[1] floatValue],[array[0] floatValue]};
        }
        nearbySearchOption.location=coor;
        nearbySearchOption.keyword=_kwds;
        nearbySearchOption.radius=10000;
        BOOL flag=[_poisearch poiSearchNearBy:nearbySearchOption];
 
        if(flag)
        {
        
            NSLog(@"城市内检索发送成功");
        }
        else
        {
        
            NSLog(@"城市内检索发送失败");
        }

    }
    
    [collectionView reloadData];
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    
    
    NSArray * array=[NSArray arrayWithArray:_mapView.annotations];
    if (array.count>0) {
        [_mapView removeAnnotations:_mapView.annotations];
    }
    array=[NSArray arrayWithArray:_mapView.overlays];
    if (array.count>0) {
        [_mapView removeOverlays:_mapView.overlays];
    }
    
    
    if (errorCode==BMK_SEARCH_NO_ERROR) {
        NSMutableArray * annotations=[NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<poiResult.poiInfoList.count; i++) {
            BMKPoiInfo * poi=[poiResult.poiInfoList objectAtIndex:i];
            BMKPointAnnotation * item=[[BMKPointAnnotation alloc]init];
            item.coordinate=poi.pt;
            item.title=poi.name;
            [annotations addObject:item];
        }
        [_mapView addAnnotation:_pointAnnotation];
        [_mapView addAnnotations:annotations];

    } else{
        [_mapView addAnnotation:_pointAnnotation];
    
    }


}

- (void)pop:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}







@end
