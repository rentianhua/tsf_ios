//
//  MainSectionView.h
//  TaoShenFangTest
//
//  Created by sks on 16/6/20.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MainSectionView;
@protocol MainSectionViewDelegate <NSObject>

@optional

- (void)tableView:(UITableView *)tableView sectionDidSelected:(NSInteger)section ;

@end

@interface MainSectionView : UITableViewHeaderFooterView

@property (nonatomic,assign)NSInteger section;
@property (nonatomic,strong)UILabel * leftLabel;
@property (nonatomic,strong)UIButton * rightButton;
@property (nonatomic,strong)UILabel * rightLabel;

@property (nonatomic,weak)id<MainSectionViewDelegate>delegate;


@end
