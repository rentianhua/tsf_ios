//
//  TSFCalculatorVC.m
//  TaoShenFang
//
//  Created by YXM on 16/12/15.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFCalculatorVC.h"
//==========加载html==========
#import "IMYWebView.h"
//===========================
#import "OtherHeader.h"

#import "YJProgressHUD.h"

@interface TSFCalculatorVC ()<IMYWebViewDelegate,UIWebViewDelegate>
@property (nonatomic,strong)UIButton * leftNavBtn;
@property(nonatomic, strong)IMYWebView *htmlWebView;
@property (nonatomic,strong)UIWebView * webView;

@end

@implementation TSFCalculatorVC

- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.title=@"购房算账";
    
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    _webView.scrollView.showsHorizontalScrollIndicator=NO;
    _webView.scrollView.showsVerticalScrollIndicator=NO;
    _webView.delegate=self;
    _webView.scrollView.bounces=NO;
    [self.view addSubview:_webView];
    
    NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"%@g=Wap&m=calculate&a=shuifei",URLSTR]];
    NSURLRequest * request=[[NSURLRequest alloc]initWithURL:url];
    [_webView loadRequest:request];
    
}

#pragma mark----UIWebDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [YJProgressHUD hide];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error
{
    [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
