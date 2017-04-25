//
//  TSFDetailFooterView.h
//  TaoShenFang
//
//  Created by YXM on 16/11/14.
//  Copyright © 2016年 RA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TSFDetailFooterViewDelegate <NSObject>

- (void)tableView:(UITableView *)tableView selectFooter:(NSInteger)section;

@end


@interface TSFDetailFooterView : UITableViewHeaderFooterView

@property (nonatomic,strong)UIButton * moreBtn;
@property (nonatomic,strong)UIView  * BGView;

@property (nonatomic,assign)NSInteger section;


@property (nonatomic,weak)id <TSFDetailFooterViewDelegate> delegate;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier ;



@end
