//
//  AttentionModel.h
//  TaoShenFang
//
//  Created by YXM on 16/9/26.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HouseModel.h"
@interface AttentionModel : NSObject

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *catid;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *fromtable;
@property (nonatomic,copy)NSString *userid;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)HouseModel * house;


@end
