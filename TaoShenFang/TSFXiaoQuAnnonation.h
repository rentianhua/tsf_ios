//
//  TSFXiaoQuAnnonation.h
//  TaoShenFang
//
//  Created by YXM on 16/10/11.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@interface TSFXiaoQuAnnonation : NSObject<BMKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *titlelable;
- (NSString *)subtitle;
/////该点的坐标
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
