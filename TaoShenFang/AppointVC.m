//
//  AppointVC.m
//  TaoShenFang
//
//  Created by YXM on 16/8/30.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "AppointVC.h"
#import <Masonry.h>
#import "AppointCell.h"
#import "OtherHeader.h"
#import "ZYWHttpEngine.h"
#import "HandRoomDetailVC.h"
@interface AppointVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)UIButton * leftBtn;//看房行程
@property (nonatomic,strong)UIButton * rightBtn;//带看行程
@property (nonatomic,strong)UIView * lineView;//

@end

@implementation AppointVC{
    BOOL didConstraints;
}

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]init];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:@"AppointCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    }
    return _tableView;
}
- (UIView * )topView{
    if (_topView==nil) {
        _topView=[[UIView alloc]init];
        _topView.backgroundColor=[UIColor whiteColor];
    }
    return _topView;
}
- (UIButton *)leftBtn{
    if (_leftBtn==nil) {
        _leftBtn=[[UIButton alloc]init];
        [_leftBtn setTitle:@"看房行程" forState:UIControlStateNormal];
        [_leftBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _leftBtn.tag=100;
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
- (UIButton *)rightBtn{
    if (_rightBtn==nil) {
        _rightBtn=[[UIButton alloc]init];
        [_rightBtn setTitle:@"带看行程" forState:UIControlStateNormal];
        [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _rightBtn.tag=101;
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
- (UIView *)lineView{
    if (_lineView==nil) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=[UIColor redColor];
    }
    return _lineView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    [self initWithNavBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的预约";
    [self loadData];
    self.view.backgroundColor=SeparationLineColor;
    [self setUpSubviews];

}

- (void)loadData{
    
    NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=user&a=yuyue",URLSTR];
    NSString * username= NSUSER_DEF(USERINFO)[@"username"];
    NSDictionary * param=@{@"username":username};
    [ZYWHttpEngine AllPostURL:urlStr params:param success:^(id responseObj) {
        
    } failure:^(NSError *error) {
        
    }];
}




- (void)setUpSubviews{
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.leftBtn];
    [self.topView addSubview:self.rightBtn];
    [self.topView addSubview:self.lineView];
    [self.view addSubview:self.tableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    if (!didConstraints) {
        
        __weak typeof (self) weakSelf=self;
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.top.mas_equalTo(64);
            make.height.mas_equalTo(44);
        }];
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.bottom.mas_equalTo(0);
            make.right.equalTo(weakSelf.topView.mas_centerX).offset(0);
            
        }];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.topView.mas_centerX).offset(0);
            make.top.and.right.and.bottom.mas_equalTo(0);
        }];
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.equalTo(weakSelf.leftBtn.mas_bottom).offset(0);
            make.height.mas_equalTo(1);
            make.width.equalTo(weakSelf.leftBtn.mas_width);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.topView.mas_bottom).offset(1);
            make.left.and.right.and.bottom.mas_equalTo(0);
        }];
        didConstraints=YES;
    }
}

//有数据  显示列表页
- (void)initWithHandListTableView{

    UITableView * tableView=[[UITableView alloc]init];
    [self.view addSubview:tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(108);
        make.left.and.right.and.bottom.mas_equalTo(0);
    }];
    self.tableView=tableView;
    
    tableView.delegate=self;
    tableView.dataSource=self;
    
    
}

#pragma mark----UITableViewDelegate/UITableViewDataSource--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppointCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HandRoomDetailVC * vc=[[HandRoomDetailVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initWithNavBar{
    UIButton * left=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [left setImage:[UIImage imageNamed:@"barback_01"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarBtn=[[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem=leftBarBtn;
    
}
- (void)back:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)topAction:(UIButton *)button{
    if (button.tag==100) {//左边的 刷新表
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
        }];
    } else{//右边的 刷新表
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kMainScreenWidth*0.5);
        }];
    }
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
