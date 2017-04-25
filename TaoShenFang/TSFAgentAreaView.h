//
//  TSFAgentAreaView.h
//  TaoShenFang
//
//  Created by YXM on 16/11/10.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^AreaBlock)(NSString * string);

@interface TSFAgentAreaView : UIView

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array;

@property (nonatomic,copy)AreaBlock areaBlock;

@end
