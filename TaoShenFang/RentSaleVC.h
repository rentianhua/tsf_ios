//
//  RentSaleVC.h
//  TaoShenFang
//
//  Created by YXM on 16/8/31.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HouseModel;

@interface RentSaleVC : UIViewController

typedef enum{
    RentIssueTypeGeneral=0,
    RentIssueTypeEdit
}RentIssueType;

@property (nonatomic,assign)RentIssueType type;
@property (nonatomic,strong)HouseModel *model;

@end
