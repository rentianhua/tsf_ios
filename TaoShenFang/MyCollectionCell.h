//
//  MyCollectionCell.h
//  TaoShenFang
//
//  Created by YXM on 16/8/27.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
