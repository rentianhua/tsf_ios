//
//  TSFAgentSearchVC.h
//  TaoShenFang
//
//  Created by YXM on 16/11/11.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnKeyWords)(NSString * kwds);

@interface TSFAgentSearchVC : BaseViewController

@property (nonatomic,copy)NSString * house_type;

@property (nonatomic,copy)ReturnKeyWords kwdsBlock;

@end
