//
//  TSFLouCengView.h
//  TaoShenFang
//
//  Created by YXM on 16/10/27.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSFLouCengView : UIView

- (instancetype)initWithFrame:(CGRect)frame selectTitle:(NSString *)title allArray:(NSArray *)array;

- (void)showView:(void(^)(NSString *str1,NSString *str2 ))selectStr;




@end
