//
//  SearchResultVC.m
//  TaoShenFang
//
//  Created by YXM on 16/9/29.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "SearchResultVC.h"
#import "ZYWHttpEngine.h"
#import "OtherHeader.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <Masonry.h>

@interface SearchResultVC()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate,UITextFieldDelegate,BMKMapViewDelegate, BMKPoiSearchDelegate>{
    BMKMapView * _mapView;
    BMKPoiSearch* _poisearch;
    NSString * _cityText;
    NSString * _keyText;
    int curPage;

}

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray * resultArray;

@property (nonatomic,strong)NSMutableArray * annotations;

@property (nonatomic,strong)UITextField * textField;

@property (nonatomic,strong)UIButton * cancelbutton;

@end

@implementation SearchResultVC

- (NSMutableArray *)annotations{
    if (_annotations==nil) {
        _annotations=[NSMutableArray array];
    }
    return _annotations;
}
- (NSMutableArray *)resultArray{
    if (_resultArray==nil) {
        _resultArray=[NSMutableArray array];
    }
    return _resultArray;
}

- (UIButton *)cancelbutton{
    if (_cancelbutton==nil) {
        _cancelbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        [_cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelbutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_cancelbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelbutton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelbutton;
}
- (UITextField *)textField{
    if (_textField==nil) {
        _textField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth-60, 30)];
        _textField.placeholder=@"请输入小区名";
        
        _textField.backgroundColor=[UIColor lightGrayColor];
        _textField.layer.cornerRadius=3;
        _textField.layer.masksToBounds=YES;
        _textField.font=[UIFont systemFontOfSize:14];
        [_textField becomeFirstResponder];
        [_textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        _textField.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
        _textField.leftViewMode=UITextFieldViewModeAlways;
        _textField.delegate=self;
 
        _textField.returnKeyType=UIReturnKeyDone;
    }
    return _textField;
}

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
        UIView * view=[[UIView alloc]initWithFrame:CGRectZero];
        _tableView.tableFooterView=view;
    }
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.titleView=self.textField;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.cancelbutton];
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:view];
    [self.view addSubview:self.tableView];
    
    
    _mapView=[[BMKMapView alloc]init];
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    _mapView.isSelectedAnnotationViewFront = YES;
    [_mapView setZoomLevel:13];
    _poisearch=[[BMKPoiSearch alloc]init];
    _poisearch.delegate=self;
    
}
- (void)poijisnsuo{
    
    if (self.resultArray.count>0) {
        [self.resultArray removeAllObjects];
    }
    if (self.annotations.count >0) {
        [self.annotations removeAllObjects];
    }
    curPage=0;
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = curPage;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city=_cityText;
    citySearchOption.keyword = _keyText;
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        
    }
    else
    {
        
    }
    
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
 
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [self.annotations addObject:item];
            [self.resultArray addObject:poi.name];
        }
        [self.tableView reloadData];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        
    } else {
        // 各种情况的判断。。。
    }
}

- (void)tapAction:(UITapGestureRecognizer *)reconizer{
    SearchResultVC * vc=[[SearchResultVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.resultArray.count==0) {
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    } else{
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    }
    return self.resultArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.textLabel.textColor=[UIColor grayColor];
    
    if (indexPath.row<=self.resultArray.count-1) {
      cell.textLabel.text=self.resultArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.annotations.count==0) {
        return;
    }
    BMKPointAnnotation* item=self.annotations[indexPath.row];
    
    NSString * coorStr=[NSString stringWithFormat:@"%f,%f",item.coordinate.longitude,item.coordinate.latitude];
    self.kwdsBlock(coorStr);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_textField resignFirstResponder];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}
- (void)cancel:(UIButton *)button{
    self.kwdsBlock(@"");
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark---------------UITextFieldDelegate--------
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    self.kwdsBlock(@"");
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}
- (void)textFieldEditChanged:(UITextField *)textField{
    _cityText=@"深圳";
    _keyText=textField.text;
    [self poijisnsuo];//花 龙珠
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
