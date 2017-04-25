//
//  TFMapper.m
//  TFQuicklyBuild
//
//  Created by zengxiangfeng on 16/1/11.
//  Copyright © 2016年 zengxiangfeng. All rights reserved.
//

#import "TFMapper.h"
#import "TFTabViewController.h"
#import "OtherHeader.h"
@interface TFMapper()

@property (nonatomic, retain) NSMutableArray *mapAry;
@property (nonatomic, retain) NSDictionary *navDic;
@property (nonatomic, retain) TFTabViewController *tfTabbarCtrl;

@end

@implementation TFMapper
- (void)mapperWithContentsUrl:(NSURL *)url toWindow:(id)window{
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:url];
    if (dictionary == nil) {
        return;
    }
    self.mapAry = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"Tab"]];
    
    
    self.navDic = [[NSDictionary alloc] initWithDictionary:[dictionary objectForKey:@"Nav"]];
    
    
    [self TF_tabBarViewCtrlToWindow:window];
}

- (void)TF_tabBarViewCtrlToWindow:(id)window{

    if (self.tfTabbarCtrl == nil) {
        self.tfTabbarCtrl = [[TFTabViewController alloc] initWithArray:self.mapAry navDic:self.navDic];
       
        
        UIWindow *myWindow = (UIWindow *)window;
        myWindow.rootViewController = self.tfTabbarCtrl;
    }
    
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com