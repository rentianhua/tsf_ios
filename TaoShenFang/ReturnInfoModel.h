//
//  ReturnInfoModel.h
//  TaoShenFang
//
//  Created by YXM on 16/10/27.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSFPayModel.h"

@interface ReturnInfoModel : NSObject

@property (nonatomic,strong)NSNumber *success;
@property (nonatomic,copy)NSString *info;
@property (nonatomic,strong)TSFPayModel * result;


@end
