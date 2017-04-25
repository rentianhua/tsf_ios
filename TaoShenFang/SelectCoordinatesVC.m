//
//  SelectCoordinatesVC.m
//  TaoShenFang
//
//  Created by YXM on 16/9/28.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "SelectCoordinatesVC.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "OtherHeader.h"
#import <Masonry.h>
#import "SearchResultVC.h"
#import "TSFIssueAnnotationView.h"


#define NAVBTNW 20

@interface SelectCoordinatesVC ()<BMKMapViewDelegate, BMKGeoCodeSearchDelegate,UITextFieldDelegate>
{
    BMKMapView * _mapView;
    BMKPointAnnotation* pointAnnotation;
    NSString * lontext;//纬度
    NSString * latText;//精度
    BMKGeoCodeSearch* _geocodesearch;
}
@property (nonatomic,strong)UITextField * textField;
@property (nonatomic,strong)UILabel * placeholderLabel;
@property (nonatomic,strong)SearchResultVC * resultVC;
@property (nonatomic,strong)UIButton * leftNavBtn;


@end

@implementation SelectCoordinatesVC{
    BOOL didConstraints;
}

- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

- (UITextField *)textField{
    if (_textField==nil) {
        _textField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth-80, 30)];
        _textField.delegate=self;
        _textField.backgroundColor=[UIColor lightGrayColor];
        _textField.layer.masksToBounds=YES;
        _textField.layer.cornerRadius=3;
        UIView * leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 18, 18)];
        [leftView addSubview:imgView];
        imgView.image=[UIImage imageNamed:@"homepage_search_icon"];
        _textField.leftView=leftView;
        _textField.leftViewMode=UITextFieldViewModeAlways;
        [_textField addSubview:self.placeholderLabel];
        
        UITapGestureRecognizer * singleReconizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        singleReconizer.numberOfTapsRequired=1;
        [_textField addGestureRecognizer:singleReconizer];
    }
    return _textField;
}

- (UILabel *)placeholderLabel{
    if (_placeholderLabel==nil) {
        _placeholderLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, kMainScreenWidth-110, 30)];
        _placeholderLabel.text=@"请输入小区名称";
        _placeholderLabel.textColor=[UIColor whiteColor];
        _placeholderLabel.font=[UIFont systemFontOfSize:14];
        _placeholderLabel.userInteractionEnabled=YES;
    }
    return _placeholderLabel;
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    self.navigationController.navigationBarHidden=NO;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
   // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    
    __weak typeof(self)weakSelf=self;
    weakSelf.resultVC.kwdsBlock=^(NSString *coorStr){
        
        
        if (coorStr.length==0) {
            // 清楚屏幕中所有的annotation
            NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
            [_mapView removeAnnotations:array];
            return;
        } else{
            NSArray * coorArr=[coorStr componentsSeparatedByString:@","];
            latText =coorArr[0];
            lontext=coorArr[1];
        }
        
        [self reversegeocode];
    };
    
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.titleView=self.textField;
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:view];
    _mapView=[[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    [_mapView setZoomLevel:13];
    
    CLLocationCoordinate2D coor=CLLocationCoordinate2DMake(22.61667,114.06667);
    _mapView.centerCoordinate=coor;
    
    
    SearchResultVC * vc=[[SearchResultVC alloc]init];
    
    self.resultVC=vc;

}

//反检索 珍珠花苑 南
- (void)reversegeocode{
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate=self;
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    if (lontext != nil && latText != nil) {
        pt = (CLLocationCoordinate2D){[lontext floatValue], [latText floatValue]};
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];//判断检索是否成功 这个必须要有
}
//反向地理编码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
    }
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation南
    
    NSString *AnnotationViewID = @"renameMark";
    TSFIssueAnnotationView *annotationView = (TSFIssueAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[TSFIssueAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annotationView.canShowCallout=NO;
        [annotationView.imgView setImage:[UIImage imageNamed:@"ic_location"]];

    }
    return annotationView;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    NSString * string=[NSString stringWithFormat:@"%f,%f",view.annotation.coordinate.longitude,view.annotation.coordinate.latitude];
    self.coorBlock(string);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    NSString * string=[NSString stringWithFormat:@"%f,%f",coordinate.longitude,coordinate.latitude];
    self.coorBlock(string);
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

- (void)tapAction:(UITapGestureRecognizer *)reconizer{
    [self.navigationController pushViewController:self.resultVC animated:YES];
}
- (void)back:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
