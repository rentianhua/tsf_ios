//
//  SaleHouseVC.h
//  TaoShenFang
//
//  Created by YXM on 16/8/29.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HouseModel;

@interface SaleHouseVC : UIViewController

typedef enum{
    IssueTypeGeneral=0,
    IssueTypeEdit
}IssueType;



@property (nonatomic,strong)HouseModel * model;

@property (nonatomic,assign)IssueType type;


@end
