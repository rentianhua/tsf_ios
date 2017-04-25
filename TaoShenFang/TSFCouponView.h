//
//  TSFCouponView.h
//  TaoShenFang
//
//  Created by YXM on 16/11/21.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CommitAction)(NSString * codetext);
typedef void (^SendAction)(void);

@interface TSFCouponView : UIView


@property (nonatomic,copy)CommitAction commitBlock;

@property (nonatomic,copy)SendAction sendBlock;

@property (nonatomic,strong)UIButton * sendCodeBtn;

@end
