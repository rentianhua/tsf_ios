//
//  XMYMapViewCell.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/19.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "XMYMapViewCell.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface XMYMapViewCell()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView * _mapView;
    BMKPointAnnotation* pointAnnotation;
    NSString * lontext;//纬度
    NSString * latText;//精度
    BMKGeoCodeSearch* _geocodesearch;
}

@property(nonatomic,strong)UIView*lineView;

@end
@implementation XMYMapViewCell

-(UIView*)lineView{
    
    if(_lineView==nil) {
        
        _lineView= [[UIView alloc]init];
        
        _lineView.backgroundColor= [UIColor lightGrayColor]; //颜色可以自己调
        
        _lineView.alpha=0.3; // 透明度可以自己调
        
    }
    
    return _lineView;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        _mapView=[[BMKMapView alloc]init];
        _mapView.delegate=self;
        [self.contentView addSubview:_mapView];
        [_mapView setZoomLevel:14];
        _mapView.userInteractionEnabled=NO;
        
        UITapGestureRecognizer * singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingle:)];
        singleTap.numberOfTapsRequired=1;
        [_mapView addGestureRecognizer:singleTap];
        
        [self.contentView addSubview:self.lineView];

    }
    return self;
}

- (void)setCoordinateStr:(NSString *)coordinateStr
{
    _coordinateStr=coordinateStr;
    if (_coordinateStr.length==0) {
        return;
    } else{
        NSArray * coorArr=[coordinateStr componentsSeparatedByString:@","];
        latText =coorArr[0];
        lontext=coorArr[1];
    }
    
    [self reversegeocode];
}
//反检索
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
    //普通annotation

        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
            // 设置可拖拽
            annotationView.draggable = YES;
        }
        return annotationView;

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat margn=10;
    _mapView.frame=CGRectMake(margn, margn, self.contentView.bounds.size.width-margn*2, self.contentView.bounds.size.height-margn*2);
    
    
    //设置分割线的frame
    
    CGFloat lineX =self.textLabel.frame.origin.x;
    
    CGFloat lineH =1;
    
    CGFloat lineY =CGRectGetHeight(self.frame) - lineH;
    
    CGFloat lineW =CGRectGetWidth(self.frame) - lineX;
    
    self.lineView.frame=CGRectMake(lineX,lineY, lineW, lineH);
}

- (void)handleSingle:(UIGestureRecognizer *)recognizer
{
    if ([_delegate respondsToSelector:@selector(xMYMapViewCellPushToMap)]) {
        [_delegate xMYMapViewCellPushToMap];
    }
 
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setHidenLine:(BOOL)hidenLine{
    
    _hidenLine= hidenLine;
    
    self.lineView.hidden= hidenLine;
    
}




@end
