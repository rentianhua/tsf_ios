//
//  TSFHouseTypeCell.h
//  TaoShenFang
//
//  Created by YXM on 16/11/15.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSFHouseTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label11;

@property(assign,nonatomic)BOOL hidenLine;

- (void)configCellWithPrice:(NSString * )price shi:(NSString *)shi ting:(NSString *)ting mianji:(NSString *)mianji;

@end
