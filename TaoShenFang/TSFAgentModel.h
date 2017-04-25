//
//  TSFAgentModel.h
//  TaoShenFang
//
//  Created by YXM on 16/11/4.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TSFAgentBaseModel;

@interface TSFAgentModel : NSObject

@property (nonatomic,strong)NSNumber *userid;
@property (nonatomic,strong)NSNumber *cardnumber;
@property (nonatomic,copy)NSString *mainarea;
@property (nonatomic,copy)NSString *sfzpic;
@property (nonatomic,copy)NSString *leixing;
@property (nonatomic,copy)NSString *coname;
@property (nonatomic,copy)NSString *biaoqian;
@property (nonatomic,strong)NSNumber *dengji;
@property (nonatomic,copy)NSString *realname;
@property (nonatomic,copy)NSString *worktime;
@property (nonatomic,copy)NSString *jiav;
@property (nonatomic,copy)NSString *mainareaids;
@property (nonatomic,strong)NSNumber *chengjiao_count;
@property (nonatomic,strong)NSNumber *weituo_count;
@property (nonatomic,strong)NSNumber *daikan_count;
@property (nonatomic,strong)TSFAgentBaseModel *base;

@end
