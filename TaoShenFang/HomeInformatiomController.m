//
//  HomeInformatiomController.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/22.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "HomeInformatiomController.h"

#import "IDModel.h"
#import "InformationModel.h"

#import "ZYWHttpEngine.h"
#import "OtherHeader.h"

#import <UIImageView+WebCache.h>
#import "MJExtension.h"

#import "YJProgressHUD.h"
#import "TSFInfoCell.h"


#define NAVBTNW 20

@interface HomeInformatiomController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView * webview;

@property (nonatomic,strong)InformationModel * model;

@property (nonatomic,strong)UIButton * leftNavBtn;

@end

@implementation HomeInformatiomController

- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

/**返回*/
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView{
    [super loadView];
    self.navigationController.navigationBarHidden=NO;
}
- (void)setIdModel:(IDModel *)idModel{
    _idModel=idModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    
    _webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64)];
    _webview.scrollView.showsHorizontalScrollIndicator=NO;
    _webview.scrollView.showsVerticalScrollIndicator=NO;
    _webview.delegate=self;
    _webview.scrollView.bounces=NO;
    [self.view addSubview:_webview];

    [self loadData];
   
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

- (void)loadData{
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    
    NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=house&a=api_shows",URLSTR];
    NSDictionary * param=@{@"catid":_idModel.catid,@"id":_idModel.ID};
    
    __weak typeof(self)weakSelf=self;
    
    [ZYWHttpEngine AllPostURL:urlStr params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        InformationModel * model=[InformationModel mj_objectWithKeyValues:responseObj];
        weakSelf.model=model;
        
        [weakSelf refreshUI];
        
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
    }];
}

- (void)refreshUI
{
    NSURL * url=[NSURL URLWithString:self.model.url];
    NSURLRequest * request=[[NSURLRequest alloc]initWithURL:url];
    [_webview loadRequest:request];
}

@end
