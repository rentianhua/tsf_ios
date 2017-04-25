//
//  TSFIssueUserRentVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/11.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFIssueUserRentVC.h"
#import "ZYWHttpEngine.h"
#import "AreaModel.h"
#import "TWSelectCityView.h"
#import "TSFPickerView.h"
#import "TSFOtherPickView.h"
#import "OtherHeader.h"
#import "MyHandTextCell.h"
#import "MyHandOtherCell.h"
#import "HouseModel.h"
#import <MJExtension.h>
#import "YJProgressHUD.h"

#import "ReturnInfoModel.h"
#import "YJProgressHUD.h"
#import "TSFAreaModel.h"
#define NAVBTNW 20
#define TITLECELL @"titleCell"
#define QUYUCELL @"quyucell"

@interface TSFIssueUserRentVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)HouseModel *model;

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * titleArray;
@property (nonatomic,strong)NSArray * rentalArray;
@property (nonatomic,strong)NSArray * tingArray;


@property (nonatomic,strong)NSArray * areaArray;
@property (nonatomic,strong)UIButton * issueBtn;
@property (nonatomic,strong)UIButton * leftNavBtn;


@end

@implementation TSFIssueUserRentVC

- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)issueBtn{
    if (_issueBtn==nil) {
        _issueBtn=[[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.tableView.frame)+20, kMainScreenWidth-60, 40)];
        _issueBtn.backgroundColor=RGB(237, 27, 36, 1.0);
        [_issueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_issueBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_issueBtn addTarget:self action:@selector(issueAction:) forControlEvents:UIControlEventTouchUpInside];
        [_issueBtn setTitle:@"提交" forState:UIControlStateNormal];
        _issueBtn.layer.masksToBounds=YES;
        _issueBtn.layer.cornerRadius=3;
    }
    return _issueBtn;
}
- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 300) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.scrollEnabled=NO;
        
        [_tableView registerNib:[UINib nibWithNibName:@"MyHandTextCell" bundle:nil] forCellReuseIdentifier:TITLECELL];
        [_tableView registerNib:[UINib nibWithNibName:@"MyHandOtherCell" bundle:nil] forCellReuseIdentifier:QUYUCELL];
        
    }
    return _tableView;
}

- (NSArray *)tingArray{
    if (_tingArray==nil) {
        _tingArray=@[@"1室",@"2室",@"3室",@"4室",@"5室",@"5室以上"];
    }
    return _tingArray;
}
- (NSArray *)rentalArray{
    if (_rentalArray==nil) {
        _rentalArray=@[@"500元以下/月",@"500-1000元/月",@"1000-1500元/月",@"1500-2000元/月",@"3000-4500元/月",@"4500元以上/月"];
    }
    return _rentalArray;
}
- (NSArray *)titleArray{
    if (_titleArray==nil) {
        _titleArray=@[@"个人称呼:",@"手机号码:",@"房源区域:",@"租赁类型:",@"期望厅室:",@"期望租金:"];
    }
    return _titleArray;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"发布求租";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    if (_model==nil) {
        _model=[[HouseModel alloc]init];
    }
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.issueBtn];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<2) {
        MyHandTextCell * cell=[tableView dequeueReusableCellWithIdentifier:TITLECELL forIndexPath:indexPath];
        cell.leftLabel.text=self.titleArray[indexPath.row];
        cell.rightTextField.delegate=self;
        cell.rightTextField.tag=100+indexPath.section*10+indexPath.row;
        if (indexPath.row==0) {
            cell.rightTextField.placeholder=@"请输入称呼";
        } else{
            
            NSString * string=NSUSER_DEF(USERINFO)[@"username"];
            cell.rightTextField.text=string;
            cell.rightTextField.enabled=NO;
        }
        return cell;
    } else{
        MyHandOtherCell * cell=[tableView dequeueReusableCellWithIdentifier:QUYUCELL forIndexPath:indexPath];
        cell.leftLabel.text=self.titleArray[indexPath.row];
        
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 2:{
            __weak typeof(self)weakSelf=self;
            MyHandOtherCell * cell=[tableView cellForRowAtIndexPath:indexPath];
            
            [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
            [ZYWHttpEngine AllGetURL:[NSString stringWithFormat:@"%@g=api&m=house&a=diqu_all",URLSTR] params:nil success:^(id responseObj) {
                [YJProgressHUD hide];
                if (responseObj) {
                    weakSelf.areaArray=[TSFAreaModel mj_objectArrayWithKeyValuesArray:responseObj];
                    
                    TWSelectCityView *city = [[TWSelectCityView alloc] initWithTWFrame:weakSelf.view.bounds TWselectCityTitle:@"选择地区"];
                    city.areaArray=weakSelf.areaArray;
                    [city showCityView:^(TSFAreaModel *proviceModel, TSFAreaModel *cityModel, TSFAreaModel *disModel) {
                        weakSelf.model.province=[NSString stringWithFormat:@"%@",proviceModel.ID];
                        weakSelf.model.city=[NSString stringWithFormat:@"%@",cityModel.ID];
                        weakSelf.model.area=[NSString stringWithFormat:@"%@",disModel.ID];
                        weakSelf.model.provincename=proviceModel.name;
                        weakSelf.model.cityname=cityModel.name;
                        weakSelf.model.areaname=disModel.name;
                        
                        cell.rightLabel.text=[NSString stringWithFormat:@"%@ %@ %@",proviceModel.name,cityModel.name,disModel.name];
                        
                    }];
                    
                    
                    
                }
                
                
            } failure:^(NSError *error) {
                [YJProgressHUD hide];
                [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
            }];
            
        }
            
            break;
        case 3:{
            NSArray * array=@[@"合租",@"整租"];
            MyHandOtherCell * cell=[tableView cellForRowAtIndexPath:indexPath];
            
            TSFOtherPickView * pick=[[TSFOtherPickView alloc]initWithFrame:self.view.bounds selectTitle:@"请选择租赁类型" array:array];
            [pick showView:^(NSString *str) {
                cell.rightLabel.text=str;
                _model.zulin=str;
            }];
            
            
        }
            break;
        case 4:{
            MyHandOtherCell * cell=[tableView cellForRowAtIndexPath:indexPath];
            
            TSFOtherPickView * pick=[[TSFOtherPickView alloc]initWithFrame:self.view.bounds selectTitle:@"户型" array:self.tingArray];
            [pick showView:^(NSString *str) {
                cell.rightLabel.text=str;
                if ([str isEqualToString:@"5室以上"]) {
                    _model.shi=@"6";
                }else{
                    NSArray * array=[str componentsSeparatedByString:@"室"];
                    
                    _model.shi=array[0];
                }
                
            }];
            
        }
            
            break;
        case 5:{
            MyHandOtherCell * cell=[tableView cellForRowAtIndexPath:indexPath];
            
            TSFOtherPickView * pick=[[TSFOtherPickView alloc]initWithFrame:self.view.bounds selectTitle:@"请选择期望租金" array:self.rentalArray];
            
            __weak typeof(self)weakSelf=self;
            
            [pick showView:^(NSString *str) {
                cell.rightLabel.text=str;
                
                if ([str isEqualToString:@"500元以下/月"]) {
                  weakSelf.model.zujinrange=@"0-500";
                } else if ([str isEqualToString:@"4500元以上/月"]){
                    weakSelf.model.zujinrange=@"4500-";
                } else{
                NSString * zujin=[[str componentsSeparatedByString:@"元"] firstObject];
                    weakSelf.model.zujinrange=zujin;
                }
            }];
            
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark----UITextFieldDelegate----
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag==100) {
        _model.chenghu=textField.text;
    }
    return YES;
}


- (void)issueAction:(UIButton * )button{
    
    
    if (_model.chenghu==nil) {
        
        [YJProgressHUD showMessage:@"请输入称呼" inView:self.view];
        
        return;
    }
    if (_model.province==nil || _model.city==nil || _model.area==nil) {
        [YJProgressHUD showMessage:@"请输入房源区域" inView:self.view];
        
        return;
    }
    if (_model.zulin==nil) {
        [YJProgressHUD showMessage:@"请输入租赁类型" inView:self.view];
        
        return;
        
    }
    if (_model.shi==nil) {
        [YJProgressHUD showMessage:@"请输入期望厅室" inView:self.view];
        
        return;
        
    }
    if (_model.zujinrange==nil) {
        [YJProgressHUD showMessage:@"请输入期望租金" inView:self.view];
        
        return;
        
    }
    
    _model.username=NSUSER_DEF(USERINFO)[@"username"];
    _model.title=[NSString stringWithFormat:@"%@%@%@%@%@室%@",_model.provincename,_model.cityname,_model.areaname,_model.zulin,_model.shi,_model.zujin];
    
    NSDictionary * param=[_model mj_keyValues];
    __weak typeof(self)weakSelf=self;
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=qiuzu_add",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            ReturnInfoModel * infomodel=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
            
            [YJProgressHUD showMessage:infomodel.info inView:weakSelf.view];

            if ([infomodel.success isEqual:@111]) {//发布成功
                dispatch_time_t poptime=dispatch_time(DISPATCH_TIME_NOW,
                                                      (int64_t) (2.0*NSEC_PER_SEC));
                dispatch_after(poptime, dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
                
            }
        }
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"请检查网络" inView:weakSelf.view];
    }];
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
