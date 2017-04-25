//
//  SelectCoordinatesVC.h
//  TaoShenFang
//
//  Created by YXM on 16/9/28.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnToSaleBlock)(NSString * coorStr);

@interface SelectCoordinatesVC : BaseViewController

@property (nonatomic,copy)ReturnToSaleBlock coorBlock;

@end
