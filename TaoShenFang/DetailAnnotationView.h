//
//  DetailAnnotationView.h
//  TaoShenFang
//
//  Created by YXM on 16/10/10.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>



@interface DetailAnnotationView : BMKAnnotationView

@property (nonatomic,strong)UIImageView * imgView;

@property (nonatomic,strong)UILabel * label;

@property (nonatomic,copy)NSString * title;

@end
