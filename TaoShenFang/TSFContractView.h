//
//  TSFContractView.h
//  TaoShenFang
//
//  Created by YXM on 16/11/18.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ConfirmBlock) (void);

@interface TSFContractView : UIView

@property (nonatomic,copy)ConfirmBlock confirmblock;

@property (nonatomic,copy)NSString *contractstring;


@end
