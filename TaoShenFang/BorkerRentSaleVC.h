//
//  BorkerRentSaleVC.h
//  TaoShenFang
//
//  Created by YXM on 16/8/31.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HouseModel;

@interface BorkerRentSaleVC : UIViewController

typedef enum{
    RentBrokerIssueTypeGeneral=0,
    RentBrokerIssueTypeEdit
}RentBrokerIssueType;


@property (nonatomic,strong)HouseModel * model;

@property (nonatomic,assign)RentBrokerIssueType type;

@end
