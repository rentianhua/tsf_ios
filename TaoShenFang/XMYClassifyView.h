//
//  XMYClassifyView.h
//  TaoShenFangTest
//
//  Created by YXM on 16/7/20.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMYClassifyViewDelegate <NSObject>

- (void)xMYClassifyViewButtonClick:(UIButton *)button;

@end

@interface XMYClassifyView : UIView

@property (nonatomic,assign)id<XMYClassifyViewDelegate>delegate;

@end
