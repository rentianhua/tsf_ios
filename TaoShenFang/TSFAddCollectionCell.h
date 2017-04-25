//
//  TSFAddCollectionCell.h
//  TaoShenFang
//
//  Created by YXM on 16/11/29.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SelectItemBlock)(void);

@interface TSFAddCollectionCell : UITableViewCell

@property (nonatomic,strong)NSMutableArray * imgArray;

@property (nonatomic,copy)SelectItemBlock selectBlock;//回调block  显示相册

@property (nonatomic,strong)UICollectionView * collectionView;
@end
