//
//  TSFUploadContractVC.h
//  TaoShenFang
//
//  Created by YXM on 17/1/11.
//  Copyright © 2017年 RA. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, UPLoadType) {
    UPLoadTypeIDCard = 0,
    UPLoadTypeContract
};

@class HouseModel;

@interface TSFUploadContractVC : BaseViewController

@property (nonatomic,strong)NSMutableArray * cards;

@property (nonatomic,strong)HouseModel * seleModel;

@property (nonatomic,assign)UPLoadType type;

@property (nonatomic) int maxImagesCount;
@end
