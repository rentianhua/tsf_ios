//
//  FleaMarketTableCell.h
//  TaoShenFangTest
//
//  Created by sks on 16/6/20.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSFAvgModel;

@interface FleaMarketTableCell : UITableViewCell

@property (nonatomic,strong)TSFAvgModel * model;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;



@end
