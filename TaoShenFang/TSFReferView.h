//
//  TSFReferView.h
//  TaoShenFang
//
//  Created by YXM on 16/12/6.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PhoneBlock)(void);
typedef void(^MessageBlock)(void);
typedef void(^HeadBlock)(void);

@interface TSFReferView : UIView

@property (nonatomic,copy)PhoneBlock phoneBlock;
@property (nonatomic,copy)MessageBlock messageBlock;
@property (nonatomic,copy)HeadBlock headBlock;
@property (nonatomic,strong)UIButton* headImg;
@property (nonatomic,strong)UILabel * nameLab;
@property (nonatomic,strong)UILabel * commentLab;
@property (nonatomic,strong)UILabel * numLab;
@property (nonatomic,strong)UIButton * phoneBtn;
@property (nonatomic,strong)UIButton * messageBtn;


- (void)showView;


@end
