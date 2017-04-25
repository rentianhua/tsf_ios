//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h


#import "Order.h"

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088421264539813"
//收款支付宝账号
#define SellerID  @"ruianxingye888@126.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"kzjlvhs3a4jgsm08fmnjgt0ggmp9b2pr"

#define APPID @"2016072301657641"

#define PartnerPrivKey @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBANPTGHR7P3aPng0zA841Gh6uE19hesCd6NlOGBZKeXzTq5PLTPA0tGGAfIpqx1ze+hWsz5On/P2fBILF3U23S1u7wP/Yem1Ci2T4DYx5AZZe6xz927nNsnJO7vrUohl25/tXuSn/LaY01RABabvt1p5+a50uAqCS0FkapzqPebCFAgMBAAECgYEAkjPXYz5WFU0XN+EINWGtf5OCx4iOozfaqXIfafNJWwD2IfJmTjzya4G1dAwzQkSctC0ssKt4EM2a3XAYSTXECnBb4zJ7ppOhI8+OOPfScEnalCqq7XAC33bcgG17PHLfyAqesh0f+o5uwVptXpGOjX7Cu0qdYCjn3VAybVgi1kECQQD8C6T16v+mj8E9oG2p7IkuZmywqF8zc4dNY5lK7tjk+BnaFPe3Xy8uUZUYEfo11Rg3pjGYlT6/djaNgJm3/VNZAkEA1yXmy8sJ9ix4+QUKODRTN9BpgYh4ummSFgsP/DRMtA0LZCK83s/Kgu9fjuxVo/cSOjqAuywOZ1AYBkDkCfp9DQJARvO8N2I1H51eR8vusyQcJgy9UinDywcdsqJ0F80PD73sASFf7qYD8SUUNJdy+U6Ip7nIQmzZIirUBpeKLmpI2QJBAKmrtkvZn82IXQ7lrp2MhmRp9Aq3eZ5pS1AfAUhAZo1IDEe4LYL6FBcWeCHat99LJhDNul/h6qoHPCsSWcSUyrECQQDKnNGXtAwGQLYxIYIEHiWbmidKuJZoG8XgohLLvUGOx7uBDbU4e4TohyffdGJ9uZqF2v1OCtYLhqu/O56oCnGE"

#define kNotifyURL @"http://www.taoshenfang.com/index.php?g=Api&m=Api&a=app_return_url"

#define kAppScheme @"alitaoshenfang"



#endif
