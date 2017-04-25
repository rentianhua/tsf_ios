//
//  TSFMultiPickerView.h
//  TaoShenFang
//
//  Created by YXM on 16/8/24.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AreaType) {
    AreaTypeY = 0,
    AreaTypeN
    
};

@interface TSFMultiPickerView : UIView

@property (nonatomic,strong)NSArray * hasseleArray;

@property (nonatomic,assign)AreaType areaType;


- (instancetype)initWithFrame:(CGRect)frame selectTitle:(NSString *)title array:(NSArray *)array;

- (void)showView:(void(^)(NSArray *selectArray ))selectArray;





@end
