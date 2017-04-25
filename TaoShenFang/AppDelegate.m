//
//  AppDelegate.m
//  TaoShenFang
//
//  Created by YXM on 16/8/17.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager.h>
#import <IQToolBar.h>
#import "NewFeatureViewController.h"
#import "TFConfig.h"
#import "OtherHeader.h"
#import "PartnerConfig.h"
#import <AlipaySDK/AlipaySDK.h>



@interface AppDelegate ()
{
    BMKMapManager * _mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //控制整个功能是否启用。
    manager.enable = YES;
    manager.enableAutoToolbar = NO;
    //控制点击背景是否收起键盘
    manager.shouldResignOnTouchOutside = YES;
    //控制键盘上的工具条文字颜色是否用户自定义。  注意这个颜色是指textfile的tintcolor
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.toolbarTintColor=[UIColor grayColor];
    //中间位置是否显示占位文字
    // manager.shouldShowTextFieldPlaceholder = YES;
    //设置占位文字的字体
    manager.placeholderFont = [UIFont boldSystemFontOfSize:14];
    //控制是否显示键盘上的工具条。
    manager.toolbarManageBehaviour=NO;
    manager.keyboardDistanceFromTextField=20;
    
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    //地图管理者
    _mapManager=[[BMKMapManager alloc]init];
    BOOL ret=[_mapManager start:@"RAlSwyuKW2UmdQHcuDeAcot9sNRAw2sX" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //1、沙盒里面存储版本号-------》存储当前版本号到沙盒
    //-----------------存在版本号：新的==旧的，新的>旧的（显示新特性）UserDefault存储很简单
    NSString * versionKey=@"CFBundleShortVersionString";
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    //上次的版本号
    NSString * lastVersion= [defaults objectForKey:versionKey];
    //取出当前版本号
    NSString * currentVersion= [NSBundle mainBundle].infoDictionary[versionKey];
    
    //当前版本号与上次使用是否相等
    if ([currentVersion isEqualToString:lastVersion]) {
        
        //self.window.rootViewController=[[TSFTabBarController alloc]init];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        TFConfig *tfConfig  = [[TFConfig alloc] init];
        [tfConfig setPlist:@"TFPropertyList" window:self.window];
    }  else {
        self.window.rootViewController=[[NewFeatureViewController alloc ]init ];
        [defaults setObject:currentVersion forKey:versionKey];
        [defaults synchronize];
    }

    
    
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "ruianxinye.TaoShenFang" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TaoShenFang" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TaoShenFang.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            //订单号，支付状态码
            
            NSNotification * notices=[NSNotification notificationWithName:@"pay" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices];
            
            NSNotification * notices1=[NSNotification notificationWithName:@"coupon" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices1];
            
            NSNotification * notices2=[NSNotification notificationWithName:@"order" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices2];
            
            NSNotification * notices3=[NSNotification notificationWithName:@"yhq" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices3];
            


        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
       
            //订单号，支付状态码
            
            NSNotification * notices=[NSNotification notificationWithName:@"pay" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices];
            
            NSNotification * notices1=[NSNotification notificationWithName:@"coupon" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices1];
            
            NSNotification * notices2=[NSNotification notificationWithName:@"order" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices2];

            NSNotification * notices3=[NSNotification notificationWithName:@"yhq" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices3];
            

    
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                   //订单号，支付状态码
            
            NSNotification * notices=[NSNotification notificationWithName:@"pay" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices];
            
            
            
            NSNotification * notices1=[NSNotification notificationWithName:@"coupon" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices1];
            
            NSNotification * notices2=[NSNotification notificationWithName:@"order" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices2];

            NSNotification * notices3=[NSNotification notificationWithName:@"yhq" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices3];
            

            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
         
            //订单号，支付状态码
            
            NSNotification * notices=[NSNotification notificationWithName:@"pay" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices];
            
            NSNotification * notices1=[NSNotification notificationWithName:@"coupon" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices1];
            
            NSNotification * notices2=[NSNotification notificationWithName:@"order" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices2];

            NSNotification * notices3=[NSNotification notificationWithName:@"yhq" object:nil userInfo:resultDic];//resultStatus
            
            [[NSNotificationCenter defaultCenter]postNotification:notices3];
            

            
        }];
    }
    return YES;
}

@end
