//
//  XMYExtensionConfig.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/22.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "XMYExtensionConfig.h"
#import "HouseModel.h"
//#import "PicModel.h"
#import "TSFPicsModel.h"
#import "InformationModel.h"
#import "OrderModel.h"
#import "OrderHouseModel.h"
//#import "IssueModel.h"
#import "TSFPicsModel.h"
#import "UploadImgModel.h"
#import "TSFMapModel.h"
#import "XiaoQuModel.h"
#import "HouseCountModel.h"
#import "TSFCommentModel.h"
#import "TSFAreaModel.h"
#import "TSFRentMangerModel.h"
#import "TSFSeeHouseModel.h"
#import "TSFPayModel.h"
#import "YSFYhqModel.h"
@implementation XMYExtensionConfig

+ (void)load
{
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"descrip":@"description",
                 @"ID":@"id",
                 @"templat":@"template",
                 @"typeID":@"typeid"
                 
                 };
        
    }];
    
    
    [TSFPicsModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"pics":@"TSFPicsModel",
                 @"loupantupian":@"TSFPicsModel",
                 @"weizhitu":@"TSFPicsModel",
                 @"yangbantu":@"TSFPicsModel",
                 @"shijingtu":@"TSFPicsModel",
                 @"xiaoqutu":@"TSFPicsModel",
                 @"uploadImgs":@"UploadImgModel"
                 
                 };
 
    }];
    
//    [IssueModel mj_setupObjectClassInArray:^NSDictionary *{
//        return @{
//                 @"pics":@"TSFPicsModel",
//                 };
//        
//    }];
    //
    [TSFAreaModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"area":@"TSFAreaModel"};
    }];
       
    
    [HouseModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"daikan":@"TSFSeeHouseModel",
                 @"dongtai":@"TSFDTModel"};
    }];
    
}





@end
