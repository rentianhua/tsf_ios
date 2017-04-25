//
//  TSFHandDetailTitleCell.h
//  TaoShenFang
//
//  Created by YXM on 16/11/14.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSFHandDetailTitleCell : UITableViewCell


@property(assign,nonatomic)BOOL hidenLine;

- (void)configCellWithString:(NSString *)title;


@end
