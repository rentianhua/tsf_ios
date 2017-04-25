//
//  Chat_Model.h
//  Chat_V
//
//  Created by BOBO on 16/12/2.
//  Copyright © 2016年 BOBO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chat_Model : NSObject

@property (nonatomic, assign) BOOL fromMe;

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *from_uid;
@property (nonatomic,copy)NSString *to_uid;
@property (nonatomic,copy)NSString *inputtime;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *userpic;
@property (nonatomic,copy)NSString *realname;

@property (nonatomic,strong)NSNumber * yidu;
@property (nonatomic,strong)NSNumber * weidu_sum;

/*"id": "6",
 "from_uid": "151",
 "to_uid": "150",
 "from_status": "1",
 "to_status": "1",
 "content": "测试",
 "inputtime": "1482409522",
 "ids": 301,
 "userpic": "",
 "realname": "黄福林"*/


+ (NSArray *)demoData;
@end
