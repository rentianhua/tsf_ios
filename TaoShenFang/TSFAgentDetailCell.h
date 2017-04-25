//
//  TSFAgentDetailCell.h
//  TaoShenFang
//
//  Created by YXM on 16/11/3.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSFAgentDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIView *labelView;

@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (nonatomic,copy)NSString * biaoqian;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;

@end
