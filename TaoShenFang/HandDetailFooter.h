//
//  HandDetailFooter.h
//  TaoShenFang
//
//  Created by YXM on 16/9/11.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonClickBlock) (void);

@interface HandDetailFooter : UITableViewHeaderFooterView

@property (nonatomic,strong)UIButton * button;
@property (nonatomic,copy)ButtonClickBlock clickBlock;

@end
