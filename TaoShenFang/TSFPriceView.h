//
//  TSFPriceView.h
//  YXM下拉框
//
//  Created by YXM on 16/11/7.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^PriceBlock)(NSString * price,NSInteger priceindex);

@interface TSFPriceView : UIView

@property (nonatomic,copy)PriceBlock priceBlock;

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array;

- (void)show;

@end
