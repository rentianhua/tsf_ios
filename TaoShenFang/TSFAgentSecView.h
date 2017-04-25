//
//  TSFAgentSecView.h
//  TaoShenFang
//
//  Created by YXM on 16/11/10.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^TSFAgentSecBlock)(int index, NSString * string1,NSString * string2,NSString * string3);

@interface TSFAgentSecView : UITableViewHeaderFooterView

@property (nonatomic,copy)TSFAgentSecBlock secBlock;

@end
