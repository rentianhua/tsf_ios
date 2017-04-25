//
//  HandFeatureCell.h
//  TaoShenFang
//
//  Created by YXM on 16/9/10.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HouseModel;
@interface HandFeatureCell : UITableViewCell
@property (nonatomic,strong)UILabel * title;
@property (nonatomic,strong)UILabel * content;

@property(assign,nonatomic)BOOL hidenLine;

- (void)configCellWithString:(NSString *)string;

@end
