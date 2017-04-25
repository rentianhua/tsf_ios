//
//  BaseViewController.h
//  FDCZ
//
//  Created by Du chengdong on 14-3-26.
//  Copyright (c) 2014年  All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFHTTPSessionManager.h>
//#import "AFHTTPRequestOperation.h"

//#import "JSONKit.h"
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController

//UIImageView加载网络图片
-(void)setImgUrl:(NSString *)imgUrl toImgView:(UIImageView *)imgView;
/*UIButton加载网络图片*/
-(void)setImgUrl:(NSString *)imgUrl toBtn:(UIButton *)btn;


-(void)alertMsg:(NSString *)msg;
//重新加载数据
- (void)reloadData:(UITapGestureRecognizer *)sender;


@property(nonatomic,strong)UIImageView *navImgView;
@property(nonatomic,assign)CGFloat height;

@property (nonatomic,strong)UIButton * reloadButton;

@property (nonatomic,strong)UIImageView * offLineImageView;
@property (nonatomic,strong)UIImageView * noDataImageView;

@property (nonatomic,assign)int messagecount;

@property (nonatomic,strong)UITabBarItem *personCenterTabBarItem;

@end
