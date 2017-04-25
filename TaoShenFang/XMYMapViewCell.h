//
//  XMYMapViewCell.h
//  TaoShenFangTest
//
//  Created by YXM on 16/7/19.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XMYMapViewCellDelegate <NSObject>

- (void)xMYMapViewCellPushToMap;

@end


@interface XMYMapViewCell : UITableViewCell

@property(assign,nonatomic)BOOL hidenLine;

@property (nonatomic,copy)NSString * coordinateStr;
@property (nonatomic,assign)id<XMYMapViewCellDelegate>delegate;

@end
