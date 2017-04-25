//
//  TSFNewAreaView.h
//  TaoShenFang
//
//  Created by YXM on 16/11/9.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSFAreaModel;

typedef void (^AreaBlock)(TSFAreaModel * model,NSInteger index);

@interface TSFNewAreaView : UIView

- (instancetype)initWithFrame:(CGRect)frame ;
@property (nonatomic,copy)AreaBlock areaBlock;

@end
