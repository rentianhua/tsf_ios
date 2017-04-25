//
//  BrokerSaleHouseVC.m
//  TaoShenFang
//
//  Created by YXM on 16/8/31.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "BrokerSaleHouseVC.h"
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
#import "TSFAreaModel.h"

#import "ZYWHttpEngine.h"
#import "TSFPicsModel.h"
#import <MJExtension.h>
#import "SearchXiaoQuVC.h"
#import "IssueEditTitleVC.h"
#import "TSFUploadImgVC.h"
#import "TSFLouCengView.h"
#import "ReturnInfoModel.h"//返回信息
#import <IQKeyboardManager.h>
#define NAVBTNW 20

#define ITEMSIZEW (kMainScreenWidth-40)/3
#define ITEMSIZEH ITEMSIZEW *2/3
#define COLLROWH 110

#define CELL0 @"cell0"
#define CELL1 @"cell1"
#define CELL2 @"cell2"
#define CELL3 @"cell3"
#define CELL4 @"cell4"

@interface BrokerSaleHouseVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
}


@property (nonatomic,strong)NSMutableArray * pics;
@property (nonatomic,strong)NSArray * leftTitles;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * loucengArray;
@property (nonatomic,strong)NSArray * huxinArray;
@property (nonatomic,strong)NSArray * fangwushuxingArray;
@property (nonatomic,strong)NSArray * wuyeArray;
@property (nonatomic,strong)NSArray * diyaArray;
@property (nonatomic,strong)NSArray * areaArray;

@property (nonatomic,copy)NSString * coorStr;

@property (nonatomic,strong)SelectCoordinatesVC * vc;//地图坐标

@property (nonatomic,strong)UIButton * leftNavBtn;


@property (nonatomic,strong)UIView * footerView;

@property (nonatomic,strong)UIButton * issueBtn;

@property (nonatomic,strong)NSMutableArray * curcengArray;
@property (nonatomic,strong)NSMutableArray * zongcengArray;

@property (nonatomic,strong)IQKeyboardManager * manager;

@end

@implementation BrokerSaleHouseVC

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


- (NSMutableArray *)pics{
    if (_pics==nil) {
        _pics=[NSMutableArray array];
    }
    return _pics;
}

- (NSArray *)diyaArray{
    if (_diyaArray==nil) {
        _diyaArray=@[@"有抵押",@"无抵押"];
    }
    return _diyaArray;
}
- (NSArray *)wuyeArray{
    if (_wuyeArray==nil) {
        /*
         不限 商品房 村委统建 开发商建设 个人自建房 广东省军区军产房 武警部队军产房 工业长租房 工业产权房 其他
*/
        _wuyeArray=@[@"商品房",@"村委统建",@"开发商建设",@"个人自建房",@"广东省军区军产房",@"武警部队军产房",@"工业长租房",@"工业产权房",@"其他"];
    }
    return _wuyeArray;
}
- (NSArray *)fangwushuxingArray{
    if (_fangwushuxingArray==nil) {
        _fangwushuxingArray=@[@[@"平层",@"复式",@"跃层",@"错层",@"开间",],@[@"毛坯",@"简装",@"精装"],@[@"南",@"北",@"东",@"西",@"南北"]];
    }
    return _fangwushuxingArray;
}
- (NSArray *)loucengArray{
    if (_loucengArray==nil) {
        _loucengArray=@[@"中层",@"低层",@"高层"];
    }
    return _loucengArray;
}
- (NSArray *)huxinArray{
    if (_huxinArray==nil) {
        _huxinArray=@[@[@"1室",@"2室",@"3室",@"4室",@"5室",@"5室以上"],@[@"0厅",@"1厅",@"2厅",@"3厅",],@[@"1卫",@"2卫",@"3卫"]];
    }
    return _huxinArray;
}
- (NSArray *)leftTitles{
    if (_leftTitles==nil) {
        _leftTitles=@[
  @[@"*房源区域:",@"*小区名称:"],
  @[@"*售  价:",@"*建筑面积:",@"*房   龄:",@"楼栋号:",@"单元号:",@"门牌号:",@"套内面积:"],
  @[@"*地图坐标:",@"楼  层:",@"楼层属性:",@"物业类型:",@"抵押信息:",@"户   型:",@"房屋属性:"],
  @[@"上传图片:",@"建筑类型:",@"建筑结构:",@"梯户比例:",@"房屋用途:",@"产权所属:",@"是否有电梯:",@"唯一住宅:",@"挂牌时间:",@"标签:",@"地铁线:"],
  @[@"*标题:",@"*房源描述:",@"投资分析:",@"户型介绍:",@"小区介绍:",@"税费解析:",@"装修描述:",@"周边配套:",@"教育配套:",@"交通出行:",@"核心卖点:",@"小区优势:",@"权属抵押:",@"推荐理由:"]
  ];
    }
    return _leftTitles;
}

- (void)setModel:(HouseModel *)model{
    _model=model;
    self.pics=(NSMutableArray *)_model.pics;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _manager=[IQKeyboardManager sharedManager];
    _manager.enableAutoToolbar=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"发布二手房";
    self.view.backgroundColor=UIColorFromRGB(0Xf0eff5);
    
    if (_model==nil) {
        _model=[[HouseModel alloc]init];
    }
    
    
    [self initWithTableView];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    SelectCoordinatesVC * vc=[[SelectCoordinatesVC alloc]init];
    vc.coorBlock=^(NSString * coorStr){
        _coorStr=coorStr;
        _model.jingweidu=coorStr;
        NSIndexPath * indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
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

    [tableView registerNib:[UINib nibWithNibName:@"MyHandOtherCell" bundle:nil] forCellReuseIdentifier:CELL0];
    [tableView registerNib:[UINib nibWithNibName:@"SaleFirstKindCell" bundle:nil] forCellReuseIdentifier:CELL1];//售价
     [tableView registerNib:[UINib nibWithNibName:@"MyHandOtherCell" bundle:nil] forCellReuseIdentifier:CELL2];
    [tableView registerNib:[UINib nibWithNibName:@"MyHandOtherCell" bundle:nil] forCellReuseIdentifier:CELL3];
    [tableView registerNib:[UINib nibWithNibName:@"MyHandOtherCell" bundle:nil] forCellReuseIdentifier:CELL4];//建筑类型
    
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
            NSArray * array=@[@"万元/套",@"㎡",@"年",@"号",@"单元",@"号",@"㎡"];
            SaleFirstKindCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL1 forIndexPath:indexPath];
            cell.leftLabel.text=leftTitle;
            cell.centerText.delegate=self;
            cell.centerText.tag=100+indexPath.section*10+indexPath.row;
            cell.centerText.returnKeyType=UIReturnKeyDone;
            switch (indexPath.row) {
                case 0:
                    cell.centerText.text=_model.zongjia;
                    cell.centerText.keyboardType=UIKeyboardTypeNumberPad;
                    break;
                case 1:
                    cell.centerText.text=_model.jianzhumianji;
                    cell.centerText.keyboardType=UIKeyboardTypeNumberPad;
                    break;
                case 2:
                    cell.centerText.text=_model.fangling;
                    cell.centerText.keyboardType=UIKeyboardTypeNumberPad;
                    break;
                case 3:
                    cell.centerText.text=_model.loudong;
                    break;
                case 4:
                    cell.centerText.text=_model.danyuan;
                    break;
                case 5:
                    cell.centerText.text=_model.menpai;
                    break;
                case 6:
                    cell.centerText.text=_model.taoneimianji;
                    cell.centerText.keyboardType=UIKeyboardTypeNumberPad;
                    break;
                default:
                    break;
            }
            cell.rightLabel.text=array[indexPath.row];
            return cell;
        }
            
            break;
        case 2:{
            MyHandOtherCell  *  cell=[tableView dequeueReusableCellWithIdentifier:CELL2 forIndexPath:indexPath];
            switch (indexPath.row) {
                case 0:
                    cell.rightLabel.text=_model.jingweidu;
                    break;
                case 1:{
                    if (_model.curceng==nil || _model.zongceng==nil) {
                        cell.rightLabel.text=@"";
                    } else{
                       cell.rightLabel.text=[NSString stringWithFormat:@"%@层 共%@层",_model.curceng,_model.zongceng];
                    }
                }
                    break;
                case 2:
                    cell.rightLabel.text=_model.ceng;
                    break;
                case 3:
                    cell.rightLabel.text=_model.jiaoyiquanshu;
                    break;
                case 4:
                    cell.rightLabel.text=_model.diyaxinxi;
                    break;
                case 5:{
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
                case 6:{
                    if (_model.jiegou==nil || _model.zhuangxiu==nil || _model.chaoxiang==nil) {
                        cell.rightLabel.text=@"";
                    } else{
                        cell.rightLabel.text=[NSString stringWithFormat:@"%@ %@ %@",_model.jiegou,_model.zhuangxiu,_model.chaoxiang];
                    }
                }

                    break;
                    
                default:
                    break;
            }
            cell.leftLabel.text=leftTitle;
            return cell;
        }
            
            break;
        case 3:{
            MyHandOtherCell  *  cell=[tableView dequeueReusableCellWithIdentifier:CELL3 forIndexPath:indexPath];
            cell.leftLabel.text=leftTitle;
            switch (indexPath.row) {
                case 0:{
                    if ([self.pics isKindOfClass:[NSString class]]) {
                        NSArray * array=[TSFPicsModel mj_objectArrayWithKeyValuesArray:self.pics];
                        cell.rightLabel.text=[NSString stringWithFormat:@"已上传%ld张图片",array.count];
                        
                    } else if ([self.pics isKindOfClass:[NSMutableArray class]]){
                        cell.rightLabel.text=[NSString stringWithFormat:@"已上传%ld张图片",self.pics.count];
                    }

//                    cell.rightLabel.text=[NSString stringWithFormat:@"已上传%ld张图片",[self.pics count]];
                }
                    break;
                case 1:
                    cell.rightLabel.text=_model.jianzhutype;
                    break;
                case 2:
                    cell.rightLabel.text=_model.jianzhujiegou;
                    break;
                case 3:
                    cell.rightLabel.text=_model.tihubili;
                    break;
                case 4:
                    cell.rightLabel.text=_model.fangwuyongtu;
                    break;
                case 5:
                    cell.rightLabel.text=_model.chanquansuoshu;
                    break;
                case 6:
                    cell.rightLabel.text=_model.dianti;
                    break;
                case 7:
                    cell.rightLabel.text=_model.isweiyi;
                    break;
                case 8:
                    cell.rightLabel.text=_model.guapaidate;
                    break;
                case 9:
                    cell.rightLabel.text=_model.biaoqian;
                    break;
                case 10:
                    cell.rightLabel.text=_model.ditiexian;
                    break;
                default:
                    break;
            }

            return cell;
        }
            
            break;
        case 4:{
            MyHandOtherCell  *  cell=[tableView dequeueReusableCellWithIdentifier:CELL4 forIndexPath:indexPath];
            cell.leftLabel.text=leftTitle;
            switch (indexPath.row) {
                case 0:
                    cell.rightLabel.text=_model.title;
                    break;
                case 1:
                    cell.rightLabel.text=_model.desc;
                    break;
                case 2:
                    cell.rightLabel.text=_model.touzifenxi;
                    break;
                case 3:
                    cell.rightLabel.text=_model.huxingintro;
                    break;
                case 4:
                    cell.rightLabel.text=_model.xiaoquintro;
                    break;
                case 5:
                    cell.rightLabel.text=_model.shuifeijiexi;
                    break;
                case 6:
                    cell.rightLabel.text=_model.zxdesc;
                    break;
                case 7:
                    cell.rightLabel.text=_model.shenghuopeitao;
                    break;
                case 8:
                    cell.rightLabel.text=_model.xuexiaomingcheng;
                    break;
                case 9:
                    cell.rightLabel.text=_model.jiaotong;
                    break;
                case 10:
                    cell.rightLabel.text=_model.hexinmaidian;
                    break;
                case 11:
                    cell.rightLabel.text=_model.xiaoquyoushi;
                    break;
                case 12:
                    cell.rightLabel.text=_model.quanshudiya;
                    break;
                case 13:
                    cell.rightLabel.text=_model.yezhushuo;
                    break;
                default:
                    break;
            }

            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
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
                case 1:{//跳转搜索小区
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
                    
                default:
                    break;
            }
        }
            
            break;
        
        case 2:{
            if (indexPath.row==0) {//跳转到地图
                [self.navigationController pushViewController:self.vc animated:YES];
            } else if (indexPath.row==1){//楼层
                NSArray * array=@[self.curcengArray,self.zongcengArray];
                
                TSFLouCengView * louceng=[[TSFLouCengView alloc]initWithFrame:self.view.bounds selectTitle:@"" allArray:array];
                [louceng showView:^(NSString *str1, NSString *str2) {
                    _model.curceng=[str1 componentsSeparatedByString:@"层"][0];
                    NSString * leftStr=[str2 componentsSeparatedByString:@"层"][0];
                    _model.zongceng=[leftStr componentsSeparatedByString:@"共"][1];
                    
                     [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                }];
                
                
            } else if (indexPath.row==2 || indexPath.row==3 || indexPath.row==4){
                NSArray * array=@[self.loucengArray,self.wuyeArray,self.diyaArray];
                TSFOtherPickView * pick=[[TSFOtherPickView alloc]initWithFrame:self.view.bounds selectTitle:@"请选择" array:array[indexPath.row -2]];
                [pick showView:^(NSString *str) {
                    switch (indexPath.row) {
                        case 2:
                            _model.ceng=str;
                            break;
                        case 3:
                            _model.jiaoyiquanshu=str;
                            break;
                            
                        default:
                            _model.diyaxinxi=str;
                            break;
                    }
                    
                     [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }];

            } else{//5户型 6房屋属性
                NSArray * array=[NSArray array];
                if (indexPath.row==5) {
                    array=self.huxinArray;
                } else{
                    array=self.fangwushuxingArray;
                }
                
                TSFPickerView * pick=[[TSFPickerView alloc]initWithFrame:self.view.bounds selectTitle:@"选择" allArray:array];
                [pick showView:^(NSString *str1, NSString *str2, NSString *str3) {
                  
                    if (indexPath.row==5) {
                        
                        if ([str1 isEqualToString:@"5室以上"]) {
                           _model.shi=@"6";
                        } else{
                           _model.shi=[[str1 componentsSeparatedByString:@"室"] firstObject];
                        }
                        _model.ting=[[str2 componentsSeparatedByString:@"厅"] firstObject];
                        _model.wei=[[str3 componentsSeparatedByString:@"卫"] firstObject];
                        
                         [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    } else{
                        _model.jiegou=str1;
                        _model.zhuangxiu=str2;
                        _model.chaoxiang=str3;
                        
                         [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 
                    }
                    
                    
                }];
 
            }
        }
            
            break;
        case 3:{
            if (indexPath.row==0) {//上传图片
                TSFUploadImgVC * VC=[[TSFUploadImgVC alloc]init];
                VC.pics=(NSMutableArray *)_model.pics;
                VC.picsBlock=^(NSMutableArray * pics){
                    
                    _model.pics=(NSMutableArray *)[TSFPicsModel mj_objectArrayWithKeyValuesArray:pics];
                    self.pics=(NSMutableArray *)_model.pics;
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                [self.navigationController pushViewController:VC animated:YES];
            } else if (indexPath.row==8){//选择时间
                HMDatePickView * datePickVC=[[HMDatePickView alloc]initWithFrame:self.view.bounds selectTitle:@""];
            
                //距离当前日期的年份差（设置最大可选日期）
                datePickVC.maxYear = -1;
                //设置最小可选日期(年分差)
                //    _datePickVC.minYear = 10;
                datePickVC.date = [NSDate date];
                //设置字体颜色
                datePickVC.fontColor = [UIColor redColor];
                //日期回调
                [datePickVC showView:^(NSString *str1) {
                    _model.guapaidate=str1;
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }];
                
                [self.view addSubview:datePickVC];
            } else if (indexPath.row==9 || indexPath.row==10){
                NSArray * array=[NSArray array];
                NSArray * biaoqianArray=@[@"全明格局",@"全景落地窗",@"厨卫不对门",@"户型方正",@"主卧带卫",@"车位车库"];
                NSArray * ditieArray=@[@"1号线(罗宝线)",@"2号线(蛇口线)",@"3号线(龙岗线)",@"4号线(龙华线)",@"5号线(环中线)",@"7号线",@"9号线",@"11号线"];
                if (indexPath.row==9) {
                    array=biaoqianArray;
                } else{
                    array=ditieArray;
                }
                TSFMultiPickerView * pick=[[TSFMultiPickerView alloc]initWithFrame:self.view.frame selectTitle:@"" array:array];
                pick.areaType=AreaTypeN;
                [pick showView:^(NSArray *selectArray) {
                    
                    
                  
                    if (indexPath.row==9) {
                        NSString * str=[selectArray componentsJoinedByString:@","];
                        _model.biaoqian=str;
                    } else{
                        NSMutableArray * ditieArr=[NSMutableArray array];
                        for (int i=0; i<selectArray.count; i++) {
                            NSString * str=selectArray[i];
                            NSString * ditie=[NSString stringWithFormat:@"[%@]",[[str componentsSeparatedByString:@"号"] firstObject]];
                            [ditieArr addObject:ditie];
                        }
                        
                        NSString * ditiexian=[ditieArr componentsJoinedByString:@","];
                        _model.ditiexian=ditiexian;
                    }
   [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }];

            } else{
                
                NSArray * array=@[
  @[@"塔楼", @"板楼", @"板塔结合"],
  @[@"钢混结构"],
  @[@"三梯六户",@"三梯八户",@"三梯九户",@"两梯三户"],
  @[@"住宅",@"公寓",@"写字楼",@"商铺",@"其他"],
  
  @[@"共有",@"非公有"],
  @[@"有",@"无"],
  @[@"是",@"否"]];
            
                TSFOtherPickView * otherPick=[[TSFOtherPickView alloc]initWithFrame:self.view.bounds selectTitle:@"" array:array[indexPath.row-1]];
                [otherPick showView:^(NSString *str) {
                   
                    switch (indexPath.row) {
                        case 1:
                            _model.jianzhutype=str;
                            break;
                        case 2:
                            _model.jianzhujiegou=str;
                            break;
                            
                        case 3:
                            _model.tihubili=str;
                            break;
                            
                        case 4:
                            _model.fangwuyongtu=str;
                            break;
                            
                        case 5:
                            _model.chanquansuoshu=str;
                            break;
                        case 6:
                            _model.dianti=str;
                            break;

                        case 7:
                            _model.isweiyi=str;
                            break;

                        default:
                            break;
                    }

                     [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                }];

            }
        }
            
            break;
        case 4:{
            IssueEditTitleVC * VC=[[IssueEditTitleVC alloc]init];
           
               
                switch (indexPath.row) {
                    case 0:{//标题
                        VC.string=_model.title;
                        VC.num=30;
                        VC.navigationItem.title=@"标题";
                        VC.textblock=^(NSString * text){
                            _model.title=text;
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        };
                    }
                        break;
                    case 1:{//房源描述
                        VC.string=_model.desc;
                        VC.navigationItem.title=@"房源描述";
                        VC.textblock=^(NSString * text){
                            _model.desc=text;
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        };
                    }
                        break;
                    case 2:{//投资
                        VC.string=_model.touzifenxi;
                        VC.navigationItem.title=@"投资分析";
                        VC.textblock=^(NSString * text){
                            _model.touzifenxi=text;
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        };

                    }
                        break;
                    case 3:{//户型介绍
                        VC.string=_model.huxingintro;
                        VC.navigationItem.title=@"户型介绍";
                        VC.textblock=^(NSString * text){
                            _model.huxingintro=text;
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        };

                    }
                        break;
                    case 4:{//小区介绍
                        VC.string=_model.xiaoquintro;
                        VC.navigationItem.title=@"小区介绍";
                        VC.textblock=^(NSString * text){
                            _model.xiaoquintro=text;
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        };

                    }
                        break;
                    case 5:{//税费解析
                        VC.string=_model.shuifeijiexi;
                        VC.navigationItem.title=@"税费解析";
                        VC.textblock=^(NSString * text){
                            _model.shuifeijiexi=text;
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        };

                    }
                        break;
                    case 6:{//装修描述
                        VC.string=_model.zxdesc;
                        VC.navigationItem.title=@"装修描述";
                        VC.textblock=^(NSString * text){
                            _model.zxdesc=text;
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        };

                    }
                        break;
                    case 7:{//周边配套
                        VC.string=_model.shenghuopeitao;
                        VC.navigationItem.title=@"周边配套";
                        VC.textblock=^(NSString * text){
                            _model.shenghuopeitao=text;
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        };

                    }
                        break;
                    case 8:{//教育配套
                        VC.string=_model.xuexiaomingcheng;
                        VC.navigationItem.title=@"教育配套";
                        VC.textblock=^(NSString * text){
                            _model.xuexiaomingcheng=text;
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        };

                    }
                        break;
                    case 9:{//交通
                        VC.string=_model.jiaotong;
                        VC.navigationItem.title=@"交通配套";
                        VC.textblock=^(NSString * text){
                            _model.jiaotong=text;
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        };

                    }
                        break;
                    case 10:{//核心卖点
                        VC.string=_model.hexinmaidian;
                        VC.navigationItem.title=@"核心卖点";
                        VC.textblock=^(NSString * text){
                            _model.hexinmaidian=text;
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        };

                    }
                        break;
                    case 11:{//小区优势
                        VC.string=_model.xiaoquyoushi;
                        VC.navigationItem.title=@"小区优势";
                        VC.textblock=^(NSString * text){
                            _model.xiaoquyoushi=text;
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        };

                    }
                        break;
                    case 12:{//权属抵押
                        VC.string=_model.quanshudiya;
                        VC.navigationItem.title=@"权属抵押";
                        VC.textblock=^(NSString * text){
                            _model.quanshudiya=text;
                            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        };
                    }
                        
                        break;
                    case 13:{//推荐理由
                        VC.string=_model.yezhushuo;
                        VC.navigationItem.title=@"业主说";
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

- (void)issueAction:(UIButton *)issueBtn{//发布
    
       [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)to:nil from:nil forEvent:nil];
    
    NSString * username=NSUSER_DEF(USERINFO)[@"username"];
    NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
    _model.username=username;
    _model.userid=userid;
    _model.modelid=@"36";
    
    self.pics=(NSMutableArray *)_model.pics;
    
      NSArray * picsArray=[HouseModel mj_keyValuesArrayWithObjectArray:_model.pics];
      NSString * pics=[self toStringWith:picsArray];
      _model.pics=pics;//因为请求的时候将数组封装成字符串了 所以请求完毕恢复
    
    
    if (_model.province.length==0 || _model.city.length==0 || _model.area.length==0) {
        [YJProgressHUD showMessage:@"请选择区域" inView:self.view];

        return;
    }
    if (_model.xiaoquname.length==0) {
        [YJProgressHUD showMessage:@"请输入小区名称" inView:self.view];
        
        return;
    }
    if (_model.zongjia.length==0) {
        [YJProgressHUD showMessage:@"请填写总价" inView:self.view];
        
        return;
    }
    if (_model.jianzhumianji.length==0) {
        [YJProgressHUD showMessage:@"请填写建筑面积" inView:self.view];
        
        return;
    }
    if (_model.fangling.length==0) {
        [YJProgressHUD showMessage:@"请填写房龄" inView:self.view];
        
        return;
    }

    if (_model.jingweidu.length==0) {
        [YJProgressHUD showMessage:@"请填写经纬度" inView:self.view];
        
        return;
    }
       if (_model.title.length==0) {
           [YJProgressHUD showMessage:@"请填写标题" inView:self.view];
        
        return;
    }
    if (_model.desc.length==0) {
        [YJProgressHUD showMessage:@"请填写房源描述" inView:self.view];
        
        return;
    }
   
    _model.idcard=nil;
    _model.contract=nil;
    
    __weak typeof(self)weakSelf=self;
    if (_type==BrokerIssueTypeEdit) {//如果是编辑房源
        
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=edit_ershou",URLSTR] params:[_model mj_keyValues] success:^(id responseObj) {
            
            if (responseObj) {
                ReturnInfoModel * model=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                if ([model.success isEqual:@144]) {
                    [YJProgressHUD showMessage:model.info inView:weakSelf.view];
                    
                    
                 dispatch_time_t poptime=dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2 * NSEC_PER_SEC));
                    
                    dispatch_after(poptime, dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                }else {
                    [YJProgressHUD showMessage:@"编辑失败，请检查填写的信息" inView:weakSelf.view];
                }
            }
        } failure:^(NSError *error) {
            [YJProgressHUD showMessage:@"请检查您的网络" inView:weakSelf.view];
    
        }];

        
    } else{//发布房源
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=add_ershou",URLSTR] params:[_model mj_keyValues] success:^(id responseObj) {
            
            if (responseObj) {
                ReturnInfoModel * model=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                if ([model.success isEqual:@134]) {
                    [YJProgressHUD showMessage:model.info inView:weakSelf.view];
                    
                    dispatch_time_t poptime=dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2 * NSEC_PER_SEC));
                    
                    dispatch_after(poptime, dispatch_get_main_queue(), ^{
                        
                    [self.navigationController popViewControllerAnimated:YES];
                        
 
                    });
                } else {
                    [YJProgressHUD showMessage:@"发布失败，请检查填写的信息" inView:weakSelf.view];
                }
            }
        } failure:^(NSError *error) {
            [YJProgressHUD showMessage:@"请检查您的网络" inView:weakSelf.view];
        }];

    }
}

- (NSString*) toStringWith : (id) data {
    
    _model.pics=self.pics;
    NSError *error = nil;
    
    if (data==nil) return nil;
    
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

#pragma mark----UITextFieldDelegate-----
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
            _model.jianzhumianji=str;
            break;
        case 112:
            _model.fangling=str;
            break;
        case 113:
            _model.loudong=str;
            break;
        case 114:
            _model.danyuan=str;
            break;
        case 115:
            _model.menpai=str;
            break;
        case 116:
            _model.taoneimianji=str;
            break;
            
        default:
            break;
    }

    return YES;
}

- (void)back:(UIBarButtonItem *)batbutton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _manager.enableAutoToolbar=NO;
}


@end
