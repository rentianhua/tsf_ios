//
//  OtherHeader.h
//  RealEstateAgent
//
//  Created by lvtingyang on 15/10/9.
//  Copyright © 2015年 RealEstateAgent. All rights reserved.
//

#ifndef OtherHeader_h
#define OtherHeader_h
/*RGB*/
#define RGB(a, b, c, opacity) [UIColor colorWithRed:(a / 255.0) green:(b / 255.0) blue:(c / 255.0) alpha:opacity]

//用户名
//#define HasLogin @"hasLogin"
#define USERINFO @"userinfo"

#define BGCOLOR RGB(240, 239, 245, 1.0)//主色
#define MAINCOLOR RGB(237, 27, 36, 1.0)//主色
#define TITLECOL RGB(51, 51, 51, 1.0)//标题颜色
#define DESCCOL RGB(153, 153, 153, 1.0)//其他字体颜色
#define ORGCOL RGB(222, 104, 67, 1.0)//其他字体颜色

//分割线的颜色
#define SeparationLineColor RGB(231, 231, 231, 1.0)

//导航条的颜色
#define NavBarColor RGB(238, 59, 67, 1.0)
//其他导航条颜色
#define OtherNavBarColor RGB(249, 249, 249, 1.0)

//常用绿色
#define BottomColor RGB(0, 174, 102, 1.0)

//标题的文字大小
#define TitleFont [UIFont systemFontOfSize:16]
//详情文字大小
#define DescrTitleFont [UIFont systemFontOfSize:14]
//小按钮的文字大小
#define SmallBtnTitleFont [UIFont systemFontOfSize:12]

#define ImageURL @"http://www.taoshenfang.com"
#define URLSTR @"http://www.taoshenfang.com/index.php?"

//系统版本>=7
#define IOS7 ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//判断iPhone4/4s
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone5/5s
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone6plus
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) : NO)


#define kMainScreenFrameRect                               [[UIScreen mainScreen] bounds]//[[UIScreen mainScreen] applicationFrame]//
//states bar height
#define kMainScreenStatusBarFrameRect                      [[UIApplication sharedApplication] statusBarFrame]
#define kMainScreenHeight                                  kMainScreenFrameRect.size.height
#define kMainScreenWidth                                   kMainScreenFrameRect.size.width

#define GOTHAM_BOOK(FONT_SIZE)         [UIFont fontWithName:@"Gotham-Book" size:FONT_SIZE] // Gotham Book
#define HEL_NEUE(FONT_SIZE)         [UIFont fontWithName:@"HelveticaNeue" size:FONT_SIZE] // Helvetica Neue
#define HEL_NEUE_REGULAR(FONT_SIZE)         [UIFont fontWithName:@"HelveticaNeue" size:FONT_SIZE] // Helvetica Neue Regular
#define HEL_NEUE_MEDIUM(FONT_SIZE)         [UIFont fontWithName:@"HelveticaNeue-Medium" size:FONT_SIZE] // Helvetica Neue Medium
#define HEL_NEUE_LIGHT(FONT_SIZE)         [UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE] // Helvetica Neue Light
#define HEL_NEUE_THIN(FONT_SIZE)         [UIFont fontWithName:@"HelveticaNeue-Thin" size:FONT_SIZE]; // Helvetica Neue Thin
#define HEL_NEUE_BOLD(FONT_SIZE)         [UIFont fontWithName:@"HelveticaNeue-Bold" size:FONT_SIZE]; // Helvetica Neue Bold
#define HEL_OOBE_NEUE_BOLD(FONT_SIZE)         [UIFont fontWithName:@"HelveticaNeue-Bold" size:FONT_SIZE] // Helvetica Neue Bold


#define OOBE_TXET_COLOR [UIColor colorWithRed:42/255.0f green:42/255.0f blue:42/255.0f alpha:1.0]

//cell适配
#define FLOAT  Width/320.0

#define Rect(x,y,w,h) CGRectMake(x*kMainScreenWidth/320.0, y*kMainScreenWidth/320.0, w*kMainScreenWidth/320.0, h*kMainScreenWidth/320.0)
///////////////*系统版本判断*/
#pragma mark -  SystemInfo functions
#pragma mark

///系统版本判断
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS6_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS5_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define IOS4_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#define IOS3_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )


#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]

#define AppID @"wxe9cc0ba1c71948dc" 
//微信
#define WeixinAppId @"wxe9cc0ba1c71948dc"
#define WeixinAppSecret @"f743071c7522da0fa4fd33af1c5e3e48"
//qq
#define TencentAppid  @"1105074667"
#define TenchentAPPKey @"Yqyl5OUjl4ucgGR4D";

#define USERPIC @"userpic"

#define ORIGINAL_MAX_WIDTH 640.0f
//将数据保存在本地
#define NSUSER_DEF_NORSET(a,b) [[NSUserDefaults standardUserDefaults]setValue:a forKey:b]
//从本地读取数据
#define NSUSER_DEF(a)  [[NSUserDefaults standardUserDefaults] valueForKey:a]

//客户服务器
#define HOST (@"http://zbw.nx188.net/mobile")
#define HOST_CESHI (@"http://www.91ichi.com:8080/DCServer")

#define ShowAlert(Message)    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:Message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"OK"];[alert show];

#endif /* OtherHeader_h */
