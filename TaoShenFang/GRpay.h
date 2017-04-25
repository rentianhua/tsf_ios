//
//  GRpay.h
//  TaoShenFang
//
//  Created by YXM on 16/10/9.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PartnerConfig.h"

//测试商品信息封装在product中，外部商品信息可根据自己的商品实际情况来定
@interface Product : NSObject{
    @private
    float _price;
    NSString * _subject;
    NSString * _body;
    NSString * _orderId;
}
@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;

@end

@interface GRpay : NSObject
+ (void)payWithProduct:(Product *)product resultBlock:(void(^)(NSString *rsultString))result;
+ (void)payWithProduct:(Product *)product notifyURL:(NSString *)notifyURL resultBlock:(void (^)(NSString *))result;
@end
