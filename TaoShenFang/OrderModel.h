//
//  OrderModel.h
//  TaoShenFang
//
//  Created by YXM on 16/9/22.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderHouseModel.h"
@interface OrderModel : NSObject

@property (nonatomic,copy)NSString *ID;//
@property (nonatomic,copy)NSString *catid;
@property (nonatomic,copy)NSString *typeID;//typeid
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *yuyuedate;
@property (nonatomic,copy)NSString *yuyuetime;
@property (nonatomic,copy)NSString *lock;
@property (nonatomic,copy)NSString *fromtable;//房源表名
@property (nonatomic,copy)NSString *fromid;//房源ID
@property (nonatomic,copy)NSString *zhuangtai;

@property (nonatomic,strong)OrderHouseModel * house;

@end
