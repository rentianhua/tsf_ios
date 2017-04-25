//
//  TFTabBarItem.h
//  TFQuicklyBuild
//
//  Created by zengxiangfeng on 16/1/12.
//  Copyright © 2016年 zengxiangfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFTabBarItem : UITabBarItem

- (instancetype)initWithTabBarItemTitle:(NSString *)title
                    titleFont:(NSString *)titleFont
           unSelectTitleColor:(NSString *)unSelectTitleColor
             selectTitleColor:(NSString *)selectTitleColor
                    imageName:(NSString *)imageName
                 selImageName:(NSString *)selImageName;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com