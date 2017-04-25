//
//  TWSelectCityView.h
//  TWCitySelectView
//
//  Created by TreeWriteMac on 16/6/30.
//  Copyright © 2016年 Raykin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSFAreaModel;
@interface TWSelectCityView : UIView

@property (nonatomic,strong)NSArray * areaArray;

-(instancetype)initWithTWFrame:(CGRect)rect TWselectCityTitle:(NSString*)title;

/**
 *  显示
 */

-(void)showCityView:(void(^)(TSFAreaModel *proviceModel,TSFAreaModel *cityModel,TSFAreaModel *disModel))selectStr;
@end
