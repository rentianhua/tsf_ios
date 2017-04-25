//
//  UserModel.h
//  TaoShenFangTest
//
//  Created by YXM on 16/8/22.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
@interface UserModel : NSObject

@property (nonatomic,copy)NSString *userid;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *password;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,copy)NSString *attention;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,copy)NSString *userpic;
@property (nonatomic,copy)NSString *modelid;
@property (nonatomic,copy)NSString *vtel;
@property (nonatomic,strong)NSNumber *zhuanjie;
@property (nonatomic,copy)NSString *ctel;
@property (nonatomic,copy)NSString *about;
@property (nonatomic,copy)NSString *realname;
@property (nonatomic,strong)UserInfoModel * info;





@end
