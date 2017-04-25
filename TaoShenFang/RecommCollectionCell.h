//
//  RecommCollectionCell.h
//  TaoShenFang
//
//  Created by YXM on 16/10/8.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
