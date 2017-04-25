//
//  TSFAreaView.h
//  YXM下拉框
//
//  Created by YXM on 16/11/7.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSFAreaModel;


//index 1、100表示不限  2、200表示点击空白处 3、300表示选择的是区域 4、400表示选择的是街道


typedef void (^AreaBlock) (id model,NSInteger index);


@interface TSFAreaView : UIView

@property (nonatomic,copy)AreaBlock block;


- (void)show;




@end
