//
//  TSFOtherPickView.h
//  TaoShenFang
//
//  Created by YXM on 16/8/24.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSFOtherPickView : UIView

- (instancetype)initWithFrame:(CGRect)frame selectTitle:(NSString *)title array:(NSArray *)array;

- (void)showView:(void(^)(NSString *str))selectStr;


@end
