//
//  IssueEditTitleVC.h
//  TaoShenFang
//
//  Created by YXM on 16/10/25.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^TextBlock) (NSString * text);

@interface IssueEditTitleVC : BaseViewController

@property (nonatomic,copy)TextBlock textblock;

@property (nonatomic,copy)NSString * string;

@property (nonatomic,assign)NSInteger num;//限制字数


@end
