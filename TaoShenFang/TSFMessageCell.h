//
//  TSFMessageCell.h
//  TaoShenFang
//
//  Created by YXM on 16/12/20.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSFMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *decripLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@end
