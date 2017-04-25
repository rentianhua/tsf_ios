//
//  TSFRentEntrustVC.m
//  TaoShenFang
//
//  Created by YXM on 17/1/17.
//  Copyright © 2017年 RA. All rights reserved.
//

#import "TSFRentEntrustVC.h"

#import "ZYWHttpEngine.h"
#import "KSAlertView.h"
#import "AreaModel.h"
#import "OtherHeader.h"
#import "SaleFirstKindCell.h"//售价、楼层
#import "MyHandOtherCell.h"
#import "HouseModel.h"
#import "ReturnInfoModel.h"

#import "TSFLouCengView.h"
#import "TWSelectCityView.h"//区域选择
#import "TSFOtherPickView.h"//楼层属性 低层 高层

#import <AFNetworking.h>
#import "SelectCoordinatesVC.h"

#import "YJProgressHUD.h"
#import "UIImage+UIImageScale.h"
#import "YJProgressHUD.h"

#import <MJExtension.h>

#import "TSFPicsModel.h"
#import "TSFAreaModel.h"
#import "UserModel.h"

#import "SearchXiaoQuVC.h"
#import "TSFUploadImgVC.h"

#import "TSFPickerView.h"
#import "MyRentVC.h"
#import <IQKeyboardManager.h>

#define CELL0 @"cell0"
#define CELL1 @"cell1"
#define CELL2 @"cell2"
#define HIDECELL @"hideCell"

#define NAVBTNW 20


@interface TSFRentEntrustVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


@property (nonatomic,strong)MyRentVC * rentVC;
@property (nonatomic,strong)NSArray * leftTitles;

@property (nonatomic,strong)UIButton * leftNavBtn;


@property (nonatomic,strong)UIView * footerView;

@property (nonatomic,strong)UIButton * issueBtn;

@property (nonatomic,strong)NSArray * huxinArray;
@property (nonatomic,strong)NSArray * areaArray;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)SelectCoordinatesVC * vc;

@property (nonatomic,copy)NSString * coorStr;

@property (nonatomic,strong)NSMutableArray * pics;

@property (nonatomic,strong)UserModel * usermodel;
@property (nonatomic,strong)IQKeyboardManager * manager;
@end

@implementation TSFRentEntrustVC
- (MyRentVC *)rentVC{
    if (_rentVC==nil) {
        _rentVC=[[MyRentVC alloc]init];
    }
    return _rentVC;
}
- (UIView *)footerView{
    if (_footerView==nil) {
        _footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 80)];
        [_footerView addSubview:self.issueBtn];
    }
    return _footerView;
}

- (UIButton *)issueBtn{
    if (_issueBtn==nil) {
        _issueBtn=[[UIButton alloc]initWithFrame:CGRectMake(30, 20, kMainScreenWidth-60, 40)];
        _issueBtn.backgroundColor=NavBarColor;
        [_issueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_issueBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_issueBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _issueBtn.layer.masksToBounds=YES;
        _issueBtn.layer.cornerRadius=5;
        [_issueBtn addTarget:self action:@selector(issueAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _issueBtn;
}

- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}
- (NSArray *)leftTitles{
    if (_leftTitles==nil) {
        _leftTitles=@[
                      @[@"*房源区域",@"*小区名称"],
                      @[@"*租金",@"*面积"],
                      @[@"*户型",@"*地图坐标",@"上传图片",@"*发布方式",@"手机号码"]];
    }
    return _leftTitles;
}

- (NSMutableArray *)pics{
    if (_pics==nil) {
        _pics=[NSMutableArray array];
    }
    return _pics;
}


- (NSArray *)huxinArray{
    if (_huxinArray==nil) {
        _huxinArray=@[@[@"1室",@"2室",@"3室",@"4室",@"5室",@"5室以上"],@[@"0厅",@"1厅",@"2厅",@"3厅",],@[@"1卫",@"2卫",@"3卫"]];
    }
    return _huxinArray;
}

- (void)setModel:(HouseModel *)model{
    _model=model;
    self.pics=_model.pics;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _manager=[IQKeyboardManager sharedManager];
    _manager.enableAutoToolbar=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
        //业主委托
    self.navigationItem.title=@"业主委托";
   
    
    
    if (_model==nil) {
        _model=[[HouseModel alloc]init];
    }
    
    self.view.backgroundColor=UIColorFromRGB(0Xf0eff5);;
    [self initWithTableView];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    
    SelectCoordinatesVC * vc=[[SelectCoordinatesVC alloc]init];
    vc.coorBlock=^(NSString *corStr){
        _coorStr=corStr;
        _model.jingweidu=corStr;
        NSIndexPath * indexPath=[NSIndexPath indexPathForRow:1 inSection:2];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    self.vc=vc;
    
    
    [self loadUserData];
}


- (void)loadUserData{//获取用户信息  判断是否申请分机号
    NSDictionary * param=@{@"userid":NSUSER_DEF(USERINFO)[@"userid"]};
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    __weak typeof(self)weakSelf=self;
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=Member&m=Public&a=api_getuserinfo",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            UserModel * model=[UserModel mj_objectWithKeyValues:responseObj];
            weakSelf.usermodel=model;
        }
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
    }];
    
    
}



- (void)initWithTableView{
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView=tableView;
    tableView.delegate=self;
    tableView.dataSource=self;
    
    [tableView registerNib:[UINib nibWithNibName:@"MyHandOtherCell" bundle:nil] forCellReuseIdentifier:CELL0];
    [tableView registerNib:[UINib nibWithNibName:@"SaleFirstKindCell" bundle:nil] forCellReuseIdentifier:CELL1];
    [tableView registerNib:[UINib nibWithNibName:@"MyHandOtherCell" bundle:nil] forCellReuseIdentifier:CELL2];
    [tableView registerNib:[UINib nibWithNibName:@"TSFHideNumCell" bundle:nil] forCellReuseIdentifier:HIDECELL];
    
    tableView.tableFooterView=self.footerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.leftTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.leftTitles[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * leftTitle=self.leftTitles[indexPath.section][indexPath.row];
    switch (indexPath.section) {
        case 0:{
            MyHandOtherCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL0 forIndexPath:indexPath];
            cell.leftLabel.text=leftTitle;
            switch (indexPath.row) {
                case 0:{
                    
                    switch (indexPath.row) {
                        case 0:{
                            if (_model.cityname==nil || _model.areaname==nil) {
                                cell.rightLabel.text=@"";
                            } else{
                                cell.rightLabel.text=[NSString stringWithFormat:@"%@ %@",_model.cityname,_model.areaname];
                            }
                            
                        }
                            break;
                        case 1:
                            cell.rightLabel.text=_model.xiaoquname;
                            break;
                            
                        default:
                            break;
                    }
                }
                    
                    break;
                    
                default:
                    cell.rightLabel.text=_model.xiaoquname;
                    break;
            }
            return cell;
        }
            
            break;
        case 1:{
            NSArray * array=@[@"元/月",@"㎡"];
            SaleFirstKindCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL1 forIndexPath:indexPath];
            cell.leftLabel.text=leftTitle;
            cell.rightLabel.text=array[indexPath.row];
            cell.centerText.delegate=self;
            cell.centerText.tag=100+indexPath.section*10+indexPath.row;
            cell.centerText.returnKeyType=UIReturnKeyDone;
            switch (indexPath.row) {
                case 0:
                    cell.centerText.text=_model.zujin;
                    cell.centerText.keyboardType=UIKeyboardTypeNumberPad;
                    break;
                default:
                    cell.centerText.text=_model.mianji;
                    cell.centerText.keyboardType=UIKeyboardTypeNumberPad;
                    break;
            }
            
            return cell;
        }
            
            break;
            
            
        default:{
            
                MyHandOtherCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL2 forIndexPath:indexPath];
                cell.leftLabel.text=leftTitle;
                switch (indexPath.row) {
                    case 0:
                        if ([_model.shi isEqualToString:@"6"]) {
                            cell.rightLabel.text=[NSString stringWithFormat:@"5室以上%@厅%@卫",_model.ting,_model.wei];
                        } else{
                            cell.rightLabel.text=[NSString stringWithFormat:@"%@室%@厅%@卫",_model.shi,_model.ting,_model.wei];
                        }
                        break;
                    case 1:
                        cell.rightLabel.text=_model.jingweidu;
                        break;
                    case 2:
                        if ([self.pics isKindOfClass:[NSString class]]) {
                            NSArray * array=[TSFPicsModel mj_objectArrayWithKeyValuesArray:self.pics];
                            cell.rightLabel.text=[NSString stringWithFormat:@"已上传%ld张图片",array.count];
                            
                        } else if ([self.pics isKindOfClass:[NSMutableArray class]]){
                            cell.rightLabel.text=[NSString stringWithFormat:@"已上传%ld张图片",self.pics.count];
                        }
                        break;
                    case 3:{
                        if ([_model.pub_type isEqualToString:@"2"]){
                            cell.rightLabel.text=@"委托给经纪人";
                        } else if ([_model.pub_type isEqualToString:@"3"]){
                            cell.rightLabel.text=@"委托给平台";
                        }
                    }
                        
                        break;
                    case 4:{
                        if (NSUSER_DEF(USERINFO)!=nil) {
                            cell.rightLabel.text=NSUSER_DEF(USERINFO)[@"username"];
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
                return cell;
            }
            break;
        }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    __weak typeof(self)weakSelf=self;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:{
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
                                weakSelf.model.area=[NSString stringWithFormat:@"%@",disModel.ID];                                weakSelf.model.provincename=proviceModel.name;
                                weakSelf.model.cityname=cityModel.name;
                                weakSelf.model.areaname=disModel.name;
                                
                                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                
                            }];
                        }
                        
                        
                    } failure:^(NSError *error) {
                        [YJProgressHUD hide];
                        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
                    }];
                }
                    break;
                    
                default:{
                    //跳转搜索小区
                    if (_model.area==nil || _model.area.length==0) {
                        [YJProgressHUD showMessage:@"请先选择区域" inView:self.view];
                        return;
                    } else{
                        SearchXiaoQuVC * VC=[[SearchXiaoQuVC alloc]init];
                        VC.area=_model.area;
                        VC.xiaoquBlock=^(NSString * xiaoquname){
                            _model.xiaoquname=xiaoquname;
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        };
                        [self.navigationController pushViewController:VC animated:YES];
                    }
                    
                }
                    break;
            }
            break;
        case 2:{
            
            switch (indexPath.row) {
                case 0:{//户型
                    TSFPickerView * pick=[[TSFPickerView alloc]initWithFrame:self.view.bounds selectTitle:@"选择" allArray:self.huxinArray];
                    [pick showView:^(NSString *str1, NSString *str2, NSString *str3) {
                        
                        if ([str1 isEqualToString:@"5室以上"]) {
                            weakSelf.model.shi=@"6";
                        } else{
                            weakSelf.model.shi=[[str1 componentsSeparatedByString:@"室"] firstObject];
                        }
                        
                        weakSelf.model.ting=[[str2 componentsSeparatedByString:@"厅"] firstObject];
                        weakSelf.model.wei=[[str3 componentsSeparatedByString:@"卫"] firstObject];
                        
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }];
                    
                }
                    
                    break;
                case 1:{
                    [self.navigationController pushViewController:self.vc animated:YES];
                }
                    
                    break;
                case 2:{
                    TSFUploadImgVC * VC=[[TSFUploadImgVC alloc]init];
                    VC.pics=_model.pics;
                    VC.picsBlock=^(NSMutableArray * pics){
                        
                        weakSelf.model.pics=[TSFPicsModel mj_objectArrayWithKeyValuesArray:pics];
                        weakSelf.pics=weakSelf.model.pics;
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    };
                    [self.navigationController pushViewController:VC animated:YES];
                }
                    
                    
                    break;
                case 3:{
                    //业主委托
                    NSArray * array=@[@"委托给经纪人",@"委托给平台"];
                   
                    
                    TSFOtherPickView * pick=[[TSFOtherPickView alloc]initWithFrame:self.view.bounds selectTitle:@"" array:array];
                    [pick showView:^(NSString *str) {
                         if ([str isEqualToString:@"委托给经纪人"]){
                            weakSelf.model.pub_type=@"2";
                        } else {
                            weakSelf.model.pub_type=@"3";
                        }
                        
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }];
                }
                    
                    break;
                case 4:{
                    NSArray * array=nil;
                    if (_usermodel.ctel==nil || _usermodel.ctel.length==0) {
                        array=@[@"公开",@"保密(请至个人中心申请分机号)"];
                    } else{
                        array=@[@"公开",@"保密"];
                    }
                    __weak typeof(self)weakSelf=self;
                    
                    TSFOtherPickView * pick=[[TSFOtherPickView alloc]initWithFrame:self.view.bounds selectTitle:@"" array:array];
                    [pick showView:^(NSString *str) {
                        
                        if (weakSelf.usermodel.ctel==nil || weakSelf.usermodel.ctel.length==0){
                            if ([str isEqualToString:array[1]]) {
                                [YJProgressHUD showMessage:@"请至个人中心申请分机号" inView:weakSelf.view];
                                weakSelf.model.hidetel=@"";
                            }else{
                                weakSelf.model.hidetel=str;
                                
                            }
                        } else{
                            weakSelf.model.hidetel=str;
                            
                        }
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }];
                }
                    
                    break;
                    
                default:
                    break;
            }
        }
            
            break;
            
        default:
            break;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 110:
            _model.zujin=textField.text;
            break;
            
        default:
            _model.mianji=textField.text;
            break;
    }
    
    
    return YES;
}



- (void)issueAction:(UIButton *)button{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)to:nil from:nil forEvent:nil];
    
    
    if (_model.area.length==0 ) {
        [YJProgressHUD showMessage:@"请输入房源区域" inView:self.view];
        return;
    }
    if ( _model.xiaoquname.length==0) {
        [YJProgressHUD showMessage:@"请输入小区名称" inView:self.view];
        return;
    }
    
    if ( _model.zujin.length==0) {
        [YJProgressHUD showMessage:@"请输入租金" inView:self.view];
        return;
    }
    if ( _model.mianji.length==0) {
        [YJProgressHUD showMessage:@"请填写面积" inView:self.view];
        return;
    }
    
    if (_model.shi.length==0) {
        [YJProgressHUD showMessage:@"请选择户型" inView:self.view];
        return;
    }
    if ( _model.jingweidu.length==0) {
        [YJProgressHUD showMessage:@"请输入经纬度" inView:self.view];
        return;
    }
    if ( _model.pub_type.length==0) {
        [YJProgressHUD showMessage:@"请选择发布方式" inView:self.view];
        return;
    }
    _model.hidetel=@"公开";
    
    NSString * username=NSUSER_DEF(USERINFO)[@"username"];
    NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
    _model.modelid=@"35";
    _model.userid=userid;
    _model.username=username;
    _model.title=[NSString stringWithFormat:@"%@%@%@",_model.cityname,_model.areaname,_model.xiaoquname];
    
    NSArray * picsArray=[HouseModel mj_keyValuesArrayWithObjectArray:_model.pics ];
    NSString * pics=[self toStringWith:picsArray];
    _model.pics=pics;
    
    _model.idcard=@"";
    _model.contract=@"";
    NSDictionary * param=[_model mj_keyValues];
    __weak typeof(self)weakSelf=self;
    
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=add_chuzu",URLSTR] params:param success:^(id responseObj) {
            if (responseObj) {
                ReturnInfoModel * infomodel=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                [YJProgressHUD showMessage:infomodel.info inView:weakSelf.view];
                if ([infomodel.success isEqual:@149]) {
                    dispatch_time_t poptime=dispatch_time(DISPATCH_TIME_NOW, (int64_t ) (2.0*NSEC_PER_SEC));
                    dispatch_after(poptime, dispatch_get_main_queue(), ^{
                        
                        
                        [weakSelf.navigationController pushViewController:weakSelf.rentVC animated:YES];
                        
                        
                        
                    });
                    
                }else {
                    [YJProgressHUD showMessage:@"发布失败，请检查填写的信息" inView:weakSelf.view];
                }
            }
            
        } failure:^(NSError *error) {
            
        }];
    
    
}

- (NSString*) toStringWith : (id) data {
    _model.pics=self.pics;
    
    if (data==nil) {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
    
}


- (void)back:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
