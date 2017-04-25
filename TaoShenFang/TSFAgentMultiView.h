//
//  TSFAgentMultiView.h
//  TaoShenFang
//
//  Created by YXM on 16/11/10.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MultiBlock)(NSString * string);

@interface TSFAgentMultiView : UIView

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array;


@property (nonatomic,copy)MultiBlock multiBlock;

@end
