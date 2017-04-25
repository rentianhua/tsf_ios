//
//  ApplyPhoneVC.h
//  TaoShenFang
//
//  Created by YXM on 16/8/27.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "ViewController.h"
@class UserModel;

@interface ApplyPhoneVC : ViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,strong)UserModel * model;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
- (IBAction)rightClick:(id)sender;

@end
