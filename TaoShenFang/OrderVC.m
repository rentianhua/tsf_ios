//
//  OrderVC.m
//  TaoShenFang
//
//  Created by YXM on 16/9/22.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "OrderVC.h"
#import "HouseModel.h"
#import "UserModel.h"
#import "TSFOrderModel.h"
#import "ReturnInfoModel.h"
#import <MJExtension.h>
#import "OtherHeader.h"
#import "PersonalCell.h"
#import <Masonry.h>
#import "ZYWHttpEngine.h"
#import "TSFOtherPickView.h"
#import "YJProgressHUD.h"

@interface OrderVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIButton * button;
@property (nonatomic,strong)NSMutableArray * dateArray;
@property (nonatomic,strong)NSArray * timeArray;
@property (nonatomic,copy)NSString * dateString;
@property (nonatomic,copy)NSString * timeString;

@property (nonatomic,strong)TSFOrderModel * ordermodel;

@property (nonatomic,strong)UIButton * leftNavBtn;

@end

@implementation OrderVC

- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}
- (TSFOrderModel *)ordermodel{
    if (_ordermodel==nil) {
        _ordermodel=[[TSFOrderModel alloc]init];
    }
    return _ordermodel;
}
- (NSArray *)timeArray{
    if (_timeArray==nil) {
        _timeArray=@[@"09:00-12:00",@"13:00-15:00"];
    }
    return _timeArray;
}
- (NSMutableArray *)dateArray{
    if (_dateArray==nil) {
       _dateArray=[NSMutableArray array];
    }
    return _dateArray;
    
}
- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]init];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.scrollEnabled=NO;
        [_tableView registerClass:[PersonalCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}
- (UIButton *)button{
    if (_button==nil) {
        _button=[[UIButton alloc]init];
        [_button setTitle:@"确定预约" forState:UIControlStateNormal];
        [_button setBackgroundColor:NavBarColor];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_button addTarget:self action:@selector(orderAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"预约看房";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate =(id)self;
    
    [self setupSubviews];
    [self getDate];
}

- (void)getDate{
    //今天：
    NSDate *  senddate=[NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components0 = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:senddate];
    [components0 setDay:([components0 day])];
    NSDate *todayDate = [gregorian dateFromComponents:components0];
    NSDateFormatter *dateday0 = [[NSDateFormatter alloc] init];
    [dateday0 setDateFormat:@"yyyy-MM-dd"];
    NSString * today=[dateday0 stringFromDate:todayDate];
    
    [self.dateArray addObject:today];
    
    //明天
    [components0 setDay:([components0 day]+1)];
    NSDate *TomorrowDate = [gregorian dateFromComponents:components0];
    NSDateFormatter *dateday1 = [[NSDateFormatter alloc] init];
    [dateday1 setDateFormat:@"yyyy-MM-dd"];
    NSString * Tomorrow=[dateday1 stringFromDate:TomorrowDate];
    
    [self.dateArray addObject:Tomorrow];
    //后天
    [components0 setDay:([components0 day]+1)];
    NSDate *afterTomorrowDate = [gregorian dateFromComponents:components0];
    NSDateFormatter *dateday2 = [[NSDateFormatter alloc] init];
    [dateday2 setDateFormat:@"yyyy-MM-dd"];
    NSString * afterTomorrow=[dateday1 stringFromDate:afterTomorrowDate];
    
    [self.dateArray addObject:afterTomorrow];
    
    
}

- (void)setModel:(HouseModel *)model{
    _model=model;
}


- (void)setupSubviews{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.button];
    [self.view updateConstraintsIfNeeded];
}
- (void)updateViewConstraints{
    [super updateViewConstraints];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(124);
        make.height.mas_equalTo(160);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.rightLabel.hidden=NO;
    if (indexPath.row==0) {
        cell.leftLabel.text=@"看房日期";
        cell.rightLabel.text=_dateString;
    } else{
        cell.leftLabel.text=@"看房时间段";
        cell.rightLabel.text=_timeString;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        TSFOtherPickView * otherPick=[[TSFOtherPickView alloc]initWithFrame:self.view.bounds selectTitle:@"选择看房日期" array:self.dateArray];
        [otherPick showView:^(NSString *str) {
            _dateString=str;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    } else {
        TSFOtherPickView * otherPick=[[TSFOtherPickView alloc]initWithFrame:self.view.bounds selectTitle:@"选择看房时间段" array:self.timeArray];
        [otherPick showView:^(NSString *str) {
            
            _timeString=str;
             [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
 
    }
   

}

//确定预约
- (void)orderAction:(UIButton * )button{
    
    self.ordermodel.fromid=_model.ID;
    self.ordermodel.fromtable=@"ershou";
    if (_model.jjr_id==nil ) {//普通用户发布的
        self.ordermodel.fromuserid=_model.userid;
        
    } else{
        self.ordermodel.fromuserid=[NSString stringWithFormat:@"%@",_model.jjr_id];
    }
    self.ordermodel.username=NSUSER_DEF(USERINFO)[@"username"];
    self.ordermodel.type=@"二手房";
    self.ordermodel.yuyuedate=_dateString;
    self.ordermodel.yuyuetime=_timeString;
    self.ordermodel.t=@"1";
    
    NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=house&a=yuyue_add",URLSTR];
    __weak typeof(self)weakSelf=self;
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    [ZYWHttpEngine AllPostURL:urlStr params:[self.ordermodel mj_keyValues] success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            ReturnInfoModel * infomodel=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
            [YJProgressHUD showMessage:infomodel.info inView:self.view];
            if ([infomodel.success isEqual:@96]) {
                dispatch_time_t t=dispatch_time(DISPATCH_TIME_NOW, (int64_t) 2.0*NSEC_PER_SEC );
                dispatch_after(t, dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }
            
        }
        
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
    }];

 
}

- (void)pop:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
