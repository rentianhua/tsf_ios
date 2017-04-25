//
//  NewHouseListController.h
//  TaoShenFangTest
//
//  Created by YXM on 16/7/29.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "BaseViewController.h"

@class TSFSearchModel;

@interface NewHouseListController : BaseViewController

@property (nonatomic,copy)NSString * kwds;

@property (nonatomic,strong)TSFSearchModel * searchmodel;


@end
