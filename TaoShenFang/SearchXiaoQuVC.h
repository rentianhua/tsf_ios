//
//  SearchXiaoQuVC.h
//  TaoShenFang
//
//  Created by YXM on 16/10/25.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnXiaoqu)(NSString * xiaoquname);

@interface SearchXiaoQuVC : BaseViewController

@property (nonatomic,copy)NSString *area;

@property (nonatomic,copy)ReturnXiaoqu xiaoquBlock;

@end
