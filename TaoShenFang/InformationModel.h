//
//  InformationModel.h
//  TaoShenFangTest
//
//  Created by YXM on 16/8/20.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationModel : NSObject


@property (nonatomic,strong)NSNumber *ID;
@property (nonatomic,strong)NSNumber *typeID;
@property (nonatomic,strong)NSNumber *catid;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)NSNumber *posid;
@property (nonatomic,copy)NSString *thumb;
@property (nonatomic,copy)NSString *descrip;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *url;
@property (nonatomic,strong)InformationModel * data;







@end
