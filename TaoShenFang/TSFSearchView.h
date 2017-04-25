//
//  TSFSearchView.h
//  TaoShenFang
//
//  Created by YXM on 16/10/14.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SearchBlock)(void);

@interface TSFSearchView : UIView


@property (nonatomic,strong)UILabel * label;

@property (nonatomic,strong)UILabel * linelabel;
@property (nonatomic,strong)UIButton * button;

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *placeholder;


@property (nonatomic,copy)SearchBlock searchBlock;



@end
