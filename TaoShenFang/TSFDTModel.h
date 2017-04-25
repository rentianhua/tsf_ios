//
//  TSFDTModel.h
//  TaoShenFang
//
//  Created by YXM on 16/11/30.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSFDTModel : NSObject

@property (nonatomic,strong)NSNumber *ID;//id
@property (nonatomic,strong)NSNumber *catid;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *descrip;//description
@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)NSString *biaoqian;
@property (nonatomic,strong)NSNumber *newid;//new_id
@property (nonatomic,copy)NSString *inputtime;
@property (nonatomic,copy)NSString *updatetime;



@end
