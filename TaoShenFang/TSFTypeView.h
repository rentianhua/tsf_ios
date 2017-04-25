//
//  TSFTypeView.h
//  YXM下拉框
//
//  Created by YXM on 16/11/7.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TypeBlock)(NSString * string,NSInteger huxingindex);

@interface TSFTypeView : UIView

@property (nonatomic,copy)TypeBlock typeBlock;

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array;

- (void)show;

@end
