//
//  TSFHandEntrustVC.m
//  TaoShenFang
//
//  Created by YXM on 17/1/17.
//  Copyright © 2017年 RA. All rights reserved.
//

#import "TSFHandEntrustVC.h"

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

#import <MJExtension.h>

#import "TSFPicsModel.h"
#import "UserModel.h"
#import "TSFAreaModel.h"

#import "SearchXiaoQuVC.h"
#import "TSFUploadImgVC.h"

#import "MyHandVC.h"
#import <IQKeyboardManager.h>

#define CELL0 @"cell0"
#define CELL1 @"cell1"
#define CELL2 @"cell2"
#define HIDECELL @"hideCell"

#define NAVBTNW 20
@interface TSFHandEntrustVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)MyHandVC * handVC;

@property (nonatomic,strong)NSArray * leftTitles;


@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * loucengArray;
@property (nonatomic,strong)NSArray * areaArray;

//上传图片的数量

@property (nonatomic,strong)SelectCoordinatesVC * coorVC;

@property (nonatomic,copy)NSString * coorString;

@property (nonatomic,strong)NSMutableArray * pics;

@property (nonatomic,strong)NSMutableArray * curcengArray;
@property (nonatomic,strong)NSMutableArray * zongcengArray;

@property (nonatomic,strong)SelectCoordinatesVC * vc;//地图坐标

@property (nonatomic,strong)UIButton * leftNavBtn;


@property (nonatomic,strong)UIView * footerView;

@property (nonatomic,strong)UIButton * issueBtn;

@property (nonatomic,strong)UserModel * usermodel;

@property (nonatomic,strong)IQKeyboardManager * manager;

@end

@implementation TSFHandEntrustVC

- (MyHandVC *)handVC{
    if (_handVC==nil) {
        _handVC=[[MyHandVC alloc]init];
    }
    return _handVC;
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


- (NSMutableArray *)curcengArray{
    if (_curcengArray==nil) {
        _curcengArray=[NSMutableArray arrayWithCapacity:0];
        for (int i=-3; i<100; i++) {
            NSString * str=[NSString stringWithFormat:@"%d层",i];
            [_curcengArray addObject:str];
        }
    }
    return _curcengArray;
}
- (NSMutableArray *)zongcengArray{
    if (_zongcengArray==nil) {
        _zongcengArray=[NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<103; i++) {
            NSString * str=[NSString stringWithFormat:@"共%d层",i];
            [_zongcengArray addObject:str];
        }
        
    }
    return _zongcengArray;
}


- (NSArray *)leftTitles{
    if (_leftTitles==nil) {
        _leftTitles=@[
                      @[@"*房源区域",@"*小区名称"],
                      @[@"*售价",@"楼栋号",@"单元号",@"门牌号",@"*称呼"],
                      @[@"楼层",@"楼层属性",@"*地图坐标",@"上传图片",@"*发布方式",@"手机号码"]];
    }
    return _leftTitles;
}

- (NSMutableArray *)pics{
    if (_pics==nil) {
        _pics=[NSMutableArray array];
    }
    return _pics;
}

- (NSArray *)loucengArray{
    if (_loucengArray==nil) {
        _loucengArray=@[@"中层",@"低层",@"高层"];
    }
    return _loucengArray;
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
   
    
    self.view.backgroundColor=UIColorFromRGB(0Xf0eff5);
    
    //创建模型
    if (_model==nil) {
        _model=[[HouseModel alloc]init];
    }
    
    [self initWithTableView];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    
    SelectCoordinatesVC * vc=[[SelectCoordinatesVC alloc]init];
    vc.coorBlock=^(NSString * coorStr){
        _model.jingweidu=coorStr;
        NSIndexPath * indexPath=[NSIndexPath indexPathForRow:2 inSection:2];
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
    
    self.tableView.tableFooterView=self.footerView;
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
            
            return cell;
        }
            break;
        case 1:{
            
            NSArray * array=@[@"万元/套",@"栋",@"单元",@"号",@""];
            SaleFirstKindCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL1 forIndexPath:indexPath];
            cell.leftLabel.text=leftTitle;
            cell.rightLabel.text=array[indexPath.row];
            cell.centerText.delegate=self;
            cell.centerText.tag=100+indexPath.section*10+indexPath.row;
            cell.centerText.returnKeyType=UIReturnKeyDone;
            switch (indexPath.row) {
                case 0:
                    cell.centerText.text=_model.zongjia;
                    cell.centerText.keyboardType=UIKeyboardTypeNumberPad;
                    break;
                case 1:
                    cell.centerText.text=_model.loudong;
                    break;
                    
                case 2:
                    cell.centerText.text=_model.danyuan;
                    
                    break;
                    
                case 3:
                    cell.centerText.text=_model.menpai;
                    break;
                    
                default:
                    cell.centerText.text=_model.chenghu;
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
                        if (_model.curceng==nil || _model.zongceng==nil) {
                            cell.rightLabel.text=@"";
                        } else{
                            cell.rightLabel.text=[NSString stringWithFormat:@"%@层 共%@层",_model.curceng,_model.zongceng];
                        }
                        break;
                    case 1:
                        cell.rightLabel.text=_model.ceng;
                        break;
                    case 2:
                        cell.rightLabel.text=_model.jingweidu;
                        break;
                    case 3:
                        
                        if ([self.pics isKindOfClass:[NSString class]]) {
                            NSArray * array=[TSFPicsModel mj_objectArrayWithKeyValuesArray:self.pics];
                            cell.rightLabel.text=[NSString stringWithFormat:@"已上传%ld张图片",array.count];
                            
                        } else if ([self.pics isKindOfClass:[NSMutableArray class]]){
                            cell.rightLabel.text=[NSString stringWithFormat:@"已上传%ld张图片",self.pics.count];
                        }
                        
                        break;
                    case 4:{
                        if ([_model.pub_type isEqualToString:@"1"]) {
                            cell.rightLabel.text=@"自售";
                        } else if ([_model.pub_type isEqualToString:@"2"]){
                            cell.rightLabel.text=@"委托给经纪人";
                        } else if ([_model.pub_type isEqualToString:@"3"]){
                            cell.rightLabel.text=@"委托给平台";
                        } else{
                            cell.rightLabel.text=@"";
                        }
                    }
                        break;
                        
                    case 5:{
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
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:{
                    __weak typeof(self)weakSelf=self;
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
                                
                                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                
                            }];
                            
                            
                            
                        }
                        
                        
                    } failure:^(NSError *error) {
                        [YJProgressHUD hide];
                        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
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
                case 0:{
                    NSArray * array=@[self.curcengArray,self.zongcengArray];
                    
                    TSFLouCengView * louceng=[[TSFLouCengView alloc]initWithFrame:self.view.bounds selectTitle:@"" allArray:array];
                    [louceng showView:^(NSString *str1, NSString *str2) {
                        _model.curceng=[str1 componentsSeparatedByString:@"层"][0];
                        NSString * leftStr=[str2 componentsSeparatedByString:@"层"][0];
                        _model.zongceng=[leftStr componentsSeparatedByString:@"共"][1];
                        
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        
                    }];
                    
                }
                    
                    break;
                case 1:{
                    TSFOtherPickView * pick=[[TSFOtherPickView alloc]initWithFrame:self.view.bounds selectTitle:@"" array:self.loucengArray];
                    [pick showView:^(NSString *str) {
                        _model.ceng=str;
                        
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }];
                    
                }
                    
                    break;
                case 2:{
                    [self.navigationController pushViewController:self.vc animated:YES];
                }
                    
                    break;
                case 3:{
                    TSFUploadImgVC * VC=[[TSFUploadImgVC alloc]init];
                    VC.pics=_model.pics;
                    VC.picsBlock=^(NSMutableArray * pics){
                        
                        _model.pics=[TSFPicsModel mj_objectArrayWithKeyValuesArray:pics];
                        self.pics=_model.pics;
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    };
                    [self.navigationController pushViewController:VC animated:YES];
                }
                    
                    break;
                case 4:{
                    
                    
                        //业主委托
                        NSArray * array=@[@"委托给经纪人",@"委托给平台"];
                    
                    
                    TSFOtherPickView * pick=[[TSFOtherPickView alloc]initWithFrame:self.view.bounds selectTitle:@"" array:array];
                    [pick showView:^(NSString *str) {
                        if ([str isEqualToString:@"委托给经纪人"]){
                            _model.pub_type=@"2";
                        } else {
                            _model.pub_type=@"3";
                        }
                        
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
#pragma mark----------UITextFieldDelegate----

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSString * str=textField.text;
    switch (textField.tag) {
        case 110:
            _model.zongjia=str;
            break;
        case 111:
            _model.loudong=str;
            break;
        case 112:
            _model.danyuan=str;
            break;
        case 113:
            _model.menpai=str;
            break;
        case 114:
            _model.chenghu=str;
            break;
            
        default:
            break;
    }
    
    return YES;
}
- (NSString*) toStringWith : (id) data {
    
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
- (void)issueAction:(UIButton *)issueBtn{//发布
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)to:nil from:nil forEvent:nil];
    
    NSMutableString *title = [NSMutableString string];
    [title appendString:[NSString stringWithFormat:@"%@%@%@",_model.cityname,_model.areaname,_model.xiaoquname]];
    if(_model.loudong.length>0)
    {
        [title appendFormat:@"%@栋", _model.loudong];
    }
    if(_model.danyuan.length>0)
    {
        [title appendFormat:@"%@单元", _model.danyuan];
    }
    if(_model.menpai.length>0)
    {
        [title appendFormat:@"%@号", _model.menpai];
    }
    _model.title=title;
//    _model.title=[NSString stringWithFormat:@"%@%@%@%@栋%@号",_model.cityname,_model.areaname,_model.xiaoquname,_model.loudong,_model.menpai];
    
    NSString * username=NSUSER_DEF(USERINFO)[@"username"];
    NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
    _model.username=username;
    _model.userid=userid;
    _model.modelid=@"35";
    
    
    
    if ( _model.province.length==0 || _model.city.length==0 || _model.area.length==0 ) {
        [YJProgressHUD showMessage:@"请输入房源区域" inView:self.view];
        return;
    }
    if ( _model.xiaoquname.length==0) {
        [YJProgressHUD showMessage:@"请输入小区名称" inView:self.view];
        return;
    }
    if (_model.zongjia.length==0) {
        [YJProgressHUD showMessage:@"请输入售价" inView:self.view];
        return;
    }
    if ( _model.chenghu.length==0) {
        [YJProgressHUD showMessage:@"请输入称呼" inView:self.view];
        return;
    }
    if ( _model.jingweidu.length==0) {
        [YJProgressHUD showMessage:@"请输入地图坐标" inView:self.view];
        return;
    } if (_model.title.length==0) {
        [YJProgressHUD showMessage:@"请输入标题" inView:self.view];
        return;
    } if ( _model.pub_type.length==0) {
        [YJProgressHUD showMessage:@"请输入发布方式" inView:self.view];
        return;
    }  
    
    _model.hidetel=@"公开";
    
    __weak typeof(self)weakSelf=self;
    NSArray * pics=[TSFPicsModel mj_keyValuesArrayWithObjectArray:_model.pics ];
    _model.pics=[self toStringWith:pics];
    
    _model.idcard=@"";
    _model.contract=@"";
    
    NSDictionary * param=[_model mj_keyValues];
    
  
        [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=add_ershou",URLSTR] params:param success:^(id responseObj) {
            [YJProgressHUD hide];
            if (responseObj) {
                ReturnInfoModel * infomodel=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                [YJProgressHUD showMessage:infomodel.info inView:weakSelf.view];
                if ([infomodel.success isEqual:@134]) {//发布成功
                    dispatch_time_t poptime=dispatch_time(DISPATCH_TIME_NOW,
                                                          (int64_t)(2.0*NSEC_PER_SEC));
                    dispatch_after(poptime, dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController pushViewController:weakSelf.handVC animated:YES];
                    });
                }
            }
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
            
        }];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _manager.enableAutoToolbar=NO;
}


@end
