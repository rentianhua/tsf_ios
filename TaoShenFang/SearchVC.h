//
//  SearchVC.h
//  TaoShenFang
//
//  Created by YXM on 16/9/8.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnKeyWords)(NSString * kwds);

@interface SearchVC : UIViewController

@property (nonatomic,copy)ReturnKeyWords kwdsBlock;

@end
