//
//  BrokerSaleHouseVC.h
//  TaoShenFang
//
//  Created by YXM on 16/8/31.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HouseModel;

@interface BrokerSaleHouseVC : UIViewController

typedef enum{
    BrokerIssueTypeGeneral=0,
    BrokerIssueTypeEdit
}BrokerIssueType;

@property (nonatomic,strong)HouseModel * model;

@property (nonatomic,assign)BrokerIssueType type;

@end
