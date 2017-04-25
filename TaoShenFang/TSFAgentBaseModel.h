//
//  TSFAgentBaseModel.h
//  TaoShenFang
//
//  Created by YXM on 16/11/4.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSFAgentBaseModel : NSObject

@property (nonatomic,copy)NSString *username;
@property (nonatomic,strong)NSNumber *sex;
@property (nonatomic,copy)NSString *about;
@property (nonatomic,copy)NSString *regdate;
@property (nonatomic,copy)NSString *vtel;
@property (nonatomic,copy)NSString *ctel;
@property (nonatomic,copy)NSString *userpic;

@end
