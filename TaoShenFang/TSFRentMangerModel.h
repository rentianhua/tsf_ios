//
//  TSFRentMangerModel.h
//  TaoShenFang
//
//  Created by YXM on 16/11/10.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSFRentMangerModel : NSObject

@property (nonatomic,strong)NSNumber *ID;
@property (nonatomic,strong)NSNumber *catid;

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,assign)NSInteger inputtime;
@property (nonatomic,assign)NSInteger updatetime;
@property (nonatomic,copy)NSString *zujinrange;
@property (nonatomic,copy)NSString *chenghu;
@property (nonatomic,copy)NSString *area;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *province;
@property (nonatomic,copy)NSString *shi;
@property (nonatomic,copy)NSString *zulin;
@property (nonatomic,copy)NSString *qiwangts;
@property (nonatomic,strong)NSNumber *lock;
@property (nonatomic,copy)NSString *jjrid;
@property (nonatomic,copy)NSString *province_name;
@property (nonatomic,copy)NSString *city_name;
@property (nonatomic,copy)NSString *area_name;

@property (nonatomic,copy)NSString *zongjiarange;


@end
