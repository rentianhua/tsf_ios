//
//  NewRoomDetailViewController.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/24.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "NewRoomDetailViewController.h"

//=====================
#import "Order.h"
#import "GRpay.h"
//==========================

#import "ZYWHttpEngine.h"
#import "TSFMapButton.h"


#import "OtherHeader.h"
#import "MainSectionView.h"
#import "BuyCouponsViewController.h"
#import "HouseStateController.h"
#import "SDCycleScrollView.h"
#import "TSFBuyYHQView.h"
#import "TSFAgentVC.h"
#import "TSFReferView.h"

#import "HouseModel.h"
#import "TSFHtmlModel.h"

#import "TSFPicsModel.h"
#import "NewHouseModel.h"
#import "IDModel.h"
#import "YSFYhqModel.h"
#import "ReturnInfoModel.h"
#import "TSFDTModel.h"
#import "TSFCareModel.h"
#import "ReturnInfoModel.h"

#import "TSFNewDetailCell.h"
#import "TSFNewDetailOtherCell.h"
#import "LouPanJIeShuoCell.h"
#import "XMYMapViewCell.h"
#import "TSFAddCollectionCell.h"
#import "TSFAddOtherCollectionCell.h"
#import "TSFCommentsCell.h"
#import "TSFNewNoDataCell.h"
#import "TSFNewDTCell.h"
#import "TSFNewRoomCell.h"

#import "LouPanInfoController.h"
#import "MapPositionController.h"
#import "LoginViewController.h"
#import "TSFYhqOrderVC.h"


#import "YJProgressHUD.h"

#import <MJExtension.h>
#import <Masonry.h>
#import "PhotoBroswerVC.h"//图片浏览器
#import <UIImageView+WebCache.h>

//==========加载html==========
#import "HZPhotoBrowser.h"
#import "IMYWebView.h"
//===========================


#define IMGWIDTH kMainScreenWidth
#define IMGHEIGHT IMGWIDTH*0.6
#define BottomViewHeight 50
#define CELL0 @"cell0"//TSFNewDetailCell.h详情
#define CELL1 @"cell1"//LouPanJIeShuoCell.h楼盘动态
#define CELL2 @"cell2"//TSFNewDetailOtherCell.h//楼盘详情
#define CELL3 @"cell3"//户型介绍  UITableViewCell
#define CELL4 @"cell4"//楼盘相册 TSFAddCollectionCell
#define CELL5 @"cell5"//付款方式 UItableViewCell
#define CELL6 @"cell6"//位置及周边 XMYMapViewCell.h
#define CELL7 @"cell7" //TSFCommentsCell.h 楼盘点评
#define CELL8 @"cell8"//推荐楼盘 TSFAddOtherCollectionCell
#define CELLNO @"cellno"
@interface NewRoomDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,MainSectionViewDelegate,IMYWebViewDelegate,HZPhotoBrowserDelegate>

@property (nonatomic,strong)UIButton * care;



@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)UICollectionView * recommcollectionView;//推荐房源
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)SDCycleScrollView * scrollView;
@property (nonatomic,strong)UIView * bottomView;
@property (nonatomic,strong)UIButton * consultBtn;

@property (nonatomic,strong)HouseModel * model;
@property (nonatomic,strong)TSFCareModel * caremodel;


@property (nonatomic,strong)NSMutableArray * albumArray;//楼盘相册
@property (nonatomic,strong)NSMutableArray * albumArray1;//cell楼盘相册
@property (nonatomic,strong)NSArray * secArray;
@property (nonatomic,strong)NSArray * recommandArray;

//导航条

@property (nonatomic,strong)UIButton * leftNavBtn;

//处理html
@property(nonatomic, assign)CGFloat webviewHight;//记录webview的高度
@property(nonatomic, strong)NSMutableArray *imageArray;//HTML中的图片个数
@property(nonatomic, strong)IMYWebView *htmlWebView;

//处理html 付款方式
@property(nonatomic, assign)CGFloat webviewHight1;//记录webview的高度
@property(nonatomic, strong)NSMutableArray *imageArray1;//HTML中的图片个数
@property(nonatomic, strong)IMYWebView *htmlWebView1;

@property (nonatomic,strong)UIImageView * imgView;//已售出
@end
NSInteger tagCount;//全局变量
@implementation NewRoomDetailViewController

- (void)setIdModel:(IDModel *)idModel{
    _idModel=idModel;
}
- (TSFCareModel *)caremodel{
    if (_caremodel==nil) {
        _caremodel=[[TSFCareModel alloc]init];
    }
    return _caremodel;
}

- (UIImageView *)imgView{
    if (_imgView==nil) {
        _imgView=[[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-65, 15, 50, 50)];
        _imgView.image=[UIImage imageNamed:@"yishou_01"];
    }
    return _imgView;
}

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-BottomViewHeight-64) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableHeaderView=self.scrollView;
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"TSFNewDetailCell" bundle:nil] forCellReuseIdentifier:CELL0];
        [_tableView registerNib:[UINib nibWithNibName:@"TSFNewDTCell" bundle:nil] forCellReuseIdentifier:CELL1];
        [_tableView registerNib:[UINib nibWithNibName:@"TSFNewDetailOtherCell" bundle:nil] forCellReuseIdentifier:CELL2];
        [_tableView registerClass:[TSFAddCollectionCell class] forCellReuseIdentifier:CELL4];//楼盘相册
        [_tableView registerClass:[XMYMapViewCell class] forCellReuseIdentifier:CELL6];
        [_tableView registerNib:[UINib nibWithNibName:@"TSFCommentsCell" bundle:nil] forCellReuseIdentifier:CELL7];
        [_tableView registerNib:[UINib nibWithNibName:@"TSFNewRoomCell" bundle:nil] forCellReuseIdentifier:CELL8];//推荐房源
        [_tableView registerNib:[UINib nibWithNibName:@"TSFNewNoDataCell" bundle:nil] forCellReuseIdentifier:CELLNO];
        //
        [_tableView registerNib:[UINib nibWithNibName:@"TSFNewNoDataCell" bundle:nil] forCellReuseIdentifier:@"fukuanfangshiNoData"];
    }
    return _tableView;
}

- (SDCycleScrollView *)scrollView{
    if (_scrollView==nil) {
        _scrollView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, IMGHEIGHT) delegate:self placeholderImage:[UIImage imageNamed:@"card_default"]];
        _scrollView.delegate=self;
        
        [_scrollView addSubview:self.imgView];
        self.imgView.hidden=YES;
    }
    return _scrollView;
}

- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

- (NSMutableArray *)albumArray{
    if (_albumArray==nil) {
        _albumArray=[NSMutableArray array];
    }
    return _albumArray;
}

- (NSArray *)secArray
{
    if (_secArray==nil) {
        _secArray=@[@"楼盘动态",@"楼盘详情",@"户型介绍",@"楼盘相册",@"付款方式",@"位置及周边",@"楼盘点评",@"推荐楼盘"];
    }
    return _secArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    
    
    if (NSUSER_DEF(USERINFO)!=NULL) {
        self.caremodel.fromid=_idModel.ID;
        self.caremodel.fromtable=@"new";
        self.caremodel.userid=NSUSER_DEF(USERINFO)[@"userid"];
        self.caremodel.username=NSUSER_DEF(USERINFO)[@"username"];
        
        [self isCare];
    }
    
    [self loadData];
    [self loadRecommend];
    
    [self.view addSubview:self.tableView];
    [self initBottomView];
    
    [self inithtmlWebView];
    
}


- (void)inithtmlWebView{
    
    _htmlWebView = [[IMYWebView alloc] init];
    _htmlWebView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 1);
    _htmlWebView.delegate = self;
    _htmlWebView.scrollView.scrollEnabled = NO;//设置webview不可滚动，让tableview本身滚动即可
    _htmlWebView.scrollView.bounces = NO;
    _htmlWebView.opaque = NO;
    _htmlWebView.scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    
    _htmlWebView1 = [[IMYWebView alloc] init];
    _htmlWebView1.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 1);
    _htmlWebView1.delegate = self;
    _htmlWebView1.scrollView.scrollEnabled = NO;//设置webview不可滚动，让tableview本身滚动即可
    _htmlWebView1.scrollView.bounces = NO;
    _htmlWebView1.opaque = NO;
    _htmlWebView1.scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)loadData{
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    
    if (self.albumArray1!=NULL) {
        [self.albumArray1 removeAllObjects];
    }
    
    if (self.albumArray!=NULL) {
        [self.albumArray removeAllObjects];
    }
    NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=house&a=api_shows",URLSTR];
    NSDictionary * param=@{@"catid":_idModel.catid,@"id":_idModel.ID};
    [ZYWHttpEngine AllPostURL:urlStr params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            _bottomView.hidden=NO;
            
            HouseModel * model=[HouseModel mj_objectWithKeyValues:responseObj];
            _model=model;
            
            
            self.albumArray1=[NSMutableArray arrayWithObjects:model.loupantupian,model.weizhitu,model.yangbantu,model.shijingtu,model.xiaoqutu, nil];
            
            for (int i=0; i<model.loupantupian.count; i++) {
                TSFPicsModel * pic=model.loupantupian[i];
                [self.albumArray addObject:pic];
            }
            
            for (int i=0; i<model.weizhitu.count; i++) {
                TSFPicsModel * pic=model.weizhitu[i];
                [self.albumArray addObject:pic];
            }
            
            for (int i=0; i<model.yangbantu.count; i++) {
                TSFPicsModel * pic=model.yangbantu[i];
                [self.albumArray addObject:pic];
            }
            
            for (int i=0; i<model.shijingtu.count; i++) {
                TSFPicsModel * pic=model.shijingtu[i];
                [self.albumArray addObject:pic];
            }
            
            for (int i=0; i<model.xiaoqutu.count; i++) {
                TSFPicsModel * pic=model.xiaoqutu[i];
                [self.albumArray addObject:pic];
            }
            
            if ([_model.zaishou isEqualToString:@"0"]) {
                self.imgView.hidden=NO;
                
            } else{
                self.imgView.hidden=YES;
            }
            
            //回到主线程设置
            __weak typeof(self)weakSelf=self;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableArray * imageArray=[NSMutableArray array];
                for (int i=0; i<weakSelf.albumArray.count; i++) {
                    
                    TSFPicsModel * model=weakSelf.albumArray[i];
                    [imageArray addObject:[NSString stringWithFormat:@"%@%@",ImageURL,model.url]];
                    
                }
                
                weakSelf.scrollView.imageURLStringsGroup=imageArray ;
                
                weakSelf.navigationItem.title=_model.title;
                
                if (_model.contacttel==nil || _model.contacttel.length==0) {
                    [weakSelf.consultBtn setTitle:@"联系方式：暂无" forState:UIControlStateNormal];
                } else{
                    [weakSelf.consultBtn setTitle:[NSString stringWithFormat:@"联系方式：%@",_model.contacttel] forState:UIControlStateNormal];
                }
                
                NSString * jsString=  [self exChangeHtml:[NSString stringWithFormat:@"%@/",ImageURL] originHtml:_model.html.huxingintro];
                _htmlWebView.tag=99;
                [weakSelf.htmlWebView loadHTMLString:jsString baseURL:nil];
                
                if(_model.html.fukuanfangshi.length>0)
                {
                    NSString * jsString1=[self exChangeHtml:[NSString stringWithFormat:@"%@/",ImageURL] originHtml:_model.html.fukuanfangshi];
                    _htmlWebView1.tag=100;
                    [weakSelf.htmlWebView1 loadHTMLString:jsString1 baseURL:nil];
                }
                
                [weakSelf.tableView reloadData];
                
            });
            
            
        }
        
    } failure:^(NSError *error) {
        _bottomView.hidden=YES;
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
        
    }];
    
}

- (void)loadRecommend{//获取推荐位数据
    NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=house&a=position",URLSTR];
    NSDictionary * param=@{
                           @"posid":@5
                           };
    __weak typeof(self)weakSelf=self;
    [ZYWHttpEngine AllPostURL:urlStr params:param success:^(id responseObj) {
        
        if (responseObj) {
            self.recommandArray=[NewHouseModel mj_objectArrayWithKeyValuesArray:responseObj];
            [weakSelf.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark--------------SDCycleScrollViewDelegate-------------
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [self networkImageShow:index];
    
}
//图片浏览器显示
-(void)networkImageShow:(NSUInteger)index{
    __weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeTransition index:index photoModelBlock:^NSArray *{
        
        NSArray *networkImages=self.albumArray;
        NSMutableArray * titleArr=[NSMutableArray array];
        NSMutableArray * urlArr=[NSMutableArray array];
        
        for (int i=0; i<self.albumArray.count; i++) {
            TSFPicsModel * model=self.albumArray[i];
            [titleArr addObject:model.alt];
            [urlArr addObject:[NSString stringWithFormat:@"%@%@",ImageURL,model.url]];
        }
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (NSUInteger i = 0; i< networkImages.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = titleArr[i];
            pbModel.image_HD_U = urlArr[i];
            
            //源frame
            UIImageView *imageV =(UIImageView *) weakSelf.scrollView.subviews[i%2];
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}


#pragma mark---------------UITableViewDelegate/UITableViewDataSource-----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_model==nil) {
        tableView.hidden=YES;
    } else{
        tableView.hidden=NO;
    }
    return self.secArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==8) {
        if (_recommandArray.count!=0) {
            return _recommandArray.count;
        } else{
            return 1;
        }
        
    } else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if ([_model.hasyhq isEqualToString:@"1"])
        {
            {
                if(_model.yhq.count>=3)
                    return 325;
                else
                    return 300;
            }
        }
        else
        {
            return 260;
        }
        
    } else if (indexPath.section==1){
        if (_model.dongtai.count==0) {
            return 80;
        } else{
            return 160;
        }
        
    } else if (indexPath.section==2){
        return 130;
    }
    else if (indexPath.section==4){//楼盘相册
        NSInteger items=0;
        if (self.albumArray1.count!=0) {
            NSArray * array1=self.albumArray1[0];
            NSArray * array2=self.albumArray1[1];
            NSArray * array3=self.albumArray1[2];
            NSArray * array4=self.albumArray1[3];
            NSArray * array5=self.albumArray1[4];
            if (array1.count!=0) {
                items=items+1;
            }  if (array2.count!=0) {
                items=items+1;
            } if (array3.count!=0) {
                items=items+1;
            } if (array4.count!=0) {
                items=items+1;
            } if (array5.count!=0) {
                items=items+1;
            }
            
        }
        if (items<4) {
            return 1.31*(kMainScreenWidth - 15*4)/3+30;
        } else{
            return 2*1.31*(kMainScreenWidth - 15*4)/3+45;
        }
        
    } else if (indexPath.section==3){
        
        if (_model.html.huxingintro.length==0) {
            return 80;
        } else{
            return _webviewHight;
        }
    } else if (indexPath.section==5){
        if (_model.html.fukuanfangshi.length==0) {
            return 80;
        } else{
            return _webviewHight1;
        }
    } else if (indexPath.section==7){
        return 160;
    } else if (indexPath.section==8){
        if (_recommandArray.count==0) {
            return 80;
        } else{
            return 120;
        }
    }
    return 280;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView * footer=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    if (!footer) {
        footer=[[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"footer"];
    }
    return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==0) {
        return nil;
    } else{
        MainSectionView * header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
        if (!header) {
            header=[[MainSectionView alloc]initWithReuseIdentifier:@"header" ];
        }
        header.section=section;
        header.rightButton.hidden=NO;
        header.delegate=self;
        header.leftLabel.text=self.secArray[section-1];
        return header;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:{
            TSFNewDetailCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL0 forIndexPath:indexPath];
            cell.label1.text=_model.title;
            cell.label2.text=_model.fangwuyongtu;
            if (_model.junjia.length==0 || [_model.junjia isEqualToString:@"0"]) {
                cell.priceLabel.text=@"价格待定";
            } else{
                cell.priceLabel.text=[NSString stringWithFormat:@"%@元/㎡",_model.junjia];
            }
            NSString * allStr3=[NSString stringWithFormat:@"开盘时间：%@",_model.kaipandate];
            [cell.label3 setAttributedText:[self attrString:@"开盘时间：" withAllString:allStr3]];
            NSString * allStr4=[NSString stringWithFormat:@"交房时间：%@",_model.jiaofangdate];
            [cell.label4 setAttributedText:[self attrString:@"交房时间：" withAllString:allStr4]];
            NSString * allStr5=[NSString stringWithFormat:@"楼盘地址：%@",_model.loupandizhi];
            [cell.label5 setAttributedText:[self attrString:@"楼盘地址：" withAllString:allStr5]];
            NSString * allStr6=[NSString stringWithFormat:@"主力户型：%@",_model.zhulihuxing];
            [cell.label6 setAttributedText:[self attrString:@"主力户型：" withAllString:allStr6]];
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_model.updatetime integerValue]];
            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            NSString * allStr7=[NSString stringWithFormat:@"更新时间：%@",confromTimespStr];
            
            [cell.label7 setAttributedText:[self attrString:@"更新时间：" withAllString:allStr7]];
            NSString * allStr9=[NSString stringWithFormat:@"房源编号：%@",_model.bianhao];
            [cell.label9 setAttributedText:[self attrString:@"房源编号：" withAllString:allStr9]];
            if ([_model.hasyhq isEqualToString:@"1"] && _model.yhq.count>0) {
                cell.yhqBGView.hidden=NO;
                cell.label8.text=@"优惠券：";
                cell.label8.textColor=DESCCOL;
                NSArray * yhqArray=_model.yhq;
                
                if (yhqArray.count==1) {
                    YSFYhqModel * yhqmodel=yhqArray[0];
                    [cell.yhqBtn1 setTitle:yhqmodel.title forState:UIControlStateNormal];
                    [cell.yhqBtn1 addTarget:self action:@selector(yhq1Action:) forControlEvents:UIControlEventTouchUpInside];
                    cell.yhqBtn2.hidden=YES;
                    cell.yhqBtn3.hidden=YES;
                } else if (yhqArray.count==2){
                    YSFYhqModel * yhqmodel=yhqArray[0];
                    [cell.yhqBtn1 setTitle:yhqmodel.title forState:UIControlStateNormal];
                    [cell.yhqBtn1 addTarget:self action:@selector(yhq1Action:) forControlEvents:UIControlEventTouchUpInside];
                    YSFYhqModel * yhqmodel1=yhqArray[1];
                    [cell.yhqBtn2 setTitle:yhqmodel1.title forState:UIControlStateNormal];
                    [cell.yhqBtn2 addTarget:self action:@selector(yhq2Action:) forControlEvents:UIControlEventTouchUpInside];
                    cell.yhqBtn3.hidden=YES;
                }
                else if (yhqArray.count==3){
                    YSFYhqModel * yhqmodel=yhqArray[0];
                    [cell.yhqBtn1 setTitle:yhqmodel.title forState:UIControlStateNormal];
                    [cell.yhqBtn1 addTarget:self action:@selector(yhq1Action:) forControlEvents:UIControlEventTouchUpInside];
                    YSFYhqModel * yhqmodel1=yhqArray[1];
                    [cell.yhqBtn2 setTitle:yhqmodel1.title forState:UIControlStateNormal];
                    [cell.yhqBtn2 addTarget:self action:@selector(yhq2Action:) forControlEvents:UIControlEventTouchUpInside];
                    YSFYhqModel * yhqmodel2=yhqArray[2];
                    [cell.yhqBtn3 setTitle:yhqmodel2.title forState:UIControlStateNormal];
                    [cell.yhqBtn3 addTarget:self action:@selector(yhq3Action:) forControlEvents:UIControlEventTouchUpInside];
                }
            } else{
                cell.yhqBGView.hidden=YES;
            }
            
            
            return cell;
        }
            
            break;
        case 1:{
            if (_model.dongtai.count!=0) {
                TSFNewDTCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL1 forIndexPath:indexPath];
                TSFDTModel * model=_model.dongtai[0];
                cell.label1.text=model.title;
                cell.label2.text=model.descrip;
                cell.label3.text=model.biaoqian;
                return cell;
            } else{
                TSFNewNoDataCell * cell=[tableView dequeueReusableCellWithIdentifier:CELLNO forIndexPath:indexPath];
                return cell;
            }
            
            
        }
            
            break;
            
        case 2:{
            TSFNewDetailOtherCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL2 forIndexPath:indexPath];
            cell.label1.text=@"开发商：";
            cell.label2.text=@"最新开盘：";
            cell.label3.text=@"最早交房：";
            cell.label4.text=@"产权年限：";
            cell.label5.text=_model.kaifashang;
            cell.label6.text=_model.kaipandate;
            cell.label7.text=_model.jiaofangdate;
            cell.label8.text=[NSString stringWithFormat:@"%@年",_model.chanquannianxian];
            return cell;
            
        }
            
            break;
            
        case 3:{
            if (_model.html.huxingintro.length==0) {
                TSFNewNoDataCell * cell=[tableView dequeueReusableCellWithIdentifier:CELLNO forIndexPath:indexPath];
                return cell;
            } else{
                UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL3 ];
                if (!cell) {
                    cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL3];
                    [cell.contentView addSubview:_htmlWebView];
                }
                
                
                return cell;
            }
            
        }
            
            break;
            
        case 4:{//楼盘相册
            TSFAddCollectionCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL4 forIndexPath:indexPath];
            cell.imgArray=self.albumArray1;
            
            NSInteger items=0;
            if (self.albumArray1.count!=0) {
                NSArray * array1=self.albumArray1[0];
                NSArray * array2=self.albumArray1[1];
                NSArray * array3=self.albumArray1[2];
                NSArray * array4=self.albumArray1[3];
                NSArray * array5=self.albumArray1[4];
                if (array1.count!=0) {
                    items=items+1;
                }  if (array2.count!=0) {
                    items=items+1;
                } if (array3.count!=0) {
                    items=items+1;
                } if (array4.count!=0) {
                    items=items+1;
                } if (array5.count!=0) {
                    items=items+1;
                }
                
            }
            if (items<4) {
                cell.collectionView.frame = CGRectMake(0, 0, kMainScreenWidth, 1.31*(kMainScreenWidth - 15*4)/3+30);
            } else{
                cell.collectionView.frame = CGRectMake(0, 0, kMainScreenWidth, 2*1.31*(kMainScreenWidth - 15*4)/3+45);
            }
            
            __weak typeof(self)weakSelf=self;
            cell.selectBlock=^{
                [weakSelf networkImageShow:0];
            };
            return cell;
            
        }
            
            break;
            
        case 5:
        {
            if (_model.html.fukuanfangshi.length==0)
            {
                TSFNewNoDataCell * cell=[tableView dequeueReusableCellWithIdentifier:@"fukuanfangshiNoData" forIndexPath:indexPath];
                return cell;
            }
            else
            {
                UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL5];
                if (!cell)
                {
                    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL5];
                    [cell.contentView addSubview:_htmlWebView1];
                }
                return cell;
            }
        }
            
            break;
            
        case 6:{
            XMYMapViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL6 forIndexPath:indexPath];
            cell.coordinateStr=_model.jingweidu;
            return cell;
            
        }
            break;
        case 7:{
            TSFCommentsCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL7 forIndexPath:indexPath];
            cell.label1.text=[NSString stringWithFormat:@"%@分",_model.dafen_zbpt];
            cell.label2.text=[NSString stringWithFormat:@"%@分",_model.dafen_jt];
            cell.label3.text=[NSString stringWithFormat:@"%@分",_model.dafen_hj];
            cell.label4.text=_model.dianping;
            if ([_model.dafen_zbpt integerValue]<5) {//周边配套
                [cell.xximg15 setImage:[UIImage imageNamed:@"xingxing_02"]];
            } if ([_model.dafen_zbpt integerValue]<4) {
                [cell.xximg15 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg14 setImage:[UIImage imageNamed:@"xingxing_02"]];
            } if ([_model.dafen_zbpt integerValue]<3) {
                [cell.xximg15 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg14 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg13 setImage:[UIImage imageNamed:@"xingxing_02"]];
            }
            if ([_model.dafen_zbpt integerValue]<2) {
                [cell.xximg15 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg14 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg13 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg12 setImage:[UIImage imageNamed:@"xingxing_02"]];
            }
            if ([_model.dafen_zbpt integerValue]<1) {
                [cell.xximg15 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg14 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg13 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg12 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg11 setImage:[UIImage imageNamed:@"xingxing_02"]];
                
            }
            if ([_model.dafen_jt integerValue]<5) {//交通
                [cell.xximg25 setImage:[UIImage imageNamed:@"xingxing_02"]];
            } if ([_model.dafen_jt integerValue]<4) {
                [cell.xximg25 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg24 setImage:[UIImage imageNamed:@"xingxing_02"]];
            } if ([_model.dafen_jt integerValue]<3) {
                [cell.xximg25 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg24 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg23 setImage:[UIImage imageNamed:@"xingxing_02"]];
            }
            if ([_model.dafen_jt integerValue]<2) {
                [cell.xximg25 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg24 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg23 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg22 setImage:[UIImage imageNamed:@"xingxing_02"]];
            }
            if ([_model.dafen_jt integerValue]<1) {
                [cell.xximg25 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg24 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg23 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg22 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg21 setImage:[UIImage imageNamed:@"xingxing_02"]];
                
            }
            if ([_model.dafen_hj integerValue]<5) {//环境
                [cell.xximg35 setImage:[UIImage imageNamed:@"xingxing_02"]];
            } if ([_model.dafen_zbpt integerValue]<4) {
                [cell.xximg35 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg34 setImage:[UIImage imageNamed:@"xingxing_02"]];
            } if ([_model.dafen_zbpt integerValue]<3) {
                [cell.xximg35 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg34 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg33 setImage:[UIImage imageNamed:@"xingxing_02"]];
            }
            if ([_model.dafen_zbpt integerValue]<2) {
                [cell.xximg35 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg34 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg33 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg32 setImage:[UIImage imageNamed:@"xingxing_02"]];
            }
            if ([_model.dafen_zbpt integerValue]<1) {
                [cell.xximg35 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg34 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg33 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg32 setImage:[UIImage imageNamed:@"xingxing_02"]];
                [cell.xximg31 setImage:[UIImage imageNamed:@"xingxing_02"]];
                
            }
            
            return cell;
        }
            break;
        default:{//推荐房源
            if (_recommandArray.count!=0) {
                TSFNewRoomCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL8 forIndexPath:indexPath];
                NewHouseModel * model=_recommandArray[indexPath.row];
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.data.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
                cell.label1.text=model.data.title;
                cell.label2.text=[NSString stringWithFormat:@"%@ %@ %@",model.data.province_name,model.data.city_name,model.data.area_name];
                cell.label3.text=[NSString stringWithFormat:@"%@平米",model.data.mianjiarea];
                cell.label4.text=[NSString stringWithFormat:@"%@元/㎡",model.data.junjia];
                return cell;
            } else{
                TSFNewNoDataCell * cell=[tableView dequeueReusableCellWithIdentifier:CELLNO forIndexPath:indexPath];
                return cell;
            }
            
            
        }
            break;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==8) {
        
        tableView.contentOffset=CGPointMake(0, 0);
        IDModel * idmodel=[[IDModel alloc]init];
        NewHouseModel * model=_recommandArray[indexPath.row];
        idmodel.ID=model.ID;
        idmodel.catid=model.catid;
        _idModel=idmodel;
        [self loadData];
        
        self.caremodel.fromid=model.ID;
        self.caremodel.fromtable=@"new";
        self.caremodel.userid=NSUSER_DEF(USERINFO)[@"userid"];
        self.caremodel.username=NSUSER_DEF(USERINFO)[@"username"];
        self.caremodel.t=@"";
        [self isCare];
        
    }
}

- (NSString *)exChangeHtml:(NSString *)http originHtml:(NSString *)html
{
    
    NSString *originHtml = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta charset=\"utf-8\"><meta content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\" name=\"viewport\" /><meta http-equiv=\"Cache-Control\" content=\"no-cache\" /><meta http-equiv=\"Expires\" content=\"0\" /><meta http-equiv=\"Access-Control-Allow-Origin\" content=\"*\" /><meta name=\"format-detection\" content=\"telephone=no\" /><style> body{ width:100%;padding:0 16px; font-size:14px; margin:0; background-color:#fff;color:#333; font-weight:400; word-break: break-all;}  p{text-align:left;line-height:20px; }img{max-width:220px; height:auto;} div{ text-align:center;}</style></head> <body>%@</body></html>", html];
    
    NSArray *imgArr = [originHtml componentsSeparatedByString:@"<img"];
    
    NSMutableArray *temArr = [NSMutableArray array];
    for (NSString *imgs in imgArr) {
        
        NSRange srcR = [imgs rangeOfString:@"src"];
        if (srcR.location != NSNotFound) {
            
            NSRange imgR = [imgs rangeOfString:@"\""];
            NSString *str1 = [imgs substringToIndex:imgR.location + 1];
            NSString *str2 = [imgs substringFromIndex:imgR.location + 1];
            [temArr addObject:[[str1 stringByAppendingString:http] stringByAppendingString:str2]];
        }else {
            [temArr addObject:imgs];
        }
    }
    
    return [temArr componentsJoinedByString:@"<img"];
}

- (NSMutableAttributedString *)attrString:(NSString *)string withAllString:(NSString *)allString{
    NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:allString];
    NSRange range=[allString rangeOfString:string];
    [attrStr addAttribute:NSForegroundColorAttributeName value:DESCCOL range:range];
    return attrStr;
}

//点击购买优惠券
- (void)yhq1Action:(UIButton *)yuq1Btn{
    
    YSFYhqModel * yhqmodel=_model.yhq[0];
    [self buyYHQ:yhqmodel];
    
}


- (void)yhq2Action:(UIButton *)yuq2Btn{
    
    YSFYhqModel * yhqmodel=_model.yhq[1];
    [self buyYHQ:yhqmodel];
    
}

- (void)yhq3Action:(UIButton *)yuq2Btn{
    
    YSFYhqModel * yhqmodel=_model.yhq[2];
    [self buyYHQ:yhqmodel];
    
}


- (void)buyYHQ:(YSFYhqModel *)yhqmodel{
    if (NSUSER_DEF(USERINFO)==nil) {
        LoginViewController * vc=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    } else{
        
        TSFBuyYHQView * altView=[[TSFBuyYHQView alloc]initWithFrame:self.view.bounds];
        altView.yhqStr=yhqmodel.title;
        [altView setYhqDes:[NSString stringWithFormat:@"使用说明：%@", yhqmodel.descrip == nil ? @"" : yhqmodel.descrip]];
        [self.view addSubview:altView];
        
        NSString * username=NSUSER_DEF(USERINFO)[@"username"];
        
        __weak typeof(self)weakSelf=self;
        __block TSFBuyYHQView * blockView=altView;
        
        altView.codeBlock=^(NSString * num){//获取验证码
            if (num==nil || num.length==0 || num.length!=11) {
                [YJProgressHUD showMessage:@"手机号不正确" inView:weakSelf.view];
                return ;
            }
            NSDictionary * param=@{@"mob":num};
            [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
            [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=sms&a=getyzm_hd",URLSTR] params:param success:^(id responseObj) {
                [YJProgressHUD hide];
                if (responseObj) {
                    ReturnInfoModel * infomodel=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                    [YJProgressHUD showMessage:infomodel.info inView:weakSelf.view];
                    
                    if([infomodel.success integerValue] == 11)
                    {
                        //倒计时
                        __block NSInteger time=59;
                        dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                        dispatch_source_set_event_handler(_timer, ^{
                            if(time <= 0){ //倒计时结束，关闭
                                dispatch_source_cancel(_timer);
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    //设置按钮的样式
                                    [blockView.codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                                    [blockView.codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                    blockView.codeBtn.userInteractionEnabled = YES;
                                });
                                
                            }else{
                                
                                int seconds = time % 60;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    //设置按钮显示读秒效果
                                    [blockView.codeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                                    [blockView.codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                    blockView.codeBtn.userInteractionEnabled = NO;
                                });
                                time--;
                            }
                        });
                        dispatch_resume(_timer);
                    }
                }
            } failure:^(NSError *error) {
                [YJProgressHUD hide];
                [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
            }];
        };
        
        altView.comfirmBlock=^(NSString * name,NSString * num,NSString * code){//立即抢购
            if (name.length==0) {
                [YJProgressHUD showMessage:@"姓名不能为空" inView:self.view];
                return ;
            } else if (num.length==0){
                [YJProgressHUD showMessage:@"手机号码不能为空" inView:self.view];
                return ;
            } else if (code.length==0){
                [YJProgressHUD showMessage:@"验证码不能为空" inView:self.view];
                return ;
            } else if (num.length!=11){
                [YJProgressHUD showMessage:@"手机号格式不正确" inView:self.view];
                return ;
            }
            
            NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
            
            NSDictionary * param=@{@"house_id":_model.ID,
                                   @"coupon_id":yhqmodel.ID,
                                   @"userid":userid,
                                   @"buyname":name,
                                   @"buytel":num,
                                   @"username":username,
                                   @"yzm":code};
            __weak typeof(self)weakSelf=self;
            [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=house&a=coupon_add",URLSTR] params:param success:^(id responseObj) {
                
                if (responseObj) {
                    ReturnInfoModel * model=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                    if ([model.success isEqual:@67]) {
                        
                        //提交订单
                        Product * p=[[Product alloc]init];
                        p.subject=model.result.coupon_name;
                        p.price=model.result.shifu;
                        p.orderId=model.result.order_no;
                        
                        
                        NSNotificationCenter * center=[NSNotificationCenter defaultCenter];
                        [center addObserver:self selector:@selector(payAction:) name:@"coupon" object:nil];
                        
                        
                        //====================================我在这里调了支付宝去支付=====================
                        [GRpay payWithProduct:p resultBlock:^(NSString *rsultString) {
                            
                        }];
                        
                        
                    } else{
                        [YJProgressHUD showMessage:model.info inView:weakSelf.view];
                    }
                }
            } failure:^(NSError *error) {
                [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
            }];
        };
    }
}

- (void)payAction:(NSNotification *)noti{
    
    NSDictionary * userInfodict=noti.userInfo;
    
    NSString * resultStatus=userInfodict[@"resultStatus"];
    
    NSInteger status=[resultStatus integerValue];
    
    NSString * result=userInfodict[@"result"];
    
    if (status==9000) {//订单支付成功
        
        NSData  * strdata=[result dataUsingEncoding:kCFStringEncodingUTF8];
        NSDictionary * resultDict=[NSJSONSerialization JSONObjectWithData:strdata options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary * responseDict=resultDict[@"alipay_trade_app_pay_response"];
        
        NSString * out_trade_no=responseDict[@"out_trade_no"];
        NSString * total_amount=responseDict[@"total_amount"];
        NSString * trade_no=responseDict[@"trade_no"];
        
        
        
        NSDictionary * param=@{@"out_trade_no":out_trade_no,
                               @"total_amount":total_amount,
                               @"trade_no":trade_no,
                               @"resultStatus":resultStatus};
        
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=Api&m=Api&a=app_return_url",URLSTR] params:param success:^(id responseObj) {
            
        } failure:^(NSError *error) {
            
        }];
        
        
    } else if (status==8000){//订单正在处理中
        
    } else if (status==4000){//订单支付失败
        
    } else if (status==6001){//订单取消
        
    } else if (status==6002){//网络链接出错
        
    }
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"coupon" object:nil];
    
}



-(void)webViewDidFinishLoad:(IMYWebView *)webView{
    
    if (webView.tag==100) {
        [self.htmlWebView1 evaluateJavaScript:@"document.documentElement.scrollHeight" completionHandler:^(id object, NSError *error) {
            CGFloat height = [object integerValue];
            
            if (error != nil) {
                
            }else{
                _webviewHight1 = height;
                [_tableView beginUpdates];
                self.htmlWebView1.frame = CGRectMake(0,0, _tableView.frame.size.width, _webviewHight1 );
                [_tableView endUpdates];
                //[self.tableView reloadData];
            }
            
        }];
        
    } else{
        [self.htmlWebView evaluateJavaScript:@"document.documentElement.scrollHeight" completionHandler:^(id object, NSError *error) {
            CGFloat height = [object integerValue];
            
            if (error != nil) {
                
            }else{
                _webviewHight = height;
                [_tableView beginUpdates];
                self.htmlWebView.frame = CGRectMake(0,0, _tableView.frame.size.width, _webviewHight );
                
                [_tableView endUpdates];
                //[self.tableView reloadData];
            }
            
        }];
        
    }
    
    
    
    //    插入js代码，对图片进行点击操作
    [webView evaluateJavaScript:@"function assignImageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0; i < length;i++){img=imgs[i];if(\"ad\" ==img.getAttribute(\"flag\")){var parent = this.parentNode;if(parent.nodeName.toLowerCase() != \"a\")return;}img.onclick=function(){window.location.href='image-preview:'+this.src}}}" completionHandler:^(id object, NSError *error) {
        
    }];
    [webView evaluateJavaScript:@"assignImageClickAction();" completionHandler:^(id object, NSError *error) {
        
    }];
    
    //获取HTML中的图片
    [self getImgs];
    
    
}

-(BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if ([request.URL isEqual:@"about:blank"])
    {
        return true;
    }
    if ([request.URL.scheme isEqualToString: @"image-preview"])
    {
        
        NSString *url = [request.URL.absoluteString substringFromIndex:14];
        
        
        //启动图片浏览器， 跳转到图片浏览页面
        if (_imageArray.count != 0) {
            
            HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
            browserVc.imageCount = self.imageArray.count; // 图片总数
            browserVc.currentImageIndex = [_imageArray indexOfObject:url];//当前点击的图片
            browserVc.delegate = self;
            [browserVc show];
            
        }
        return NO;
        
    }
    
    //    用户点击文章详情中的链接
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        
        return NO;
    }
    
    return YES;
}


#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    //图片浏览时，未加载出图片的占位图
    return [UIImage imageNamed:@"card_default"];
    
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.imageArray[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}
#pragma mark -- 获取文章中的图片个数
- (NSArray *)getImgs
{
    
    NSMutableArray *arrImgURL = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self nodeCountOfTag:@"img"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].src", i];
        [_htmlWebView evaluateJavaScript:jsString completionHandler:^(NSString *str, NSError *error) {
            
            if (error ==nil) {
                [arrImgURL addObject:str];
            }
            
            
            
        }];
    }
    _imageArray = [NSMutableArray arrayWithArray:arrImgURL];
    
    
    return arrImgURL;
}

// 获取某个标签的结点个数
- (NSInteger)nodeCountOfTag:(NSString *)tag
{
    
    NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('%@').length", tag];
    
    int count =  [[_htmlWebView stringByEvaluatingJavaScriptFromString:jsString] intValue];
    
    return count;
}

//图片浏览器显示
-(void)ImageShow:(NSUInteger)index imgArray:(NSMutableArray *)array title:(NSMutableArray *)titleArray{
    __weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeTransition index:index photoModelBlock:^NSArray *{
        
        
        NSArray *networkImages=array;
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (NSUInteger i = 0; i< networkImages.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = titleArray[i];
            pbModel.image_HD_U = networkImages[i];
            
            //源frame
            UIImageView *imageV =(UIImageView *) weakSelf.scrollView.subviews[i%2];
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
    
}

#pragma mark----MainSectionViewDelegate--
- (void)tableView:(UITableView *)tableView sectionDidSelected:(NSInteger)section
{
    
    if (section==1) {
        HouseStateController * vc=[[HouseStateController alloc]init];
        vc.dongtaiArr=_model.dongtai;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (section==2) {
        LouPanInfoController * vc=[[LouPanInfoController alloc]init];
        vc.infomodel=_model;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (section==6){
        MapPositionController * vc=[[MapPositionController alloc]init];
        vc.coorstr=_model.jingweidu;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
//点击关注
- (void)careAction:(UIButton * )button{
    
    if (NSUSER_DEF(USERINFO)==nil) {
        LoginViewController * vc=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        
    } else{
        
        self.caremodel.fromid=_idModel.ID;
        self.caremodel.fromtable=@"new";
        self.caremodel.userid=NSUSER_DEF(USERINFO)[@"userid"];
        self.caremodel.username=NSUSER_DEF(USERINFO)[@"username"];
        self.caremodel.type=@"新房";
        self.caremodel.t=@"1";
        
        [self isCare];
    }
    
}

- (void)isCare{//是否关注
    
    if (NSUSER_DEF(USERINFO)!=NULL) {
        
        NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=house&a=guanzhu_add",URLSTR];
        
        [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
        
        __weak typeof(self)weakSelf=self;
        [ZYWHttpEngine AllPostURL:urlStr params:[self.caremodel mj_keyValues] success:^(id responseObj) {
            [YJProgressHUD hide];
            if (responseObj) {
                ReturnInfoModel * infomodel=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                if ([weakSelf.caremodel.t isEqualToString:@"1"]) {
                    [YJProgressHUD showMessage:infomodel.info inView:self.view];
                }
                if ([infomodel.success isEqual:@89]) {
                    
                    [weakSelf.care setImage:[UIImage imageNamed:@"care"] forState:UIControlStateNormal];
                    [weakSelf.care setTitle:@"已关注" forState:UIControlStateNormal];
                    return ;
                    
                } else if ([infomodel.success isEqual:@90]){
                    [weakSelf.care setImage:[UIImage imageNamed:@"care"] forState:UIControlStateNormal];
                    [weakSelf.care setTitle:@"已关注" forState:UIControlStateNormal];
                    return;
                } else if ([infomodel.success isEqual:@178]){
                    [weakSelf.care setImage:[UIImage imageNamed:@"nocare"] forState:UIControlStateNormal];
                    [weakSelf.care setTitle:@"关注" forState:UIControlStateNormal];
                    
                }
                
            }
            
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
        }];
    }
    
}

- (void)initBottomView
{
    
    UIView * bottomView=[[UIView alloc]init];
    [self.view addSubview:bottomView];
    bottomView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    bottomView.layer.borderWidth=0.8;
    bottomView.backgroundColor=[UIColor whiteColor];
    
    __weak typeof (self)weakSelf=self;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.equalTo(weakSelf.view.mas_bottom).offset(-BottomViewHeight);
    }];
    _bottomView=bottomView;
    
    
    TSFMapButton * care=[[TSFMapButton alloc]init];
    care.backgroundColor=[UIColor whiteColor];
    [care setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [care setTitle:@"关注" forState:UIControlStateNormal];
    [care setImage:[UIImage imageNamed:@"nocare"] forState:UIControlStateNormal];
    [bottomView addSubview:care];
    [care setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [care.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [care addTarget:self action:@selector(careAction:) forControlEvents:UIControlEventTouchUpInside];
    [care mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(60);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    self.care=care;
    UIButton * consultBtn=[UIButton new];
    consultBtn.backgroundColor=[UIColor whiteColor];
    consultBtn.contentMode=UIViewContentModeLeft;
    [consultBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    [consultBtn setTitleColor:NavBarColor forState:UIControlStateNormal];
    [bottomView addSubview:consultBtn];
    self.consultBtn=consultBtn;
    [consultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.mas_equalTo(0);
        make.left.equalTo(care.mas_right).offset(0);
        make.top.mas_equalTo(0);
    }];
    [consultBtn addTarget:self action:@selector(consultAction:) forControlEvents:UIControlEventTouchUpInside];
}

//免费咨询
- (void)consultAction:(UIButton *)button{
    
    if (NSUSER_DEF(USERINFO)==nil) {
        
        LoginViewController * VC=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:VC];
        [self presentViewController:nav animated:YES completion:nil];
        
        
    } else{
        
        if (_model.contacttel==nil || _model.contacttel.length==0 ) {
            
            [YJProgressHUD showMessage:@"暂无联系方式" inView:self.view];
            return;
        }
        
        NSString * phoneStr=_model.contacttel;
        if ([_model.contacttel containsString:@"（"]) {
            phoneStr=[[_model.contacttel componentsSeparatedByString:@"（"] firstObject];
        }
        
        NSMutableString * str=[[NSMutableString alloc]initWithFormat:@"tel:%@",phoneStr];
        UIWebView * callWebView=[[UIWebView alloc]init];
        [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebView];
    }
}

- (void)backAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
