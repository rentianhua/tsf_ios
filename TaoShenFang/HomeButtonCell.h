//
//  HomeButtonCell.h
//  TaoShenFangTest
//
//  Created by YXM on 16/7/18.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeButtonCellDelegate <NSObject>

- (void)homeButtonCellSelectBtnTag:(NSInteger)buttonTag;

@end

@interface HomeButtonCell : UITableViewCell

@property (nonatomic,weak)id<HomeButtonCellDelegate>delegate;

@end
