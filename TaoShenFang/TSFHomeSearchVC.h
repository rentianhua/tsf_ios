//
//  TSFHomeSearchVC.h
//  TaoShenFang
//
//  Created by YXM on 16/11/28.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "BaseViewController.h"


typedef NS_ENUM(NSUInteger, leftBtnSelected) {
    leftBtnSelectedHand,
    leftBtnSelectedNew,
    leftBtnSelectedRent,
};


@interface TSFHomeSearchVC : BaseViewController


@property (nonatomic,assign)leftBtnSelected leftSelect;


@end
