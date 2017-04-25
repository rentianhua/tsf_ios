//
//  TSFPayModel.h
//  TaoShenFang
//
//  Created by YXM on 16/11/18.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSFPayModel : NSObject

@property (nonatomic,strong)NSNumber * house_id;
@property (nonatomic,strong)NSNumber * userid;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,assign)float jine;

@property (nonatomic,copy)NSString *order_no;
@property (nonatomic,copy)NSString *addtime;
@property (nonatomic,strong)NSNumber *ID;

@property (nonatomic,copy)NSString *pay_status;
@property (nonatomic,copy)NSString *trade_no;
@property (nonatomic,copy)NSString *paytime;
@property (nonatomic,copy)NSString *buyer_email;

@property (nonatomic,copy)NSString *coupon_id;//优惠券id
@property (nonatomic,copy)NSString *coupon_name;
@property (nonatomic,copy)NSString *difu;
@property (nonatomic,assign)float shifu;
@property (nonatomic,copy)NSString *buyname;
@property (nonatomic,copy)NSString *buytel;
@property (nonatomic,copy)NSString *inputtime;
@property (nonatomic,copy)NSString *trade_status;
@property (nonatomic,copy)NSNumber *isused;
@property (nonatomic,copy)NSString *house_title;
@property (nonatomic,copy)NSString *des;


@end
