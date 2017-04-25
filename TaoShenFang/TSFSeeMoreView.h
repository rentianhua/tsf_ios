//
//  TSFSeeMoreView.h
//  TaoShenFang
//
//  Created by YXM on 16/11/4.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TSFSeeMoreViewDelegate <NSObject>

@optional

- (void)tableView:(UITableView *)tableView selectFooter:(NSInteger)section;

@end


@interface TSFSeeMoreView : UITableViewHeaderFooterView

@property (nonatomic,assign)NSInteger section;

@property (nonatomic,strong)UIButton * button;


@property (nonatomic,weak)id<TSFSeeMoreViewDelegate>delegate;

@end
