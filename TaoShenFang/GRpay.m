//
//  GRpay.m
//  PayTest
//
//  Created by notbadboy on 14/12/29.
//  Copyright (c) 2014年 hylapp.com. All rights reserved.
//

#import "GRpay.h"
#import <UIKit/UIKit.h>
#import "Order.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation Product
@end

@interface GRpay ()

@property (nonatomic, copy)void (^resultBlock)(NSString *resultString);
@end
@implementation GRpay

+ (void)payWithProduct:(Product *)product notifyURL:(NSString *)notifyURL resultBlock:(void (^)(NSString *))result
{
    
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = APPID;
    NSString *privateKey = PartnerPrivKey;
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    //mobile.securitypay.pay
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    order.sign_type = @"RSA";
    
   
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    //order.biz_content.partner_id=PartnerID;
    order.biz_content.seller_id=SellerID;
    order.biz_content.product_code =@"QUICK_MSECURITY_PAY";
    order.biz_content.total_amount =[NSString stringWithFormat:@"%.2f", product.price];//商品价格
    order.biz_content.subject = product.subject;
    order.biz_content.body = @"我是测试数据";
    
    order.biz_content.out_trade_no =product.orderId; //订单ID（由商家自行制定）
    
    // NOTE: 支付版本
    order.version = @"1.0";
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];

    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
    
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = kAppScheme;
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            NSLog(@"我是订单提交界面 ：reslut = %@",resultDic);
            
            NSInteger resultStatus=[resultDic[@"resultStatus"] integerValue];
            
            //订单号，支付状态码
            
            NSNotification * notices=[NSNotification notificationWithName:@"pay" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices];
            
            
            NSNotification * notices1=[NSNotification notificationWithName:@"coupon" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices1];
            
            NSNotification * notices2=[NSNotification notificationWithName:@"order" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices2];
            
            NSNotification * notices3=[NSNotification notificationWithName:@"yhq" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices3];

            
            
            if (resultStatus==9000) {
               
                //支付成功
            }  else if (resultStatus==8000){

                 //               returnStr=@"网络连接出错";
            } else if (resultStatus==4000){
                //                returnStr=@"订单支付失败";
            } else if (resultStatus==6001){
                //                returnStr=@"订单取消";
                
            } else if (resultStatus==6002){
                //                returnStr=@"网络连接出错";
            }
            
            
        }];
    }
}
+ (void)payWithProduct:(Product *)product resultBlock:(void (^)(NSString *))result
{
    [self payWithProduct:product notifyURL:kNotifyURL resultBlock:result];
}
@end
