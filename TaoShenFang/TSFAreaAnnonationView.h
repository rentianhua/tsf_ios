//
//  TSFAreaAnnonationView.h
//  TaoShenFang
//
//  Created by YXM on 16/10/11.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件


@interface TSFAreaAnnonationView : BMKAnnotationView
@property (nonatomic,strong)UIView * contentView;
@property (nonatomic,strong)UILabel * label1;
@property (nonatomic,strong)UILabel * label2;
///标注view中心坐标.
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;



@end
