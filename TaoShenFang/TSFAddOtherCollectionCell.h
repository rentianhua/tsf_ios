//
//  TSFAddOtherCollectionCell.h
//  TaoShenFang
//
//  Created by YXM on 16/11/29.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDModel;

typedef void(^ItemSelectBlock)(IDModel * idmodel);
@interface TSFAddOtherCollectionCell : UITableViewCell

@property (nonatomic,strong)NSArray *recommArray;

@property (nonatomic,copy)ItemSelectBlock itemBlock;

@end
