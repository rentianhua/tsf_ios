//
//  TSFNewSegmentView.h
//  TaoShenFang
//
//  Created by YXM on 16/11/9.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSFAreaModel;

typedef void (^BtnBlock1)(TSFAreaModel * model,NSInteger areaindex,NSString * price,NSInteger priceindex,NSString * huxing,NSInteger huxingindex,NSString * moreString,NSInteger section);
typedef void (^BtnBlock2)(NSDictionary *selDic);
@interface TSFNewSegmentView : UIView


@property (nonatomic,copy)BtnBlock1 btnBlock;
@property (nonatomic,copy)BtnBlock2 btnBlockMore;

- (instancetype)initWithFrame:(CGRect)frame priceArr:(NSArray *)priceArray typeArr:(NSArray *)typeArray moreArr:(NSArray *)moreArray moreSecArr:(NSArray *)moreSecArray titleArr:(NSArray *)titleArray ;



@end
