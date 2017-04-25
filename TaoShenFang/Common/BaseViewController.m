//
//  BaseViewController.m
//  FDCZ
//
//  Created by Du chengdong on 14-3-26.
//  Copyright (c) 2014年  All rights reserved.
//

#import "BaseViewController.h"
#import "OtherHeader.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "ZYWHttpEngine.h"
#import "UserModel.h"
#import <MJExtension.h>

#import "Chat_Model.h"

@interface BaseViewController ()

@property (nonatomic,strong)dispatch_source_t timer;
@property (nonatomic,strong)dispatch_source_t timer1;

@property (nonatomic,strong)NSMutableArray * resultArray;


@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    bg.backgroundColor = UIColorFromRGB(0Xf0eff5);
    [self.view addSubview:bg];

    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    
    if (NSUSER_DEF(USERINFO)!=nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self loadLoginStatus];
        });
    }
    
  
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(base_messageAction:) name:@"message" object:nil];
   
}

- (void)base_messageAction:(NSNotification *)noti{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self loadLoginStatus];
    });

}
- (void)loadLoginStatus{
    
    __weak typeof(self)weakSelf=self;
    dispatch_queue_t queue1=dispatch_queue_create("tsf", DISPATCH_QUEUE_CONCURRENT);
    
    self.timer= dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue1);
    dispatch_time_t start=dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC));
    uint64_t interVal=(uint64_t)(3.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interVal, 0);
    
    
    dispatch_source_set_event_handler(self.timer, ^{

        [weakSelf repeatAction];//密码
        [weakSelf loadDataTime];//消息
        
    });
    dispatch_resume(self.timer);
    
}

- (void)repeatAction{
    
    if (NSUSER_DEF(USERINFO)!=nil ) {
        
        //在这里执行事件
        NSString * password=  NSUSER_DEF(USERINFO)[@"password"];
        
        NSDictionary * param=@{@"userid":NSUSER_DEF(USERINFO)[@"userid"]};
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=Member&m=Public&a=api_getuserinfo",URLSTR] params:param success:^(id responseObj) {
            if (responseObj) {
                UserModel * model=[UserModel mj_objectWithKeyValues:responseObj];
                if (![model.password isEqualToString:password]) {

                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERINFO];
                    [NSUSER_DEF(USERINFO) synchronize];
                }
                
            }
        } failure:^(NSError *error) {
            
        }];
        
    }
}

- (void)loadDataTime{
    _resultArray=[NSMutableArray array];
    
    NSArray *tabBarItems = self.navigationController.tabBarController.tabBar.items;
    
    _personCenterTabBarItem = [tabBarItems objectAtIndex:1];
    
    
    if (NSUSER_DEF(USERINFO)!=nil) {
        NSDictionary * param=@{@"userid":NSUSER_DEF(USERINFO)[@"userid"]};
        __weak typeof(self)weakSelf=self;
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=liuyan_list",URLSTR] params:param success:^(id responseObj) {
            
            
            if (responseObj) {
                
                NSArray * array=[responseObj allValues];
                
                NSMutableArray * arrayM=[Chat_Model mj_objectArrayWithKeyValuesArray:array];
                
                
                Chat_Model * xtmodel=nil;
                for (int i=0; i<arrayM.count; i++) {
                    Chat_Model * model=arrayM[i];
                    if ([model.from_uid isEqualToString:@"0"]) {
                        xtmodel=model;
                        [arrayM removeObject:model];
                    }
                }
                
                NSArray * array1=[Chat_Model mj_keyValuesArrayWithObjectArray:arrayM];
                
                NSMutableArray * resultArray=[[NSMutableArray alloc]initWithArray:array1];
                NSArray * sortD=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"inputtime" ascending:YES]];
                [resultArray sortUsingDescriptors:sortD];
                
                NSMutableArray * array2=[Chat_Model mj_objectArrayWithKeyValuesArray:resultArray];
                if (xtmodel!=nil) {
                    [array2 insertObject:xtmodel atIndex:0];
                }
                
                
                
                if(array.count>0)
                {
                    NSMutableArray * resultArray=[[NSMutableArray alloc] initWithArray:[Chat_Model mj_objectArrayWithKeyValuesArray:array]];
                    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"_inputtime" ascending:NO];
                    NSArray *tempArray = [resultArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"formessage" object:nil userInfo:@{@"message":tempArray}];
                }
                
                

                
                if (array1.count>0) {
                    Chat_Model  * model=arrayM[0];
                    weakSelf.messagecount=[model.weidu_sum intValue];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
 
                        if (_messagecount>0) {
                           
                            weakSelf.personCenterTabBarItem.badgeValue = [NSString stringWithFormat:@"%d",weakSelf.messagecount];//显示消息条数为 2
                        } else{
                           
                            if (weakSelf.personCenterTabBarItem.badgeValue!=nil) {
                                weakSelf.personCenterTabBarItem.badgeValue = nil;//无消息
 
                            }
                        }
                    });
                }
            }
            
        } failure:^(NSError *error) {
            
        }];
    } else{
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if ( self.personCenterTabBarItem.badgeValue!=nil) {
                self.personCenterTabBarItem.badgeValue=nil;
            }
        });
      
    }
}



//无网络状态
- (void)offLine{
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64)];
    [self.view addSubview:imageView];
    [imageView setImage:[UIImage imageNamed:@"offline_bg_01"]];
    self.offLineImageView=imageView;
    imageView.userInteractionEnabled=YES;
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, kMainScreenHeight*0.6, kMainScreenWidth, 21)];
    label.text=@"网络开了小差";
    label.font=[UIFont systemFontOfSize:14];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor blackColor];
    [imageView addSubview:label];
    
    UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), kMainScreenWidth, 21)];
    label1.text=@"请点击页面刷新";
    label1.textColor=[UIColor grayColor];
    label1.textAlignment=NSTextAlignmentCenter;
    label1.font=[UIFont systemFontOfSize:12];
    [imageView addSubview:label1];
    
    imageView.hidden=YES;
    
    [self.view bringSubviewToFront:imageView];
    
    
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadData:)];
    tap.numberOfTouchesRequired=1;
    [self.offLineImageView addGestureRecognizer:tap];

}

- (void)noData{
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64)];
    [self.view addSubview:imageView];
    [imageView setImage:[UIImage imageNamed:@"message_no_01"]];
    self.noDataImageView=imageView;
    imageView.userInteractionEnabled=YES;
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, kMainScreenHeight*0.6, kMainScreenWidth, 21)];
    label.text=@"无数据";
    label.font=[UIFont systemFontOfSize:14];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor blackColor];
    [imageView addSubview:label];
    
    UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), kMainScreenWidth, 21)];
    label1.text=@"请点击页面刷新";
    label1.textColor=[UIColor grayColor];
    label1.textAlignment=NSTextAlignmentCenter;
    label1.font=[UIFont systemFontOfSize:12];
    [imageView addSubview:label1];
    
    imageView.hidden=YES;
    
    [self.view bringSubviewToFront:imageView];
    
    
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadData:)];
    tap.numberOfTouchesRequired=1;
    [self.offLineImageView addGestureRecognizer:tap];
}

//imageView单击手势 重新加载数据
- (void)reloadData:(UITapGestureRecognizer *)sender{
    
}
#pragma mark -  设置返回按钮和title
/**
 *  @brief  设置返回按钮和title
 *
 *  @param  back   是否限时返回按钮
 *  @param  title  导航条显示的title内容
 */
//-(void)loadBack:(BOOL)back withTitle:(NSString *)title{
//    
//    _titleLab.text=title;
//    _backBtn.hidden=!back ;
//   
//}

#pragma mark -  UIImageView加载网络图片
/**
 *  @brief  UIImageView加载网络图片
 *
 *  @param  imgUrl   图片网络链接地址
 *  @param  imgView  需要加载网络图片的imgview
 */

- (void)setImgUrl:(NSString *)imgUrl toImgView:(UIImageView *)imgView{
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:imgView.frame];
    [imgView setImage:[UIImage imageNamed:@"card_default"]];
    [tempImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [tempImageView setImage:image];
            if (image.size.width==0 && image.size.height==0 ) {
               [imgView setImage:[UIImage imageNamed:@"card_default"]];
            }
        } if (error) {
             [imgView setImage:[UIImage imageNamed:@"card_default"]];
        }
    }];
}

#pragma mark -   UIButton加载网络图片
/**
 *  @brief  UIButton加载网络图片
 *
 *  @param  imgUrl   图片网络链接地址
 *  @param  imgView  需要加载网络图片的imgview
 */

- (void)setImgUrl:(NSString *)imgUrl toBtn:(UIButton *)btn{
    UIButton *tempButton = [[UIButton alloc] initWithFrame:btn.frame];
    [tempButton setImage:[UIImage imageNamed:@"card_default"] forState:UIControlStateNormal];
    [tempButton sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [tempButton setImage:image forState:UIControlStateNormal];
            if (image.size.width==0 && image.size.height==0) {
            [tempButton setImage:[UIImage imageNamed:@"card_default"] forState:UIControlStateNormal];
            }
            if (error) {
                 [tempButton setImage:[UIImage imageNamed:@"card_default"] forState:UIControlStateNormal];
            }
        }
    }];
    
    
}



#pragma mark ------------------
-(void)alertMsg:(NSString *)msg{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确   定", nil];
    [alert show];
}
-(void)SearchBar{

    NSLog(@"您点击的是搜索按钮");
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//
//    dispatch_source_cancel(self.timer);
//    self.timer=nil;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
