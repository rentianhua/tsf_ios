//
//  BorkerModel.h
//  TaoShenFangTest
//
//  Created by YXM on 16/7/29.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;

@interface BorkerModel : NSObject

@property (nonatomic,strong)NSNumber *userid;
@property (nonatomic,strong)NSNumber *cardnumber;
@property (nonatomic,copy)NSString *mainarea;//

@property (nonatomic,copy)NSString *sfzpic;//
@property (nonatomic,copy)NSString *leixing;//

@property (nonatomic,copy)NSString *coname;//
@property (nonatomic,copy)NSString *biaoqian;//

@property (nonatomic,copy)NSString *dengji;//
@property (nonatomic,copy)NSString *realname;//
@property (nonatomic,copy)NSString *worktime;//

@property (nonatomic,strong)UserModel * info;

@property (nonatomic,copy)NSNumber *comm_count;
@property (nonatomic,copy)NSNumber *fb_rate;
@property (nonatomic,strong)NSNumber *chengjiao_count;
@property (nonatomic,strong)NSNumber *weituo_count;
@property (nonatomic,strong)NSNumber *daikan_count;
@end
