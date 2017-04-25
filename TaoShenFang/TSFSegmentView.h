//
//  TSFSegmentView.h
//  YXM下拉框
//
//  Created by YXM on 16/11/7.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSFAreaModel;

typedef void (^BtnBlock1)(TSFAreaModel * model,NSInteger areaindex,NSString * ditie,NSString * price,NSInteger priceindex,NSString * huxing,NSInteger huxingindex,NSString * moreString,NSInteger section);
typedef void (^BtnBlock2)(NSDictionary *selDic);

@interface TSFSegmentView : UIView

@property (nonatomic,copy)BtnBlock1 btnBlock;
@property (nonatomic,copy)BtnBlock2 btnBlockMore;

- (instancetype)initWithFrame:(CGRect)frame priceArr:(NSArray *)priceArray huxingArr:(NSArray *)huxingArray moreArr:(NSArray *)moreArray moreSecArr:(NSArray *)moreSecArray titleArr:(NSArray *)titleArray;

@end
