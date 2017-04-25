//
//  TSFModifyDataVC.h
//  TaoShenFang
//
//  Created by YXM on 16/11/14.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "BaseViewController.h"
@class UserModel;

typedef NS_ENUM(NSInteger,ModifyDataVCType) {
 ModifyRealVCType,//真实姓名
    ModifyIDVCType,//身份证号码
    ModifyCYVCType//公司名称
};

@interface TSFModifyDataVC : BaseViewController

@property (nonatomic,assign)ModifyDataVCType modifyType;

@property (nonatomic,strong)UserModel *model;


@end
