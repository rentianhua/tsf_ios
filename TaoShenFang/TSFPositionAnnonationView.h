//
//  TSFPositionAnnonationView.h
//  TaoShenFang
//
//  Created by YXM on 16/10/21.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@interface TSFPositionAnnonationView : BMKAnnotationView

@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,copy)NSString * imgName;

///标注view中心坐标.
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
