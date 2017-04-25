//
//  HandRoomDetailVC.m
//  TaoShenFang
//
//  Created by YXM on 16/9/10.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "HandRoomDetailVC.h"
#import <Masonry.h>
#import <UITableViewCell+HYBMasonryAutoCellHeight.h>
#import <MJExtension.h>
#import <SDCycleScrollView.h>
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>

#import "PhotoBroswerVC.h"//图片浏览器
#import "LoginViewController.h"
#import "MapPositionController.h"//地图
#import "OrderVC.h"//预约时间
#import "TSFMoreHandInfoVC.h"
#import "TSFMoreFeatureVC.h"
#import "TSFSeeRecordVC.h"
#import "TSFSuccessRecordVC.h"
#import "MessageViewController.h"//消息界面
#import "TSFAgentVC.h"
#import "TSFCalculatorVC.h"
#import "TSFMessageDetailVC.h"

#import "NewHouseModel.h"
#import "UserModel.h"
#import "IDModel.h"

#import "TSFPicsModel.h"
#import "HouseModel.h"
#import "TSFCareModel.h"//是否关注
#import "TSFOrderModel.h"//是否预约
#import "TSFSeeHouseModel.h"//带看
#import "ReturnInfoModel.h"

#import "KSAlertView.h"//警告框
#import "TSFMapButton.h"//底部按钮
#import "MainSectionView.h"//其他区区头
#import "TSFDetailFooterView.h"
#import "TSFNodataView.h"
#import "TSFReferView.h"//咨询经纪人

#import "OtherHeader.h"
#import "ZYWHttpEngine.h"
#import "YJProgressHUD.h"

#import "HandFeatureCell.h"//房源特色
#import "HandDetailBasicCell.h"//0区
#import "LookRecordCell.h"//带看记录
#import "XMYMapViewCell.h"//地图
#import "BaseRoomCell.h"
#import "TSFHandDetailTitleCell.h"//0
#import "TSFHouseTypeCell.h"//1
#import "TSFHandSuccessCell.h"//

#define IMGWIDTH kMainScreenWidth
#define IMGHEIGHT IMGWIDTH*2/3
#define NAVBTNW 20

#define HEADER @"header"
#define FOOTER @"footer"
#define CELL0 @"cell0"
#define CELL1 @"cell1"
#define CELL2 @"cell2"
#define CELL3 @"cell3"
#define CELL4 @"cell4"
#define CELL5 @"cell5"
#define CELL6 @"cell6"
#define CELL7 @"cell7"
#define CELL8 @"cell8"

@interface HandRoomDetailVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,MainSectionViewDelegate,TSFDetailFooterViewDelegate>{
    BOOL hasYuyue;
}

@property (nonatomic,strong)UIButton * orderBtn;//预约
@property (nonatomic,strong)UIButton * referBtn;//咨询经纪人
@property (nonatomic,strong)TSFMapButton * careBtn;//关注
@property (nonatomic,strong)UIView * bottomView;//
@property (nonatomic,strong)SDCycleScrollView * scrollView;
@property (nonatomic,strong)UILabel  * numlabel;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UIButton * rightNavBtn;
@property (nonatomic,strong)UIImageView * imgView;//已售出


@property (nonatomic,strong)NSMutableArray * imageArray;
@property (nonatomic,strong)NSArray * recommandArray;//推荐位数据  好房推荐
@property (nonatomic,strong)NSArray * leftTitleArray;
@property (nonatomic,strong)NSArray * picArray;
@property (nonatomic,strong)NSArray * successRecordArray;//成交记录
@property (nonatomic,strong)NSArray * daikanArray;//带看记录


@property (nonatomic,strong)HouseModel * data;
@property (nonatomic,strong)TSFCareModel * careModel;
@property (nonatomic,strong)TSFOrderModel * orderModel;



@end

@implementation HandRoomDetailVC

- (UIImageView *)imgView{
    if (_imgView==nil) {
        _imgView=[[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-65, 15, 50, 50)];
        _imgView.image=[UIImage imageNamed:@"yishou_01"];
    }
    return _imgView;
}

- (TSFMapButton *)careBtn{
    if (_careBtn==nil) {
        _careBtn=[[TSFMapButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        [_careBtn setImage:[UIImage imageNamed:@"nocare"] forState:UIControlStateNormal];
        [_careBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_careBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_careBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_careBtn addTarget:self action:@selector(careClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _careBtn;
}

- (UIButton *)orderBtn{
    if (_orderBtn==nil) {
        _orderBtn=[[UIButton alloc]initWithFrame:CGRectMake(60, 0, (kMainScreenWidth-60)*0.5, 40)];
        [_orderBtn setTitle:@"预约看房" forState:UIControlStateNormal];
        [_orderBtn setBackgroundColor:ORGCOL];
        [_orderBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_orderBtn addTarget:self action:@selector(yuyueAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _orderBtn;
}
- (UIButton *)referBtn{
    if (_referBtn==nil) {
        _referBtn=[[UIButton alloc]initWithFrame:CGRectMake((kMainScreenWidth-60)*0.5+60,0 , (kMainScreenWidth-60)*0.5, 40)];
        [_referBtn setTitle:@"立即咨询" forState:UIControlStateNormal];
        [_referBtn setBackgroundColor:NavBarColor];
        [_referBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_referBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_referBtn addTarget:self action:@selector(referAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _referBtn;
}
- (UIView * )bottomView{
    if (_bottomView==nil) {
        _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight-40-64, kMainScreenWidth, 40)];
        _bottomView.backgroundColor=[UIColor whiteColor];
        [_bottomView addSubview:self.careBtn];
        [_bottomView addSubview:self.orderBtn];
        [_bottomView addSubview:self.referBtn];
    }
    return _bottomView;
}
- (TSFCareModel *)careModel{
    if (_careModel==nil) {
        _careModel=[[TSFCareModel alloc]init];
    }
    return _careModel;
}
- (TSFOrderModel * )orderModel{
    if (_orderModel==nil) {
        _orderModel=[[TSFOrderModel alloc]init];
    }
    return _orderModel;
}

- (NSArray *)leftTitleArray{
    if (_leftTitleArray==nil) {
        _leftTitleArray=[NSArray arrayWithObjects:@"房源特色",@"带看记录",@"成交记录",@"周边配套",@"好房推荐", nil];
    }
    return _leftTitleArray;
}
- (UILabel *)numlabel{
    if (_numlabel==nil) {
        _numlabel=[[UILabel alloc]init];
        _numlabel.backgroundColor=[UIColor blackColor];
        _numlabel.textColor=[UIColor whiteColor];
        _numlabel.textAlignment=NSTextAlignmentCenter;
        _numlabel.font=[UIFont systemFontOfSize:14];

        
    }
    return _numlabel;
}
- (SDCycleScrollView *)scrollView{
    if (_scrollView==nil) {
        _scrollView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, IMGHEIGHT) delegate:self placeholderImage:[UIImage imageNamed:@"card_default"]];
        _scrollView.autoScroll=NO;
        _scrollView.showPageControl=NO;
        _scrollView.delegate=self;
        _scrollView.backgroundColor=[UIColor whiteColor];
     
        __weak typeof(self)weakSelf=self;
        [_scrollView addSubview:self.numlabel];
        [weakSelf.numlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.bottom.mas_equalTo(-15);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(21);
        }];
        
        
        [_scrollView addSubview:self.imgView];
        self.imgView.hidden=YES;
        
    }
    return _scrollView;
}

- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

- (UIButton *)rightNavBtn{
    if (_rightNavBtn==nil) {
        _rightNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_rightNavBtn setImage:[UIImage imageNamed:@"btn_chat_new"] forState:UIControlStateNormal];
        [_rightNavBtn addTarget:self action:@selector(toMessageVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNavBtn;
}
- (NSMutableArray *)imageArray{
    if (_imageArray==nil) {
        _imageArray=[NSMutableArray array];
    }
    return _imageArray;
}

- (void)setModel:(HouseModel *)model{
    _model=model;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([NSUSER_DEF(USERINFO)[@"modelid"] isEqualToString:@"35"]) {
        
        NSString * username=NSUSER_DEF(USERINFO)[@"username"];
        NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
        
        self.orderModel.fromid=_model.ID;
        self.orderModel.fromtable=@"ershou";
        self.orderModel.username=username;
        self.orderModel.t=@"";
        
        
        self.careModel.userid=[NSNumber numberWithInteger:[userid integerValue]];
        self.careModel.fromid=_model.ID;
        self.careModel.username=username;
        self.careModel.fromtable=@"ershou";
        self.careModel.t=@"";
        //是否关注
        [self isCare];
        //是否预约
        [self isYuyue];
    }
    [self loadData];
    [self loadRecommend];
    
  
    if (NSUSER_DEF(USERINFO)==nil) {
        self.careBtn.hidden=NO;
        self.orderBtn.hidden=NO;
        self.referBtn.frame=CGRectMake((kMainScreenWidth-60)*0.5+60,0 , (kMainScreenWidth-60)*0.5, 40);
    } else{
        if ([NSUSER_DEF(USERINFO)[@"modelid"] isEqualToString:@"36"]) {
           
                self.careBtn.hidden=YES;
                self.orderBtn.hidden=YES;
                self.referBtn.frame=CGRectMake(0, 0, kMainScreenWidth, 40);
            
        } else{
                self.careBtn.hidden=NO;
                self.orderBtn.hidden=NO;
                self.referBtn.frame=CGRectMake((kMainScreenWidth-60)*0.5+60,0 , (kMainScreenWidth-60)*0.5, 40);
            
           
        }
    }
    
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)toMessageVC{
    
    if ( NSUSER_DEF(USERINFO)==nil) {
        LoginViewController * VC=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:VC ];
        [self presentViewController:nav animated:YES completion:nil];
    } else{
        MessageViewController * VC=[[MessageViewController alloc]init];
        VC.type=MessageTypeBack;
        [self.navigationController pushViewController:VC animated:YES];
    }
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate= (id)self;
    [self initTableView];
    
    
    
}

- (void)initTableView{
    
     _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-40) style:UITableViewStyleGrouped];
    [self.view addSubview:self.bottomView];

    
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerClass:[TSFHandDetailTitleCell class] forCellReuseIdentifier:CELL0];
    //TSFHouseTypeCell.h
    [_tableView registerNib:[UINib nibWithNibName:@"TSFHouseTypeCell" bundle:nil] forCellReuseIdentifier:CELL1];
    [_tableView registerNib:[UINib nibWithNibName:@"HandDetailBasicCell" bundle:nil] forCellReuseIdentifier:CELL2];
    [_tableView registerClass:[HandFeatureCell class] forCellReuseIdentifier:CELL3];
    [_tableView registerNib:[UINib nibWithNibName:@"LookRecordCell" bundle:nil] forCellReuseIdentifier:CELL5];
    [_tableView registerNib:[UINib nibWithNibName:@"TSFHandSuccessCell" bundle:nil] forCellReuseIdentifier:CELL6];
    //XMYMapViewCell.h
    [_tableView registerClass:[XMYMapViewCell class] forCellReuseIdentifier:CELL7];
    //BaseRoomCell.h
    [_tableView registerNib:[UINib nibWithNibName:@"BaseRoomCell" bundle:nil] forCellReuseIdentifier:CELL8];
    //MainSectionView.h
    [_tableView registerClass:[MainSectionView class] forHeaderFooterViewReuseIdentifier:HEADER];
    _tableView.tableHeaderView=self.scrollView;
}

- (void)loadRecommend{//获取推荐位数据
    NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=house&a=position",URLSTR];
    NSDictionary * param=@{
                           @"posid":@8
                           };
    
    __weak typeof(self)weakSelf=self;
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    [ZYWHttpEngine AllPostURL:urlStr params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            self.recommandArray=[NewHouseModel mj_objectArrayWithKeyValuesArray:responseObj];
            
            if (weakSelf.data!=NULL || weakSelf.data!=nil) {
                NSIndexSet * indexSet=[NSIndexSet indexSetWithIndex:5];
                [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }
          
        }
    } failure:^(NSError *error) {
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
        
    }];

}

- (void)isYuyue{//是否预约
    if (NSUSER_DEF(USERINFO) !=NULL ) {
        
    __weak typeof(self)weakSelf=self;
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=house&a=yuyue_add",URLSTR] params:[self.orderModel mj_keyValues] success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            
            ReturnInfoModel * infomodel=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
            if ([weakSelf.orderModel.t isEqualToString:@"1"]) {
                [YJProgressHUD showMessage:infomodel.info inView:weakSelf.view];
            }
          
        if ([infomodel.success isEqual:@179]) {
               [weakSelf.orderBtn setTitle:@"预约看房" forState:UIControlStateNormal];
                hasYuyue=NO;
            return ;
            }
        else if ([infomodel.success isEqual:@95])//95已预约 96预约成功
            [weakSelf.orderBtn setTitle:@"已预约" forState:UIControlStateNormal];
            hasYuyue=YES;
            return;
        } else{
            [weakSelf.orderBtn setTitle:@"预约看房" forState:UIControlStateNormal];
            hasYuyue=NO;
            return;
        }
        
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
    }];

    }
}

- (void)isCare{//是否关注
    
    if (NSUSER_DEF(USERINFO) !=NULL) {

        __weak typeof(self)weakSelf=self;
        NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=house&a=guanzhu_add",URLSTR];
        NSDictionary * param=[self.careModel mj_keyValues];
        
        [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
        
        [ZYWHttpEngine AllPostURL:urlStr params:param success:^(id responseObj) {
        [YJProgressHUD hide];
            if (responseObj) {
                ReturnInfoModel * infomodel=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                
                if ([weakSelf.careModel.t isEqualToString:@"1"]) {
                    [YJProgressHUD showMessage:infomodel.info inView:weakSelf.view];
                }
                
            if ([infomodel.success isEqual:@178]) {
                    [weakSelf.careBtn setImage:[UIImage imageNamed:@"nocare"] forState:UIControlStateNormal];
                    [weakSelf.careBtn setTitle:@"关注" forState:UIControlStateNormal];
                }
              if ([infomodel.success isEqual:@89]) {//已经关注
                  
                [weakSelf.careBtn setImage:[UIImage imageNamed:@"care"] forState:UIControlStateNormal];
                [weakSelf.careBtn setTitle:@"已关注" forState:UIControlStateNormal];
                    
                }
               else if ([infomodel.success isEqual:@90]) {//关注成功
                [weakSelf.careBtn setImage:[UIImage imageNamed:@"care"] forState:UIControlStateNormal];
                [weakSelf.careBtn setTitle:@"已关注" forState:UIControlStateNormal];
               }
            }
            
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
        }];
    }
    
}

- (void)careClick:(UIButton *)btn{//点击关注
    
    if ([_data.userid isEqualToString:NSUSER_DEF(USERINFO)[@"userid"]]) {
        [YJProgressHUD showMessage:@"亲，不能关注自己发布的房源" inView:self.view];
        return;
    }
    
    if (NSUSER_DEF(USERINFO) !=NULL) {
        self.careModel.fromid=_model.ID;
        self.careModel.fromtable=@"ershou";
        self.careModel.userid=NSUSER_DEF(USERINFO)[@"userid"];
        self.careModel.username=NSUSER_DEF(USERINFO)[@"username"];
        self.careModel.type=@"二手房";
        self.careModel.t=@"1";
        [self isCare];
    } else{
        
        LoginViewController * vc=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    

}
//预约看房
- (void)yuyueAction:(UIButton *)btn{
    
    
    if ([_data.userid isEqualToString:NSUSER_DEF(USERINFO)[@"userid"]]) {
        [YJProgressHUD showMessage:@"亲，不能预约自己发布的房源" inView:self.view];
        return;
    }
    if (hasYuyue==YES) {
        [YJProgressHUD showMessage:@"该房源已经预约" inView:self.view];
        return;
    }
    
    if (NSUSER_DEF(USERINFO)==nil){
        LoginViewController * vc=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    __weak typeof(self)weakSelf=self;
   [KSAlertView showWithTitle:@"预约看房" message1:@"预约时间" cancelButton:@"取消"customButton:@"确定" commitAction:^(UIButton *button) {
      
           OrderVC * vc=[[OrderVC alloc]init];
           vc.model=weakSelf.data;
           [weakSelf.navigationController pushViewController:vc animated:YES];

   }];
    
}
- (void)loadData{
    
    if ([_model.ID isEqual:@-1] || [_model.catid isEqual:@-1 ]) {
        return;
    }
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    NSString * url=[NSString stringWithFormat:@"%@g=api&m=house&a=api_shows",URLSTR];
    NSDictionary * params=@{
                            @"catid":_model.catid,
                            @"id":_model.ID
                            };
    
    __weak typeof(self)weakSelf=self;
    
    [ZYWHttpEngine AllPostURL:url params:params success:^(id responseObj) {
      [YJProgressHUD hide];
        if (responseObj) {
           HouseModel * data=[HouseModel mj_objectWithKeyValues:responseObj];
            _data=data;
            _daikanArray=data.daikan;
            _successRecordArray=data.tongqu;
            
            if ([_data.zaishou isEqualToString:@"0"]) {
                self.imgView.hidden=NO;
              
            } else{
                self.imgView.hidden=YES;
            }
            
            
            weakSelf.navigationItem.title=data.title;
            
            [weakSelf.tableView reloadData];
            
            [weakSelf displayImgs];
        }
        
    } failure:^(NSError *error) {
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
    }];
}

- (void)displayImgs{
    
    if (self.imageArray.count!=0) {
        [self.imageArray removeAllObjects];
    }
    
    _picArray= _data.pics;
    
    for (NSInteger i=0; i<_picArray.count; i++) {
        TSFPicsModel * picModel=_picArray[i];
        [self.imageArray addObject:[NSString stringWithFormat:@"%@%@",ImageURL,picModel.url]];
    }
    _scrollView.imageURLStringsGroup=self.imageArray;
    
    if (self.imageArray.count==0) {
        self.numlabel.text=@"0/0";
    } else{
        self.numlabel.text=[NSString stringWithFormat:@"1/%lu",(unsigned long)self.imageArray.count];
    }
}

//图片浏览器显示
-(void)networkImageShow:(NSUInteger)index{
    __weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeZoom index:index photoModelBlock:^NSArray *{
        
        
        NSArray *networkImages=_picArray;
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (NSUInteger i = 0; i< networkImages.count; i++) {
            TSFPicsModel * model=networkImages[i];
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = model.alt;
            pbModel.image_HD_U = [NSString stringWithFormat:@"%@%@",ImageURL,model.url];
            
            //源frame
            UIImageView *imageV =(UIImageView *) weakSelf.scrollView.subviews[i%2];
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    if (section>0) {
        MainSectionView * header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADER];
        header.delegate=self;
        header.leftLabel.text=self.leftTitleArray[section-1];
        header.contentView.layer.borderColor=SeparationLineColor.CGColor;
        header.contentView.layer.borderWidth=0.8;
        header.section=section;
        return header;
 
    } else{
        return nil;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==4 || section==5) {
        return 0;
    } else{
        return 80;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section==4) {
        return nil;
    } else if (section==3){//成交记录
        if (self.successRecordArray.count==0) {
            TSFNodataView * footer=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"nodata4"];
            if (!footer) {
                footer=[[TSFNodataView alloc]initWithReuseIdentifier:@"nodata4"];
            }
            
            footer.label.text=@"暂无数据";
            return footer;
        } else{
            TSFDetailFooterView * footer=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer4"];
            if (!footer) {
                footer=[[TSFDetailFooterView alloc]initWithReuseIdentifier:@"footer4" ];
            }
            footer.section=section;
            footer.BGView.backgroundColor=[UIColor whiteColor];
            [footer.moreBtn setTitle:@"查看更多成交记录" forState:UIControlStateNormal];
            [footer.moreBtn setTitleColor:RGB(112, 134, 157, 1.0) forState:UIControlStateNormal];
            footer.delegate=self;
            return footer;
        }
       
    } else if (section==5){//好房推荐
        if (self.recommandArray.count==0) {
            TSFNodataView * footer=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"nodata6"];
            if (!footer) {
                footer=[[TSFNodataView alloc]initWithReuseIdentifier:@"nodata6"];
            }
            footer.label.text=@"暂无数据";
            return footer;
        } else{
            return nil;
        }

    }
    
    else{
    
    TSFDetailFooterView * footer=[tableView dequeueReusableHeaderFooterViewWithIdentifier:FOOTER];
    if (!footer) {
        footer=[[TSFDetailFooterView alloc]initWithReuseIdentifier:FOOTER ];
    }
        footer.section=section;
        footer.BGView.backgroundColor=[UIColor whiteColor];
        [footer.moreBtn setTitleColor:RGB(112, 134, 157, 1.0) forState:UIControlStateNormal];
        footer.delegate=self;
        if (section==0) {
            [footer.moreBtn setTitle:@"查看更多属性" forState:UIControlStateNormal];
        } else if (section==1){
            [footer.moreBtn setTitle:@"查看更多特色" forState:UIControlStateNormal];
        } else if (section==2){
            [footer.moreBtn setTitle:@"查看更多带看记录" forState:UIControlStateNormal];
        }
        return footer;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0 ? 0.0001:50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_data==nil) {
        return 0;
    } else{
    return self.leftTitleArray.count+1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 3;//0
            break;
        case 1:
            return 2;//房源特色
            break;
           
        case 2:
            return 1;//看房记录
            break;
        case 3:
            if (self.successRecordArray.count==0) {
                return 0;
            } else{
                return 1;//成交记录
            }
            break;
        case 4:
            return 1;//周边配套
            break;
            
        default://好房推荐
            return self.recommandArray.count;
            break;
    }
   

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:{
                    return [TSFHandDetailTitleCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                        TSFHandDetailTitleCell * cell=(TSFHandDetailTitleCell *)sourceCell;
                            [cell configCellWithString:_data.title];
                        }];

                }
                    
                    break;
                case 1:
                    return 100;
                    break;
                case 2:
                    return 300;
                    break;
                    
                default:
                    return 0;
                    break;
            }
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:{//小区介绍
                    return [HandFeatureCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                                        HandFeatureCell * cell=(HandFeatureCell *)sourceCell;
                                        [cell configCellWithString:_data.xiaoquintro];
                                        }];
 
                }
                    
                    break;
                    
                default:{//户型介绍
                    return [HandFeatureCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                                            HandFeatureCell * cell=(HandFeatureCell *)sourceCell;
                                            [cell configCellWithString:_data.huxingintro];
                                        }];
                }
                    break;
            }
        }
            
            break;
       
        case 2:
            return 90;
            break;
        case 3:
            return 120;
            break;
        case 4:
            return 200;
            break;
        
        default:
            return 120;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    TSFHandDetailTitleCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL0 forIndexPath:indexPath];
                    [cell configCellWithString:_data.title];
                    cell.hidenLine=NO;
                    
                    return cell;
                }
                    
                    break;
                case 1:{
                    TSFHouseTypeCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL1 forIndexPath:indexPath];
                    [cell configCellWithPrice:_data.zongjia shi:_data.shi ting:_data.ting mianji:_data.jianzhumianji];
                    cell.hidenLine=NO;
                    return cell;
                }
                    
                    break;

                case 2:{
                    HandDetailBasicCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL2 forIndexPath:indexPath];
                    [cell configCellWithModel:_data];
                    [cell.btn addTarget:self action:@selector(jisuanjiAction:) forControlEvents:UIControlEventTouchUpInside];
                    cell.hidenLine=YES;
                    return cell;
                }
                    
                    break;

                    
                default:
                    return nil;
                    break;
            }
        }
            
            break;
        case 1:{
            HandFeatureCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL3 forIndexPath:indexPath];
            switch (indexPath.row) {
                case 0:
                    cell.title.text=@"小区介绍";
                    [cell configCellWithString:_data.xiaoquintro == nil ? @"" : _data.xiaoquintro];
                    cell.hidenLine=NO;
                    break;
                    
                default:
                    cell.title.text=@"户型介绍";
                    [cell configCellWithString:_data.huxingintro == nil ? @"" : _data.huxingintro];
                    cell.hidenLine=YES;
                    break;
            }
            return cell;
        }
            
            break;
       
        case 2:{
            LookRecordCell  * cell=[tableView dequeueReusableCellWithIdentifier:CELL5 forIndexPath:indexPath];
            
            NSMutableArray * jinqidaikan=[NSMutableArray array];
            for (int i=0; i<self.daikanArray.count;i++) {
                NSDateFormatter *format=[[NSDateFormatter alloc] init];
                [format setDateFormat:@"yyyy-MM-dd"];
                TSFSeeHouseModel * daikanM=self.daikanArray[i];
                NSDate *fromdate=[format dateFromString:daikanM.yuyuedate];
                if (fabs([fromdate timeIntervalSinceNow])<=60*60*24*7) {//时间大于七天前的时间
                    [jinqidaikan addObject:daikanM];
                }
            }
            
            cell.label1.text=[NSString stringWithFormat:@"%ld",jinqidaikan.count];
            cell.label2.text=[NSString stringWithFormat:@"%ld",self.daikanArray.count];
            cell.hidenLine=YES;
            return cell;
        }
            
            break;
        case 3:{
            TSFHandSuccessCell  * cell=[tableView dequeueReusableCellWithIdentifier:CELL6 forIndexPath:indexPath];
            
            if (self.successRecordArray!=nil) {
              HouseModel * model=self.successRecordArray[0];
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
                cell.label1.text=model.title;
                
                cell.label2.text=[NSString stringWithFormat:@"%@(第%@层)%@",model.ceng,model.curceng,model.chaoxiang];
                
                cell.label2.textColor=DESCCOL;
                cell.label3.text=_data.xiaoquname;
                cell.label3.textColor=DESCCOL;
                
                if (model.zongjia.length==0 ) {
                    cell.label4.text=@"价格待定";
                    cell.label4.textColor=ORGCOL;
                    cell.label4.font=[UIFont boldSystemFontOfSize:16];
                }  else{
                    if (model.jianzhumianji.length==0 || [model.jianzhumianji isEqualToString:@"0"]) {
                      cell.label4.text=[NSString stringWithFormat:@"%@万",model.zongjia];
                      cell.label4.textColor=ORGCOL;
                      cell.label4.font=[UIFont boldSystemFontOfSize:16];
                        
                    } else{
                        NSString * price=[NSString stringWithFormat:@"%.f元/平米",10000*[model.zongjia floatValue]/[model.jianzhumianji floatValue]];
                        NSString * zongjia=[NSString stringWithFormat:@"%@万",model.zongjia];
                        NSString * string=[NSString stringWithFormat:@"%@ %@",zongjia,price];
                        
                        NSRange range1=[string rangeOfString:price];
                        NSRange range2=[string rangeOfString:zongjia];
                        
                        NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:string];
                        [attrStr addAttribute:NSForegroundColorAttributeName value:TITLECOL range:range1];
                        [attrStr addAttribute:NSForegroundColorAttributeName value:ORGCOL range:range2];
                        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range1];
                        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:range2];
                        
                        [cell.label4 setAttributedText:attrStr];
                    }
                }
                
                cell.hidenLine=YES;
            }
            
           
            return cell;
        }
            
            break;
        case 4:{
            XMYMapViewCell  * cell=[tableView dequeueReusableCellWithIdentifier:CELL7 forIndexPath:indexPath];
            cell.coordinateStr=_data.jingweidu;
            cell.hidenLine=YES;
            return cell;
        }
            
            break;
            
        default:{
            BaseRoomCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL8 forIndexPath:indexPath];
            NewHouseModel * model=self.recommandArray[indexPath.row];
            
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.data.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
            cell.label1.text=model.data.title;
            cell.label1.font=[UIFont systemFontOfSize:16];
            cell.label1.textColor=TITLECOL;
            
            cell.label2.text=[NSString stringWithFormat:@"%@室%@厅 %@㎡ %@",model.data.shi,model.data.ting,model.data.jianzhumianji,model.data.chaoxiang.length==0 ? @"":model.data.chaoxiang];
            cell.label2.textColor=DESCCOL;
            cell.label3.textColor=ORGCOL;
            NSString * zongjia=[NSString stringWithFormat:@"%@万",model.data.zongjia];
            NSRange range1=[zongjia rangeOfString:model.data.zongjia];
            NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:zongjia];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:range1];
            [cell.label3 setAttributedText:attrStr];
            
            cell.label4.text=[NSString stringWithFormat:@"%@ %@",model.data.city_name,model.data.area_name];
            cell.label4.textColor=DESCCOL;
            
            NSString * biaoqian=model.data.biaoqian;
            cell.biaoqian=biaoqian;
            
            if (indexPath.row==self.recommandArray.count-1) {
                cell.hidenLine=YES;
            } else{
                cell.hidenLine=NO;
            }
            
            return cell;
        }
            break;
    }
}

- (void)jisuanjiAction:(UIButton *)btn{
    TSFCalculatorVC * VC=[[TSFCalculatorVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (NSMutableAttributedString *)longString:(NSString *)lonString string:(NSString *)string{
    
    NSRange range=[lonString rangeOfString:string];
    NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:lonString];
    [attrStr addAttribute:NSForegroundColorAttributeName value:DESCCOL range:range];
   
    return attrStr;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==5) {//好房推荐
        
        tableView.contentOffset=CGPointMake(0, 0);
        NewHouseModel * model=self.recommandArray[indexPath.row];
        _model.catid=model.catid;
        _model.ID=model.ID;
        
          [self loadData];//点击推荐房源 重新加载详情
        
        if (NSUSER_DEF(USERINFO)!=NULL) {
          
            NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
            NSString * username=NSUSER_DEF(USERINFO)[@"username"];
            
            self.orderModel.fromid=model.ID;
            self.orderModel.fromtable=@"ershou";
            self.orderModel.username=username;//判断书否预约
            self.orderModel.t=@"";
            
            self.careModel.userid=[NSNumber numberWithInteger:[userid integerValue]];
            self.careModel.fromid=model.ID;
            self.careModel.fromtable=@"ershou";
            self.careModel.username=username;//判断手否关注
            self.careModel.t=@"";
            
            [self isYuyue];
            [self isCare];
        }
        
    } else if (indexPath.section==3){//成交房源
        
        tableView.contentOffset=CGPointMake(0, 0);
        
        self.bottomView.hidden=NO;//成交 隐藏底部框 不用判断是否关注 是否预约
        
        if (self.successRecordArray!=NULL) {
           HouseModel * model=self.successRecordArray[0];
            _model = model;
           //_model.catid=model.catid;
           //_model.ID=model.ID;
           [self loadData];
        }
    } else if (indexPath.section==4){//地图
        
        MapPositionController * VC=[[MapPositionController alloc]init];
        VC.coorstr=_data.jingweidu;
        [self.navigationController pushViewController:VC animated:YES];
    }
}



#pragma mark------MainSectionViewDelegate------选中区头的方法
- (void)tableView:(UITableView *)tableView sectionDidSelected:(NSInteger)section {
   
    if (section==4) {
        MapPositionController * vc=[[MapPositionController alloc]init];
        vc.coorstr=_data.jingweidu;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

#pragma mark--------------SDCycleScrollViewDelegate-------------
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [self networkImageShow:index];
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.numlabel.text=[NSString stringWithFormat:@"%ld/%ld",index+1,self.imageArray.count];
}


#pragma mark-----TSFDetailFooterViewDelegate---
- (void)tableView:(UITableView *)tableView selectFooter:(NSInteger)section{
    if (section==0) {
        TSFMoreHandInfoVC * VC=[[TSFMoreHandInfoVC alloc]init];
        VC.model=_data;
        [self presentViewController:VC animated:YES completion:nil];
    } else if (section==1){
        TSFMoreFeatureVC * VC=[[TSFMoreFeatureVC alloc]init];
        VC.model=_data;
        [self presentViewController:VC animated:YES completion:nil];
    }  else if (section==2){//带看记录
        TSFSeeRecordVC * VC=[[TSFSeeRecordVC alloc]init];
        VC.daikanArray=self.daikanArray;
        [self.navigationController pushViewController:VC animated:YES];
    }
    else if (section==3){//成交记录
        TSFSuccessRecordVC * VC=[[TSFSuccessRecordVC alloc]init];
        VC.successArray=self.successRecordArray;
        [self.navigationController pushViewController:VC animated:YES];
        
    } 
}




//咨询经纪人==========****确认没问题****====
- (void)referAction:(UIButton *)referBtn{//咨询
    
    __weak typeof(self)weakSelf=self;
  //已经登录
        //1、普通用户发布房源
        if (_data.jjr_id==nil) {
            
            //手机号隐藏  直接调分机号
                [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
                NSDictionary * param=@{
                                       @"userid":_data.userid
                                       };
                [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=Member&m=Public&a=api_getuserinfo",URLSTR] params:param success:^(id responseObj) {
                    [YJProgressHUD hide];
                    if (responseObj) {
                        UserModel * model=[UserModel mj_objectWithKeyValues:responseObj];
                        
                        TSFReferView * referView=[[TSFReferView alloc]initWithFrame:weakSelf.view.frame];
                        [referView showView];
                        [referView.headImg sd_setImageWithURL:[NSURL URLWithString:model.userpic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"card_default"]];
                        referView.nameLab.text=model.info.realname;
                        referView.commentLab.text=@"用户直售";
                        
                         if ([_data.hidetel  isEqualToString:@"公开"]) {
                             referView.numLab.text=model.username;
                         } else{
                             referView.numLab.text=model.vtel;
                         }
                        
                        
                        referView.headBlock=^{
                            [YJProgressHUD showMessage:@"用户直售，请直接联系用户" inView:weakSelf.view];
                        };
                        referView.messageBlock=^{
                           
                            if (NSUSER_DEF(USERINFO)==nil) {
                                LoginViewController * vc=[[LoginViewController alloc]init];
                                UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:vc];
                                [self presentViewController:nav animated:YES completion:nil];
                                return ;
                            }
                            
                            if ([_data.userid isEqualToString:NSUSER_DEF(USERINFO)[@"userid"] ]) {
                                [YJProgressHUD showMessage:@"亲，是您自己发布的房源" inView:weakSelf.view];
                                return ;
                            }

                            TSFMessageDetailVC * VC=[[TSFMessageDetailVC alloc]init];
                            VC.towho=weakSelf.data.userid;
                            [weakSelf.navigationController pushViewController:VC animated:YES];
                            
                        };
                        
                        
                        referView.phoneBlock=^{
                            
                            if ([_data.hidetel  isEqualToString:@"公开"]) {
                                NSMutableString * str=[[NSMutableString alloc]initWithFormat:@"tel:%@",[NSNumber numberWithInteger:[model.username integerValue]]];
                                UIWebView * callWebView=[[UIWebView alloc]init];
                                [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                                [self.view addSubview:callWebView];
                            } else{
                                NSMutableString * str=[[NSMutableString alloc]initWithFormat:@"tel:%@",model.ctel];
                                UIWebView * callWebView=[[UIWebView alloc]init];
                                [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                                [weakSelf.view addSubview:callWebView];
                            }
                            
                            
                        };
                       
                    }
                } failure:^(NSError *error) {
                    [YJProgressHUD hide];
                    [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
                }];
                
            }
            
         else{//经纪人发布房源 联系经纪人
            
            __weak typeof(self)weakSelf=self;
            NSDictionary * param=@{@"userid":_data.jjr_id};
            [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
            [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=Member&m=Public&a=api_getuserinfo",URLSTR] params:param success:^(id responseObj) {
                [YJProgressHUD hide];
                
                if (responseObj) {
                    UserModel * model=[UserModel mj_objectWithKeyValues:responseObj];
                    TSFReferView * referView=[[TSFReferView alloc]initWithFrame:weakSelf.view.frame];
                    [referView showView];
                    [referView.headImg sd_setImageWithURL:[NSURL URLWithString:model.userpic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"card_default"]];
                    referView.nameLab.text=model.info.realname;
                    referView.commentLab.text=@"评论：暂无";
                    
                    referView.numLab.text=model.vtel;
                    
                    referView.headBlock=^{
                        
                        TSFAgentVC * VC=[[TSFAgentVC alloc]init];
                        VC.userid=_data.jjr_id;
                        [weakSelf.navigationController pushViewController:VC animated:YES];
                        
                    };
                    
                    referView.messageBlock=^{
                        
                        if (NSUSER_DEF(USERINFO)==nil) {
                            LoginViewController * vc=[[LoginViewController alloc]init];
                            UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:vc];
                            [self presentViewController:nav animated:YES completion:nil];
                            return ;
                        }

                        if ([_data.userid isEqualToString:NSUSER_DEF(USERINFO)[@"userid"] ]  || [[NSString stringWithFormat:@"%@",_data.jjr_id] isEqualToString:NSUSER_DEF(USERINFO)[@"userid"] ]) {
                            [YJProgressHUD showMessage:@"亲，是您自己发布的房源" inView:weakSelf.view];
                            return ;
                        }

                        
                        TSFMessageDetailVC * VC=[[TSFMessageDetailVC alloc]init];
                        if (_data.jjr_id==nil) {//普通用户直接出售
                          VC.towho=weakSelf.data.userid;
                        } else{
                           VC.towho=[NSString stringWithFormat:@"%@",weakSelf.data.jjr_id];
                        }
                        NSLog(@"进入消息界面：%@",weakSelf.data.userid);
                        [weakSelf.navigationController pushViewController:VC animated:YES];
                        
                    };

                    referView.phoneBlock=^{
                        
                            NSMutableString * str=[[NSMutableString alloc]initWithFormat:@"tel:%@",model.ctel];
                            UIWebView * callWebView=[[UIWebView alloc]init];
                            [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                            [weakSelf.view addSubview:callWebView];

                    };
                    
                    
                }
                
            } failure:^(NSError *error) {
                [YJProgressHUD hide];
                [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
            }];
         
        }
        
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
