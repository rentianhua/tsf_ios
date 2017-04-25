//
//  SearchResultVC.h
//  TaoShenFang
//
//  Created by YXM on 16/9/29.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnKeyWords)(NSString * kwds);

@interface SearchResultVC : BaseViewController

@property (nonatomic,copy)ReturnKeyWords kwdsBlock;

@end
