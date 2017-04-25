//
//  UpLoadIDCardCell.h
//  TaoShenFang
//
//  Created by YXM on 16/9/1.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpLoadIDCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
- (IBAction)upload:(UIButton *)sender;
@end
