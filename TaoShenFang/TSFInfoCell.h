//
//  TSFInfoCell.h
//  TaoShenFang
//
//  Created by YXM on 16/11/25.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSFInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeight;

@end
