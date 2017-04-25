//
//  BorkerRentSaleVC.m
//  TaoShenFang
//
//  Created by YXM on 16/8/31.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "BorkerRentSaleVC.h"
#import "YJProgressHUD.h"
#import "UIImage+UIImageScale.h"
#import "OtherHeader.h"
#import "KSAlertView.h"
#import "SelectCoordinatesVC.h"
#import "MyHandOtherCell.h"//产权性质
#import "SaleFirstKindCell.h"//售价、楼层

#import "TWSelectCityView.h"//区域选择
#import "TSFOtherPickView.h"//楼层属性 低层 高层
#import "TSFPickerView.h"//户型 1室1厅1卫
#import "TSFMultiPickerView.h"//标签 地铁线

#import "HMDatePickView.h"

#import <AFNetworking.h>
#import "YJProgressHUD.h"
#import "AreaModel.h"
#import "HouseModel.h"
#import "ZYWHttpEngine.h"
#import "TSFPicsModel.h"
#import <MJExtension.h>
#import "SearchXiaoQuVC.h"
#import "IssueEditTitleVC.h"
#import "TSFUploadImgVC.h"
#import "TSFLouCengView.h"
#import "ReturnInfoModel.h"//返回信息
#import "TSFAreaModel.h"
#import <IQKeyboardManager.h>

#define NAVBTNW 20
#define ITEMSIZEW (kMainScreenWidth-40)/3
#define ITEMSIZEH ITEMSIZEW *2/3
#define COLLROWH 110

#define CELL0 @"cell0"
#define CELL1 @"cell1"
#define CELL2 @"cell2"
#define CELL3 @"cell3"

@interface BorkerRentSaleVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>


@property (nonatomic,strong)NSArray * leftTitles;
@property (nonatomic,strong)NSMutableArray * zongcengArray;
@property (nonatomic,strong)NSArray * cengArray;
@property (nonatomic,strong)NSArray * jianzhuArray;
@property (nonatomic,strong)NSArray * chuzuArray;
@property (nonatomic,strong)NSArray * fukuanArray;
@property (nonatomic,strong)NSArray * biaoQianArray;

@property (nonatomic,strong)NSMutableArray * pics;

@property (nonatomic,strong)NSArray * huxinArray;
@property (nonatomic,strong)NSArray * fangwushuxingArray;
@property (nonatomic,strong)NSArray * fangwupeitaoArray;
@property (nonatomic,strong)NSArray * ditieArray;
@property (nonatomic,strong)NSArray * areaArray;
@property (nonatomic,strong)NSArray * wuyeArray;
@property (nonatomic,strong)NSArray *xiaoqutypeArray;
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)SelectCoordinatesVC * vc;

@property (nonatomic,copy)NSString * coorStr;

@property (nonatomic,strong)UIButton * leftNavBtn;

@property (nonatomic,strong)UIView * footerView;
@property (nonatomic,strong)UIButton * issueBtn;

@property (nonatomic,copy)NSString * ditiexianString;
@property (nonatomic,strong)IQKeyboardManager * manager;

@end

@implementation BorkerRentSaleVC

/*
 不限 商品房 村委统建 开发商建设 个人自建房 广东省军区军产房 武警部队军产房 工业长租房 工业产权房 其他
*/
- (NSArray *)wuyeArray{
    if (_wuyeArray==nil) {
        _wuyeArray=@[@"商品房",@"村委统建",@"开发商建设",@"个人自建房",@"广东省军区军产房",@"武警部队军产房",@"工业长租房",@"工业产权房",@"其他"];
    }
    return _wuyeArray;
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

- (UIView *)footerView{
    if (_footerView==nil) {
        _footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 80)];
        [_footerView addSubview:self.issueBtn];
    }
    return _footerView;
}

- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

- (NSArray *)biaoQianArray{
    if (_biaoQianArray==nil) {
        _biaoQianArray=@[@"随时看房",@"精装"];
    }
    return _biaoQianArray;
}
- (NSArray *)jianzhuArray{
    if (_jianzhuArray==nil) {
        _jianzhuArray=@[@"塔楼", @"板楼", @"板塔结合"];
    }
    return _jianzhuArray;
}
- (NSArray *)chuzuArray{
    if (_chuzuArray==nil) {
        _chuzuArray=@[@"整租",@"合租"];
    }
    return _chuzuArray;
}
- (NSArray *)fukuanArray{
    if (_fukuanArray==nil) {
        _fukuanArray=@[@"付一压二",@"付一压三",@"付一压一",@"付三压一",@"其他"];
    }
    return _fukuanArray;
}
- (NSArray *)xiaoqutypeArray{
    if (_xiaoqutypeArray==nil) {
        _xiaoqutypeArray=@[@"小区房",@"独栋"];
    }
    return _xiaoqutypeArray;
}
- (NSArray *)cengArray{
    if (_cengArray==nil) {
        _cengArray=@[@"低层",@"中层",@"高层"];
    }
    return _cengArray;
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
  @[@"*房源区域:",@"*小区名称:"],
  @[@"*租金:",@"*面积:",@"*房龄:"],
  @[@"*地图坐标:",@"上传图片:",@"*户型:",@"房屋属性:",@"*楼层:",@"建筑类型:",@"物业类型:",@"出租方式:",@"支付方式:",@"小区类型:",@"房屋配套:",@"地铁:",@"标签:"],
  @[@"*标题:",@"*房源描述:",@"*房源地址:",@"户型介绍:",@"房源亮点:",@"出租原因:",@"小区介绍:",@"装修描述:",@"周边配套:",@"交通出行:",@"业主说:"]];
    }
    return _leftTitles;
}


- (NSMutableArray *)pics{
    if (_pics==nil) {
        _pics=[NSMutableArray array];
    }
    return _pics;
}
- (NSArray *)ditieArray{
    if (_ditieArray==nil) {
        _ditieArray=@[@"1号线(罗宝线)",@"2号线(蛇口线)",@"3号线(龙岗线)",@"4号线(龙华线)",@"5号线(环中线)",@"7号线",@"9号线",@"11号线"];
    }
    return _ditieArray;
}

- (NSArray *)fangwupeitaoArray{
    if (_fangwupeitaoArray==nil) {
        _fangwupeitaoArray=@[@"空调",@"热水器",@"冰箱",@"洗衣机",@"电视",@"宽带",@"床",@"家具",@"天然气"];
    }
    return _fangwupeitaoArray;
}
- (NSArray *)fangwushuxingArray{
    if (_fangwushuxingArray==nil) {
        _fangwushuxingArray=@[@[@"毛坯",@"简装",@"精装"],@[@"南",@"北",@"东",@"西",@"南北"],@[@"住宅",@"公寓",@"写字楼",@"商铺",@"其他"]];
    }
    return _fangwushuxingArray;
}

- (NSArray *)huxinArray{
    if (_huxinArray==nil) {
        _huxinArray=@[@[@"1室",@"2室",@"3室",@"4室",@"5室",@"5室以上",],@[@"0厅",@"1厅",@"2厅",@"3厅",],@[@"1卫",@"2卫",@"3卫"]];
    }
    return _huxinArray;
}

- (void)setModel:(HouseModel *)model{
    _model=model;
    self.pics=_model.pics;
    if (_model.ditiexian!=nil) {
        if (![_model.ditiexian containsString:@","]) {
            _ditiexianString=[NSString stringWithFormat:@"%@号线",_model.ditiexian];
        } else{
            
        }
    }
    
    //_ditiexianString=
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _manager=[IQKeyboardManager sharedManager];
    _manager.enableAutoToolbar=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"发布出租房";
    
     self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    if (_model==nil) {
        _model=[[HouseModel alloc]init];
    }

    self.view.backgroundColor=UIColorFromRGB(0Xf0eff5);;
    [self initWithTableView];
   
    SelectCoordinatesVC * vc=[[SelectCoordinatesVC alloc]init];
    vc.coorBlock=^(NSString * coorStr){
        _coorStr=coorStr;
        NSIndexPath * indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
        _model.jingweidu=coorStr;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    };
    self.vc=vc;
    
}
- (void)initWithTableView{
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView=tableView;
    tableView.delegate=self;
    tableView.dataSource=self;
  
    [tableView registerNib:[UINib nibWithNibName:@"MyHandOtherCell" bundle:nil] forCellReuseIdentifier:CELL0];//小区
    
    [tableView registerNib:[UINib nibWithNibName:@"SaleFirstKindCell" bundle:nil] forCellReuseIdentifier:CELL1];
    
    [tableView registerNib:[UINib nibWithNibName:@"MyHandOtherCell" bundle:nil] forCellReuseIdentifier:CELL2];//租金
    
    [tableView registerNib:[UINib nibWithNibName:@"MyHandOtherCell" bundle:nil] forCellReuseIdentifier:CELL3];//标题
    
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
            MyHandOtherCell  *  cell=[tableView dequeueReusableCellWithIdentifier:CELL0 forIndexPath:indexPath];
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
                    
                default:
                    cell.rightLabel.text=_model.xiaoquname;
                    break;
            }
            return cell;
        }
            
            break;
        case 1:{
            NSArray * array=@[@"元/月",@"㎡",@"年"];

            SaleFirstKindCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL1 forIndexPath:indexPath];
            cell.leftLabel.text=leftTitle;
            cell.centerText.tag=100+indexPath.section*10+indexPath.row;
            cell.centerText.delegate=self;
            cell.centerText.keyboardType=UIKeyboardTypeNumberPad;
            cell.centerText.returnKeyType=UIReturnKeyDone;
            switch (indexPath.row) {
                case 0:
                    cell.centerText.text=_model.zujin;
                    break;
                case 1:
                    cell.centerText.text=_model.mianji;
                    break;
                default:
                    cell.centerText.text=_model.fangling;
                    break;
            }
            
            cell.rightLabel.text=array[indexPath.row];
            return cell;
        }
            
            break;
        case 2:{
            MyHandOtherCell  *  cell=[tableView dequeueReusableCellWithIdentifier:CELL2 forIndexPath:indexPath];
            cell.leftLabel.text=leftTitle;
            switch (indexPath.row) {
                case 0:
                    cell.rightLabel.text=_model.jingweidu;
                    break;
                case 1:{
                    if ([self.pics isKindOfClass:[NSString class]]) {
                        NSArray * array=[TSFPicsModel mj_objectArrayWithKeyValuesArray:self.pics];
                      cell.rightLabel.text=[NSString stringWithFormat:@"已上传%ld张图片",array.count];
                        
                    } else if ([self.pics isKindOfClass:[NSMutableArray class]]){
                      cell.rightLabel.text=[NSString stringWithFormat:@"已上传%ld张图片",self.pics.count];
                    }
                
                }
                    break;
                case 2:{
                    if (_model.shi==nil || _model.ting==nil || _model.wei==nil) {
                        cell.rightLabel.text=@"";
                    } else{
                        
                        if ([_model.shi isEqualToString:@"6"]) {
                           cell.rightLabel.text=[NSString stringWithFormat:@"5室以上 %@厅 %@卫",_model.ting,_model.wei];
                        } else{
                           cell.rightLabel.text=[NSString stringWithFormat:@"%@室 %@厅 %@卫",_model.shi,_model.ting,_model.wei];
                        }
                     
                    }
                }
                    
                    break;
                case 3:{
                         cell.rightLabel.text=[NSString stringWithFormat:@"%@ %@ %@",_model.zhuangxiu,_model.leixing,_model.chaoxiang];
                    
                }
                    break;
                case 4:
                    if (_model.ceng==nil || _model.zongceng==nil) {
                       cell.rightLabel.text=@"";
                    }  else{
                        cell.rightLabel.text=[NSString stringWithFormat:@"%@ 共%@层",_model.ceng,_model.zongceng];
                    }
                    break;
                case 5:
                    cell.rightLabel.text=_model.jianzhutype;
                    break;
                case 6:
                    cell.rightLabel.text=_model.wuyetype;
                    break;
                case 7://chuzutype
                    cell.rightLabel.text=_model.zulin;
                    break;
                case 8://paytype
                    cell.rightLabel.text=_model.fukuan;
                    break;
                case 9:
                    cell.rightLabel.text=_model.xiaoqutype;
                    break;
                case 10:
                    cell.rightLabel.text=_model.fangwupeitao;
                    break;
                case 11:
                {
                    if (_model.ditiexian.length!=0) {
                        NSArray * strArr=[_model.ditiexian componentsSeparatedByString:@","];
                        NSMutableArray * reArr=[NSMutableArray array];
                        for ( int i=0; i<strArr.count; i++) {
                            NSString * str=strArr[i];
                            NSString * restr=[NSString stringWithFormat:@"%@号线",str];
                            [reArr addObject:restr];
                        }
                         cell.rightLabel.text=[reArr componentsJoinedByString:@","];
                       
                    }

                }
                    break;
                    
                default:
                    cell.rightLabel.text=_model.biaoqian;
                    break;
            }
            return cell;
        }
            
            break;
            
        default:{
            MyHandOtherCell  *  cell=[tableView dequeueReusableCellWithIdentifier:CELL2 forIndexPath:indexPath];
            
            cell.leftLabel.text=leftTitle;
            switch (indexPath.row) {
                case 0:
                    cell.rightLabel.text=_model.title;
                    break;
                case 1:
                    cell.rightLabel.text=_model.desc;
                    break;

                case 2:
                    cell.rightLabel.text=_model.address;
                    break;

                case 3:
                     cell.rightLabel.text=_model.huxingjieshao;
                    break;
                case 4:
                     cell.rightLabel.text=_model.liangdian;
                    break;

                case 5:
                     cell.rightLabel.text=_model.czreason;
                    break;

                case 6:
                     cell.rightLabel.text=_model.xiaoquintro;
                    break;

                case 7:
                     cell.rightLabel.text=_model.zxdesc;
                    break;

                case 8:
                     cell.rightLabel.text=_model.shenghuopeitao;
                    break;
                case 9:
                    cell.rightLabel.text=_model.jiaotong;
                    break;

                default:
                    cell.rightLabel.text=_model.yezhushuo;
                    break;
            }
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}



//点击发布按钮
- (void)issueAction:(UIButton *)button{//发布
    
       [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)to:nil from:nil forEvent:nil];
    NSString * username=NSUSER_DEF(USERINFO)[@"username"];
    NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
    _model.username=username;
    _model.userid=userid;
    _model.modelid=@"36";
    
    self.pics=_model.pics;
    
    NSArray * picsArray=[TSFPicsModel mj_keyValuesArrayWithObjectArray:_model.pics];
    
    NSString * pics=[self toStringWith:picsArray];
    _model.pics=pics;//因为请求的时候将数组封装成字符串了 所以请求完毕恢复
    
    if (_model.province.length==0 || _model.city.length==0 || _model.area.length==0) {
        [YJProgressHUD showMessage:@"请输入房源区域" inView:self.view];
        return;
    }
    if (_model.xiaoquname.length==0) {
        [YJProgressHUD showMessage:@"请输入小区名称" inView:self.view];
        return;
    }
    if (_model.zujin.length==0) {
        [YJProgressHUD showMessage:@"请输入租金" inView:self.view];
        return;
    }
    if (_model.mianji.length==0) {
        [YJProgressHUD showMessage:@"请输入面积" inView:self.view];
        return;
    }
    if (_model.fangling.length==0) {
        [YJProgressHUD showMessage:@"请输入房龄" inView:self.view];
        return;
    }
    if (_model.jingweidu.length==0) {
        [YJProgressHUD showMessage:@"请输入经纬度" inView:self.view];
        return;
    }
    if (_model.shi.length==0 || _model.ting.length==0 || _model.wei.length==0 ) {
        [YJProgressHUD showMessage:@"请输入户型" inView:self.view];
        return;
    }
    if (_model.ceng.length==0 || _model.zongceng.length==0) {
        [YJProgressHUD showMessage:@"请输入楼层" inView:self.view];
        return;
    }
    if (_model.title.length==0) {
        [YJProgressHUD showMessage:@"请输入标题" inView:self.view];
        return;
    }
    if (_model.desc.length==0) {
        [YJProgressHUD showMessage:@"请输入房源描述" inView:self.view];
        return;
    }
    if (_model.address.length==0) {
        [YJProgressHUD showMessage:@"请输入房源地址" inView:self.view];
        return;
    }
    
    _model.idcard=@"";
    _model.contract=@"";
    
    __weak typeof(self)weakSelf=self;
    if (_type==RentBrokerIssueTypeEdit) {//如果是编辑房源
        
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=edit_chuzu",URLSTR] params:[_model mj_keyValues] success:^(id responseObj) {
            
            if (responseObj) {
                ReturnInfoModel * model=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                [YJProgressHUD showMessage:model.info inView:weakSelf.view];
                if ([model.success isEqual:@161]) {
                    
                    dispatch_time_t poptime=dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2.0 * NSEC_PER_SEC));
                    dispatch_after(poptime, dispatch_get_main_queue(), ^{
                      [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                }else {
                    [YJProgressHUD showMessage:@"编辑失败，请检查填写的信息" inView:weakSelf.view];
                }
            }
        } failure:^(NSError *error) {
            [YJProgressHUD showMessage:@"请检查网络设置" inView:weakSelf.view];
        
        }];
        
        
    } else{//发布房源
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=add_chuzu",URLSTR] params:[_model mj_keyValues] success:^(id responseObj) {
            
            if (responseObj) {
                ReturnInfoModel * model=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                [YJProgressHUD showMessage:model.info inView:weakSelf.view];
                
                if ([model.success isEqual:@149]) {
                    dispatch_time_t poptime=dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2.0 * NSEC_PER_SEC));
                    dispatch_after(poptime, dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else {
                    [YJProgressHUD showMessage:@"发布失败，请检查填写的信息" inView:weakSelf.view];
                }
            }
        } failure:^(NSError *error) {
            [YJProgressHUD showMessage:@"请检查网络设置" inView:weakSelf.view];
        }];
        
    }
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

#pragma mark----UITextFieldDelegate-----
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSString * str=textField.text;
    switch (textField.tag) {
        case 110:
            _model.zujin=str;
            break;
        case 111:
            _model.mianji=str;
            break;
        case 112:
            _model.fangling=str;
            break;
            
        default:
            break;
    }

    return YES;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:{//房源区域
                    
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
                    
                default:{//小区名称
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
       
        case 2:
            switch (indexPath.row) {
                case 0://地图
                     [self.navigationController pushViewController:self.vc animated:YES];
                    break;
                case 1:{//上传图片
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
                case 2:{//户型
                    TSFPickerView * pick=[[TSFPickerView alloc]initWithFrame:self.view.bounds selectTitle:@"选择" allArray:self.huxinArray];
                    [pick showView:^(NSString *str1, NSString *str2, NSString *str3) {
                        if ([str1 isEqualToString:@"5室以上"]) {
                           _model.shi=@"6";
                        } else{
                             _model.shi=[[str1 componentsSeparatedByString:@"室"] firstObject];
                        }
                        
                        
                            _model.ting=[[str2 componentsSeparatedByString:@"厅"] firstObject];
                            _model.wei=[[str3 componentsSeparatedByString:@"卫"] firstObject];
                        
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }];

                }
                    
                    break;
                case 3:{//房屋属性
                    TSFPickerView * pick=[[TSFPickerView alloc]initWithFrame:self.view.bounds selectTitle:@"选择" allArray:self.fangwushuxingArray];
                    [pick showView:^(NSString *str1, NSString *str2, NSString *str3) {
                            _model.zhuangxiu=str1;
                            _model.chaoxiang=str2;
                            _model.leixing=str3;
                        
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }];

                }
                    
                    break;
                case 4:{//楼层
                    NSArray * array=@[self.cengArray,self.zongcengArray];
                    
                    TSFLouCengView * louceng=[[TSFLouCengView alloc]initWithFrame:self.view.bounds selectTitle:@"" allArray:array];
                    [louceng showView:^(NSString *str1, NSString *str2) {
                        _model.ceng=str1;
                        NSString * leftStr=[str2 componentsSeparatedByString:@"层"][0];
                        _model.zongceng=[leftStr componentsSeparatedByString:@"共"][1];
                        
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        
                    }];
                    

                }
                    
                    break;
                case 5://建筑类型
                    [self pickerViewWithArray:self.jianzhuArray indexPath:indexPath];
                    break;
                case 6://建筑类型
                    [self pickerViewWithArray:self.wuyeArray indexPath:indexPath];
                    break;
                case 7://出租方式
                    [self pickerViewWithArray:self.chuzuArray indexPath:indexPath];
                    break;
                case 8://支付方式
                    [self pickerViewWithArray:self.fukuanArray indexPath:indexPath];
                    break;
                case 9://小区类型
                    [self pickerViewWithArray:self.xiaoqutypeArray indexPath:indexPath];
                    break;
                case 10://房屋配套
                    [self mulPickerWithArray:self.fangwupeitaoArray indexPath:indexPath];
                    break;
                case 11://地铁
                    [self mulPickerWithArray:self.ditieArray indexPath:indexPath];
                    break;
                    
                default://标签
                    [self mulPickerWithArray:self.biaoQianArray indexPath:indexPath];
                    break;
            }
            break;
        case 3:{/*标题",@"房源描述",@"房源地址",@"户型介绍",@"房源亮点",@"出租原因",@"小区介绍",@"装修描述",@"周边配套",@"交通出行",@"业主说"*/
            IssueEditTitleVC * VC=[[IssueEditTitleVC alloc]init];
            switch (indexPath.row) {
                case 0:{
                    VC.string=_model.title;
                    VC.num=30;
                    VC.textblock=^(NSString * text){
                        _model.title=text;
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    };

                }
                    
                    break;
                case 1:{
                    VC.string=_model.desc;
                    VC.textblock=^(NSString * text){
                        _model.desc=text;
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    };
                }
                    
                    
                    break;

                case 2:{
                    VC.string=_model.address;
                    VC.num=30;
                    VC.textblock=^(NSString * text){
                        _model.address=text;
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    };
                }
                    
                    break;

                case 3:{
                    VC.string=_model.huxingjieshao;
                    VC.num=500;
                    VC.textblock=^(NSString * text){
                        _model.huxingjieshao=text;
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    };
                }
                    
                    break;

                case 4:{
                    VC.string=_model.liangdian;
                    VC.num=500;
                    VC.textblock=^(NSString * text){
                        _model.liangdian=text;
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    };
                }
                    
                    break;

                case 5:{
                    VC.string=_model.czreason;
                    VC.num=500;
                    VC.textblock=^(NSString * text){
                        _model.czreason=text;
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    };
                }
                    
                    break;

                case 6:{
                    VC.string=_model.xiaoquintro;
                    VC.num=500;
                    VC.textblock=^(NSString * text){
                        _model.xiaoquintro=text;
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    };
                }
                    
                    break;

                case 7:{
                    VC.string=_model.zxdesc;
                    VC.num=500;
                    VC.textblock=^(NSString * text){
                        _model.zxdesc=text;
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    };
                }
                    
                    break;

                case 8:{
                    VC.string=_model.shenghuopeitao;
                    VC.num=500;
                    VC.textblock=^(NSString * text){
                        _model.shenghuopeitao=text;
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    };
                }
                    
                    break;

                case 9:{
                    VC.string=_model.jiaotong;
                    VC.num=500;
                    VC.textblock=^(NSString * text){
                        _model.jiaotong=text;
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    };
 
                }
                    
                    break;

                case 10:{
                    VC.string=_model.yezhushuo;
                    VC.num=500;
                    VC.textblock=^(NSString * text){
                        _model.yezhushuo=text;
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    };

                }
                    
                    break;

                    
                default:
                    break;
                    
            }
            
           [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)pickerViewWithArray:(NSArray *)array indexPath:(NSIndexPath *)indexPath{
    TSFOtherPickView * pick=[[TSFOtherPickView alloc]initWithFrame:self.view.bounds selectTitle:@"请选择" array:array];
    [pick showView:^(NSString *str) {
        switch (indexPath.row) {
            case 5:
                _model.jianzhutype=str;
                break;
            case 6:
                _model.wuyetype=str;
                break;
            case 7:
                _model.zulin=str;
                break;
            case 8:
                _model.fukuan=str;
                break;
            case 9:
                _model.xiaoqutype=str;
                break;
            default:
                break;
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];

}

- (void)mulPickerWithArray:(NSArray *)array indexPath:(NSIndexPath *)indexPath{
    TSFMultiPickerView * pick=[[TSFMultiPickerView alloc]initWithFrame:self.view.frame selectTitle:@"" array:array];
    pick.areaType=AreaTypeN;
    [pick showView:^(NSArray *selectArray) {
        
        
        switch (indexPath.row) {
            case 10:{
                NSString * str=[selectArray componentsJoinedByString:@","];
                _model.fangwupeitao=str;
            }
                break;
            case 11:{
                _ditiexianString=[selectArray componentsJoinedByString:@","];
                NSMutableArray * ditiexianArr=[NSMutableArray array];
                for (int i=0; i<selectArray.count; i++) {
                    NSString * seleStr=selectArray[i];
                    NSString * str1=[[seleStr componentsSeparatedByString:@"号"] firstObject];
                    NSString * str2=[NSString stringWithFormat:@"[%@]",str1];
                    [ditiexianArr addObject:str2];
                }
                NSString * ditieStr=[ditiexianArr componentsJoinedByString:@","];
                _model.ditiexian=ditieStr;
            }
                break;
            case 12:{
                NSString * str=[selectArray componentsJoinedByString:@","];
                _model.biaoqian=str;
            }
                break;
                
            default:
                break;
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _manager.enableAutoToolbar=NO;
}
@end
