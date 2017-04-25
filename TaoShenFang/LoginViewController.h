//
//  LoginViewController.h
//  TaoShenFangTest
//
//  Created by YXM on 16/7/25.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "BaseViewController.h"

typedef enum:NSUInteger{
  CompleteSuccess=0,//登录成功
  CompleteCancel,//取消
  CompleteOther,
}CompleteState;


 typedef void (^CompleteBlock) (CompleteState completeState);
@interface LoginViewController : BaseViewController

@property (nonatomic,copy)CompleteBlock completeBlock;

@end
