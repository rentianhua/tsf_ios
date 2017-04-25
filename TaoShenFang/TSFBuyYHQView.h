//
//  TSFBuyYHQView.h
//  TaoShenFang
//
//  Created by YXM on 16/11/29.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ComfirmBlock)(NSString * name,NSString *num,NSString *code);
typedef void (^CodeBlock)(NSString * num);


@interface TSFBuyYHQView : UIView

@property (nonatomic,copy)NSString * yhqStr;
@property (nonatomic,strong)UIButton * codeBtn;
@property (nonatomic,copy)ComfirmBlock comfirmBlock;
@property (nonatomic,copy)CodeBlock codeBlock;
- (void)setYhqDes:(NSString *)des;
@end
