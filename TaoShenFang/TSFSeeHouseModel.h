//
//  TSFSeeHouseModel.h
//  TaoShenFang
//
//  Created by YXM on 16/11/17.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSFSeeHouseModel : NSObject

@property (nonatomic,strong)NSNumber *ID;
@property (nonatomic,strong)NSNumber *catid;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *lock;
@property (nonatomic,copy)NSString *realname;
@property (nonatomic,copy)NSString *yuyuedate;
@property (nonatomic,copy)NSString *yuyuetime;


@end
