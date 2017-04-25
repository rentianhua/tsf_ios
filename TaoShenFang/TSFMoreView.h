//
//  TSFMoreView.h
//  YXM下拉框
//
//  Created by YXM on 16/11/7.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>


//typedef void (^MoreSeleBlock)(NSInteger index, NSString *string);
typedef void (^MoreSeleMultiBlock)(NSDictionary *selDic);

@interface TSFMoreView : UIView

@property (nonatomic,copy)MoreSeleMultiBlock moreSeleblock;

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array secArray:(NSArray *)secArray;

- (void)show;

@end
