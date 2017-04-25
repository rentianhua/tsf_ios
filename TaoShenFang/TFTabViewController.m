//
//  TFTabViewController.m
//  TFQuicklyBuild
//
//  Created by zengxiangfeng on 16/1/11.
//  Copyright © 2016年 zengxiangfeng. All rights reserved.
//

#import "TFTabViewController.h"
#import "TFTabBarItem.h"
#import "TFValueParser.h"
#import "OtherHeader.h"
#import "LoginViewController.h"
@interface TFTabViewController ()<UITabBarControllerDelegate>


@end

@implementation TFTabViewController

- (instancetype)initWithArray:(NSArray *)array navDic:(NSDictionary *)navDic{
    
    self = [super init];
    if (self) {
        NSMutableArray *viewCtrlAry = [[NSMutableArray alloc] init];
        BOOL isNav = [navDic objectForKey:@"isHaveNav"];
        for (NSDictionary *dic in array) {
            UIViewController *viewCtr;
            
        if (isNav) {
                viewCtr =[self setNavClassName:[dic objectForKey:@"class"]];
                viewCtr.tabBarItem = [[TFTabBarItem alloc] initWithTabBarItemTitle:[dic objectForKey:@"title"] titleFont:[dic objectForKey:@"barItemFont"] unSelectTitleColor:[dic objectForKey:@"unselectTitleColor"] selectTitleColor:[dic objectForKey:@"selectTitleColor"] imageName:[dic objectForKey:@"unselectImg"] selImageName:[dic objectForKey:@"selectImg"]];
                
            }
            else{
          
                viewCtr = [self setClassName:[dic objectForKey:@"class"]];
            }
            [viewCtrlAry addObject:viewCtr];
            self.viewControllers = viewCtrlAry;
        }
        
    }
    return self;
    
}

- (UIViewController *)setClassName:(NSString *)className{

    UIViewController *viewController = [[NSClassFromString(className) alloc] init];
    return viewController;
}
- (UINavigationController *)setNavClassName:(NSString *)className{
    
    UIViewController *viewController = [[NSClassFromString(className) alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    return navigationController;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSInteger currentIndex=self.selectedIndex;//当前选中的索引
    NSInteger selectedIndex=[tabBarController.viewControllers indexOfObject:viewController];//将要选的索引
    if (selectedIndex==1) {
        if (NSUSER_DEF(USERINFO) ==nil) {
            LoginViewController * vc=[[LoginViewController alloc]init];
            vc.completeBlock=^(CompleteState completeState)
            {
                if (completeState==CompleteCancel) {
                    [self setSelectedIndex:currentIndex];
                }
            };
            UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
    else{
        [self setSelectedIndex:selectedIndex];
    }
  
    
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
