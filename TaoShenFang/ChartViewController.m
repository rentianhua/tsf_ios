//
//  ChartViewController.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/26.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "ChartViewController.h"
#import "OtherHeader.h"

#import "YJProgressHUD.h"
#define NAVBTNW 26
@interface ChartViewController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView * webview;
//@property (nonatomic,strong)MBProgressHUD * hud;
@property (nonatomic,strong)UIButton * leftNavBtn;
@end

@implementation ChartViewController
- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
   self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
}
- (void)pop:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"房价行情";
    
    _webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    _webview.scrollView.showsHorizontalScrollIndicator=NO;
    _webview.scrollView.showsVerticalScrollIndicator=NO;
    _webview.delegate=self;
    _webview.scrollView.bounces=NO;
    [self.view addSubview:_webview];
    
    
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    
    NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"%@a=lists&catid=57",URLSTR ]];
    NSURLRequest * request=[[NSURLRequest alloc]initWithURL:url];
    [_webview loadRequest:request];
    
}
#pragma mark----UIWebDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"开始加载");
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"结束加载");
    [YJProgressHUD hide];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error
{
    NSLog(@"error=%@",error);
}


@end
