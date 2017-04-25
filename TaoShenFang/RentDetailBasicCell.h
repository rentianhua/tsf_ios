//
//  RentDetailBasicCell.h
//  TaoShenFang
//
//  Created by YXM on 16/9/11.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseModel.h"
@interface RentDetailBasicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *label8;
@property (weak, nonatomic) IBOutlet UILabel *label9;
@property (weak, nonatomic) IBOutlet UILabel *label10;
@property (weak, nonatomic) IBOutlet UILabel *label11;

@property (weak, nonatomic) IBOutlet UILabel *label12;
- (void)configCellWithModel:(HouseModel *)model;

@end
