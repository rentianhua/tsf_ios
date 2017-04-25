//
//  NewFeatureViewController.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/23.
//  Copyright © 2016年 qkq. All rights reserved.
//


#define NewFeatureImgViewCount 1
#import "NewFeatureViewController.h"
#import "OtherHeader.h"
#import "TFConfig.h"
@interface NewFeatureViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIPageControl * pageControl;
@end

@implementation NewFeatureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor yellowColor];
    
    [self createScrollView];
    [self setupPageControl];
    
}

- (void)createScrollView
{
    // 1.添加UISrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // 2.添加图片
    CGFloat imageW = scrollView.bounds.size.width;
    CGFloat imageH = scrollView.bounds.size.height;
    for (int i = 0; i<NewFeatureImgViewCount; i++) {
        // 创建UIImageView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*imageW, 0, imageW, imageH)];
       // NSString *name = [NSString stringWithFormat:@"NewFeature%d", i + 1];
      /**  if (FourInch) { // 4inch  需要手动去加载4inch对应的-568h图片
            name = [name stringByAppendingString:@"-568h"];
        }*/
        imageView.image = [UIImage imageNamed:@"NewFeature01"];
        [scrollView addSubview:imageView];
        
        // 给最后一个imageView添加按钮
        if (i == NewFeatureImgViewCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置其他属性
    scrollView.contentSize = CGSizeMake(NewFeatureImgViewCount * imageW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = RGB(246, 246, 246,1.0);
}

/**
 *  添加pageControl
 */
- (void)setupPageControl
{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = NewFeatureImgViewCount;
    pageControl.center=CGPointMake(self.view.center.x, self.view.frame.size.height-30);
    [self.view addSubview:pageControl];
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor =RGB(253, 98, 42,1.0); // 当前页的小圆点颜色
    pageControl.pageIndicatorTintColor = RGB(189, 189, 189,1.0); // 非当前页的小圆点颜色
    self.pageControl = pageControl;
}


/**
 设置最后一个UIImageView中的内容
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    
    // 1.添加开始按钮
    [self setupStartButton:imageView];
    
}

/**
 *  添加开始按钮
 */
- (void)setupStartButton:(UIImageView *)imageView
{
    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 80)];
    startButton.center=CGPointMake(self.view.center.x, self.view.center.y+10);
    [imageView addSubview:startButton];
    
    // 4.设置文字、
    [startButton setBackgroundColor:[UIColor clearColor]];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  进入首页
 */
- (void)start
{
    // 显示主控制器（HMTabBarController）
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    TFConfig *tfConfig  = [[TFConfig alloc] init];
    [tfConfig setPlist:@"TFPropertyList" window:window];
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获得页码
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    int intPage = (int)(doublePage + 0.5);
    
    // 设置页码
    self.pageControl.currentPage = intPage;
}



@end
