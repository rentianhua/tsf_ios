//
//  RentRoomDetailVC.m
//  TaoShenFang
//
//  Created by YXM on 16/9/11.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "RentRoomDetailVC.h"
#import "PhotoBroswerVC.h"//图片浏览器
#import "LoginViewController.h"
#import "MapPositionController.h"
#import "TSFRentFeatureVC.h"
#import "TSFSeeRecordVC.h"
#import "TSFAgentVC.h"
#import "TSFMessageDetailVC.h"
#import "TSFSuccessRecordVC.h"
#import <UITableViewCell+HYBMasonryAutoCellHeight.h>

#import "RentDetailBasicCell.h"//cell2
#import "HandFeatureCell.h"//cell3
#import "RentLookCell.h"//cell4
#import "RecommendCell.h"//cell5  成交记录
#import "XMYMapViewCell.h"//cell6
#import "TSFHandDetailTitleCell.h"//cell0
#import "TSFHouseTypeCell.h"//cell1
#import "TSFHandSuccessCell.h"

#import "TSFDetailFooterView.h"
#import "TSFNodataView.h"
#import "TSFReferView.h"
#import "XMYHouseTypeView.h"
#import "MainSectionView.h"

#import <SDCycleScrollView.h>
#import <Masonry.h>
#import "IDModel.h"
#import "YJProgressHUD.h"
#import "ZYWHttpEngine.h"
#import "OtherHeader.h"
#import <MJExtension.h>

#import "HouseModel.h"
#import "TSFPicsModel.h"
#import "TSFMapButton.h"
#import "UserModel.h"
#import "NewHouseModel.h"
#import "TSFCareModel.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#define IMGWIDTH kMainScreenWidth
#define IMGHEIGHT IMGWIDTH*0.6
#define NAVBTNW 20
#define CELL0 @"cell0"
#define CELL1 @"cell1"
#define CELL2 @"cell2"
#define CELL3 @"cell3"
#define CELL4 @"cell4"
#define CELL5 @"cell5"
#define CELL6 @"cell6"
#define CELL7 @"cell7"
#define CELL8 @"cell8"

@interface RentRoomDetailVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,MainSectionViewDelegate,TSFDetailFooterViewDelegate>

@property (nonatomic,strong)SDCycleScrollView * scrollView;
@property (nonatomic,strong)UILabel * photoLabel;
@property (nonatomic,strong)UIButton * referBtn;

@property (nonatomic,strong)NSArray * sectionArray;
@property (nonatomic,strong)NSMutableArray * imageArray;
@property (nonatomic,strong)NSArray * pics;
@property (nonatomic,strong)HouseModel * data;
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * recommandArray;
@property (nonatomic,strong)NSArray * successArray;
@property (nonatomic,strong)UIButton * leftNavBtn;

@property (nonatomic,strong)UIImageView * imgView;//已售出
@end

@implementation RentRoomDetailVC

- (UIImageView *)imgView{
    if (_imgView==nil) {
        _imgView=[[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth-65, 15, 50, 50)];
        _imgView.image=[UIImage imageNamed:@"yizu_01"];
    }
    return _imgView;
}

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

- (NSArray *)sectionArray{
    if (_sectionArray==nil) {
        _sectionArray=@[@"房源特色",@"带看记录",@"成交记录",@"位置及周边",@"周边推荐"];
    }
    return _sectionArray;
}
- (NSMutableArray *)imageArray{
    if (_imageArray==nil) {
        _imageArray=[NSMutableArray array];
    }
    return _imageArray;
}
- (void)setModel:(IDModel *)model{
    _model=model;
}

- (void)loadData{
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    NSString * url=[NSString stringWithFormat:@"%@g=api&m=house&a=api_shows",URLSTR];
    NSDictionary * params=@{
                              @"catid":_model.catid,
                              @"id":_model.ID
                            };
    __weak typeof(self)weakSelf=self;
    if (self.imageArray.count!=0) {
        [self.imageArray removeAllObjects];
    }
    [ZYWHttpEngine AllPostURL:url params:params success:^(id responseObj) {
        [YJProgressHUD hide];
        weakSelf.tableView.hidden=NO;
        if (responseObj) {
        
            HouseModel * model=[HouseModel mj_objectWithKeyValues:responseObj];
            _data=model;
            
            weakSelf.title=_data.title;
            _successArray=_data.tongqu;
            
            NSArray * picArray= _data.pics;
            
            if ([_data.zaizu isEqualToString:@"0"]) {
                self.imgView.hidden=NO;
                
            } else{
                self.imgView.hidden=YES;
            }
            
           dispatch_async(dispatch_get_main_queue(), ^{
               for (NSInteger i=0; i<picArray.count; i++) {
                   TSFPicsModel * picModel=picArray[i];
                   [weakSelf.imageArray addObject:[NSString stringWithFormat:@"%@%@",ImageURL,picModel.url]];
               }
               
               weakSelf.scrollView.imageURLStringsGroup=weakSelf.imageArray;
               if (weakSelf.imageArray.count>0) {
                   _photoLabel.text=[NSString stringWithFormat:@"1/%ld",weakSelf.imageArray.count];
               } else{
                   _photoLabel.text=@"0/0";
               }
               
               [weakSelf.tableView reloadData];
           });
            
           
        }

    } failure:^(NSError *error) {
        weakSelf.tableView.hidden=YES;
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
    }];
}

- (void)loadRecommend{//获取推荐位数据
    NSString * urlStr=[NSString stringWithFormat:@"%@g=api&m=house&a=position",URLSTR];
    NSDictionary * param=@{
                           @"posid":@4
                           };
    __weak typeof(self)weakSelf=self;
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    [ZYWHttpEngine AllPostURL:urlStr params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            weakSelf.recommandArray=[NewHouseModel mj_objectArrayWithKeyValuesArray:responseObj];
            [weakSelf.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
    }];
    
}



- (void)initWithTableView{
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-40-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [_tableView registerClass:[XMYHouseTypeView class] forHeaderFooterViewReuseIdentifier:@"header0"];
    [_tableView registerClass:[MainSectionView class] forHeaderFooterViewReuseIdentifier:@"header1"];
    
    [_tableView registerClass:[TSFHandDetailTitleCell class] forCellReuseIdentifier:CELL0];
    [_tableView registerNib:[UINib nibWithNibName:@"TSFHouseTypeCell" bundle:nil] forCellReuseIdentifier:CELL1];
    [_tableView registerNib:[UINib nibWithNibName:@"RentDetailBasicCell" bundle:nil] forCellReuseIdentifier:CELL2];
    [_tableView registerClass:[HandFeatureCell class] forCellReuseIdentifier:CELL3];
    [_tableView registerNib:[UINib nibWithNibName:@"RentLookCell" bundle:nil] forCellReuseIdentifier:CELL4];
    [_tableView registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellReuseIdentifier:CELL5];
    [_tableView registerClass:[XMYMapViewCell class] forCellReuseIdentifier:CELL6];
    [_tableView registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellReuseIdentifier:CELL7];
    [_tableView registerNib:[UINib nibWithNibName:@"TSFHandSuccessCell" bundle:nil] forCellReuseIdentifier:CELL8];
    [self initWithTableViewHeader];
    
}

- (void)initWithTableViewHeader{
    SDCycleScrollView * scrollView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -IMGHEIGHT, kMainScreenWidth, IMGHEIGHT) delegate:self placeholderImage:[UIImage imageNamed:@"card_default"]];
    scrollView.autoScroll=NO;
    scrollView.showPageControl=NO;
    scrollView.delegate=self;
    [self.tableView addSubview:scrollView];
    self.scrollView=scrollView;
    scrollView.backgroundColor=[UIColor whiteColor];
    [scrollView addSubview:self.imgView];
    self.imgView.hidden=YES;
    
    
    UILabel * label=[UILabel new];
    [scrollView addSubview:label];
    label.backgroundColor=[UIColor blackColor];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(21);
    }];
    if (self.imageArray.count==0) {
        label.text=@"0/0";
    } else{
        label.text=[NSString stringWithFormat:@"1/%lu",(unsigned long)self.imageArray.count];
    }
    self.photoLabel=label;
    _tableView.tableHeaderView=scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self loadRecommend];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    
    [self initWithTableView];
    [self initWithBottomView];
    
}
- (void)initWithBottomView{
    
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-40);
    }];
    
    UIButton * zixun=[UIButton new];
    [zixun setTitle:@"立即咨询" forState:UIControlStateNormal];
    [zixun setTitleColor:NavBarColor forState:UIControlStateNormal];
    [zixun setBackgroundColor:[UIColor whiteColor]];
    [zixun.titleLabel setFont:[UIFont systemFontOfSize:14]];
    zixun.layer.borderWidth=1;
    zixun.layer.borderColor=SeparationLineColor.CGColor;
    [self.view addSubview:zixun];
    self.referBtn=zixun;
    [zixun mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [zixun addTarget:self action:@selector(zixunAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)zixunAction:(UIButton *)zixunBtn{
        if (_data.jjr_id!=nil) {//经纪人发布的
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
                    referView.numLab.text=model.vtel;
                    referView.commentLab.text=[NSString stringWithFormat:@"好评率：暂无"];
                    [referView showView];
                    referView.headBlock=^{
                        TSFAgentVC * VC=[[TSFAgentVC alloc]init];
                        VC.userid=_data.jjr_id;
                        [weakSelf.navigationController pushViewController:VC animated:YES];
                    };
                    referView.messageBlock=^{
                        if (NSUSER_DEF(USERINFO)==nil) {
                            LoginViewController * VC=[[LoginViewController alloc]init];
                            UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:VC];
                            [self presentViewController:nav animated:YES completion:nil];
                            return;
                        }
                        
                        if ([_data.userid isEqualToString:NSUSER_DEF(USERINFO)[@"userid"] ]) {
                            [YJProgressHUD showMessage:@"亲，是您自己发布的房源" inView:weakSelf.view];
                            return ;
                        }
                        
                        TSFMessageDetailVC * VC=[[TSFMessageDetailVC alloc]init];
                        if (_data.jjr_id==nil) {
                            VC.towho=_data.userid;
                        } else{
                            VC.towho=[NSString stringWithFormat:@"%@",_data.jjr_id];
                        }
                       
                        [weakSelf.navigationController pushViewController:VC animated:YES];
                    };
                    referView.phoneBlock=^{
                        
                       
                                NSMutableString * str=[[NSMutableString alloc]initWithFormat:@"tel:%@", model.ctel];
                                UIWebView * callWebView=[[UIWebView alloc]init];
                                [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                                [weakSelf.view addSubview:callWebView];
                    };
                    
                }
                
            } failure:^(NSError *error) {
                [YJProgressHUD hide];
                [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
            }];
            
            
            
        } else{//普通用户发布
            __weak typeof(self)weakSelf=self;
            NSDictionary * param=@{@"userid":_data.userid};
            [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
            [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=Member&m=Public&a=api_getuserinfo",URLSTR] params:param success:^(id responseObj) {
                [YJProgressHUD hide];
                if (responseObj) {
                    UserModel * model=[UserModel mj_objectWithKeyValues:responseObj];
                    
                    TSFReferView * referView=[[TSFReferView alloc]initWithFrame:self.view.frame];
                    [referView showView];
                    [referView.headImg sd_setImageWithURL:[NSURL URLWithString:model.userpic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"card_default"]];
                    referView.nameLab.text=model.info.realname;
                    referView.commentLab.text=@"用户直租";
                    if ([weakSelf.data.hidetel isEqualToString:@"公开"]) {
                    referView.numLab.text=model.username;
                    } else{
                        if (model.ctel.length<6){
                            referView.numLab.text=model.username;
                        } else{
                            referView.numLab.text=model.vtel;
                        }
                    
                    }
                    
                    [referView showView];
                    referView.headBlock=^{
                        [YJProgressHUD showMessage:@"用户直租，请直接联系用户" inView:self.view];
                    };
                    
                    referView.messageBlock=^{
                        
                        if (NSUSER_DEF(USERINFO)==nil) {
                            LoginViewController * VC=[[LoginViewController alloc]init];
                            UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:VC];
                            [self presentViewController:nav animated:YES completion:nil];
                            return;
                        }
                        
                        if ([_data.userid isEqualToString:NSUSER_DEF(USERINFO)[@"userid"] ]) {
                            [YJProgressHUD showMessage:@"亲，是您自己发布的房源" inView:weakSelf.view];
                            return ;
                        }

                        
                        TSFMessageDetailVC * VC=[[TSFMessageDetailVC alloc]init];
                        VC.towho=_data.userid;
                        [self.navigationController pushViewController:VC animated:YES];
                    };
                    referView.phoneBlock=^{
                        
                        if ([weakSelf.data.hidetel isEqualToString:@"公开"]) {
                            NSMutableString * str=[[NSMutableString alloc]initWithFormat:@"tel:%@",model.username];
                            UIWebView * callWebView=[[UIWebView alloc]init];
                            [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                            [weakSelf.view addSubview:callWebView];
                        } else{
                             NSMutableString * str=nil;
                            if (model.ctel.length<6) {
                                str=[[NSMutableString alloc]initWithFormat:@"tel:%@",model.username];
                            } else{
                                str=[[NSMutableString alloc]initWithFormat:@"tel:%@",model.ctel];
                            }
                           
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

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if ( section==2/* ||section==3*/) {
        TSFDetailFooterView * footer=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
        if (!footer) {
            footer=[[TSFDetailFooterView alloc]initWithReuseIdentifier:@"footer" ];
        }
        footer.section=section;
        footer.BGView.backgroundColor=[UIColor whiteColor];
        [footer.moreBtn setTitleColor:RGB(112, 134, 157, 1.0) forState:UIControlStateNormal];
        footer.delegate=self;
        if (section==2){
            [footer.moreBtn setTitle:@"查看更多特色" forState:UIControlStateNormal];
        } else if (section==3){
            [footer.moreBtn setTitle:@"查看更多带看记录" forState:UIControlStateNormal];
        }
        return footer;
    } else if (section==4){
        if (self.successArray.count==0) {
            TSFNodataView * nodatafooter=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"nodata"];
            if (!nodatafooter) {
                nodatafooter=[[TSFNodataView alloc]initWithReuseIdentifier:@"nodata"];
            }
            return nodatafooter;
        } else{
            TSFDetailFooterView * footer=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
            if (!footer) {
                footer=[[TSFDetailFooterView alloc]initWithReuseIdentifier:@"footer" ];
            }
            footer.section=section;
            footer.BGView.backgroundColor=[UIColor whiteColor];
            [footer.moreBtn setTitleColor:RGB(112, 134, 157, 1.0) forState:UIControlStateNormal];
            footer.delegate=self;
            [footer.moreBtn setTitle:@"查看更多成交记录" forState:UIControlStateNormal];
            return footer;
 
        }
    }
 
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0 || section==1 || section == 3) {
        return nil;

    } else{
        MainSectionView * header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header1"];
        header.rightButton.hidden=NO;
        header.delegate=self;
        header.leftLabel.text=self.sectionArray[section-2];
        header.section=section;
        header.contentView.layer.borderColor=SeparationLineColor.CGColor;
        header.contentView.layer.borderWidth=0.8;
        return header;

    }
}
//===================MainSectionViewDelegate================
- (void)tableView:(UITableView *)tableView sectionDidSelected:(NSInteger)section{
    if (section==5) {
        MapPositionController * VC=[[MapPositionController alloc]init];
        VC.coorstr=_data.jingweidu;
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0 || section==1 || section==3) {
        return 0;
    } else{
    return 50;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ( _data==nil) {
        tableView.hidden=YES;
    } else{
        tableView.hidden=NO;
    }
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ( section==2 /*|| section==3*/ || section==4) {
        return 80;
    } else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            
            //return 1;
            return 0;
            break;
        case 4:
            if (self.successArray.count==0) {
                return 0;
            } else{
            return 1;
            }
            
            break;
        case 5:
            return 1;
            
            break;
            
        default:
            return self.recommandArray.count;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    switch (indexPath.section) {
            
        case 0:{
            
            if (indexPath.row==0) {
                return [TSFHandDetailTitleCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                    TSFHandDetailTitleCell * cell=(TSFHandDetailTitleCell *)sourceCell;
                    [cell configCellWithString:_data.title];
                      }];
            } else{
                return 100;
            }
                    
            
          
        }
            
            break;
        case 1:
            return 260;
            break;
            
        case 2:{
            if (indexPath.row==0) {
                return [HandFeatureCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                    HandFeatureCell * cell=(HandFeatureCell *)sourceCell;
                    [cell configCellWithString:_data.liangdian];
                }];
                
            } else{
                return [HandFeatureCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
                    HandFeatureCell * cell=(HandFeatureCell *)sourceCell;
                    [cell configCellWithString:_data.jiaotong];
                }];
                
            }

        }
            
            break;
        case 3:
            //return 50;
            return 0;
            break;
        case 4:
            return 120;
            break;
        case 5:
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
            
            if (indexPath.row==0) {
                TSFHandDetailTitleCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL0 forIndexPath:indexPath];
                [cell configCellWithString:_data.title];
                cell.hidenLine=NO;
                
                return cell;
            } else{
                TSFHouseTypeCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL1 forIndexPath:indexPath];
                cell.label11.text=@"租金";
                cell.label1.text=[NSString stringWithFormat:@"%@元/月",_data.zujin];
                cell.label2.text=[NSString stringWithFormat:@"%@室%@厅",_data.shi,_data.ting];
                cell.label3.text=[NSString stringWithFormat:@"%@平米",_data.mianji];
                cell.hidenLine=NO;
                return cell;
            }
          
        }
            
            break;
        case 1:{
            RentDetailBasicCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL2 forIndexPath:indexPath];
            [cell configCellWithModel:_data];
            return cell;
        }

        case 2:{
            HandFeatureCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL3 forIndexPath:indexPath];
            if (indexPath.row==0) {
                cell.title.text=@"房源亮点";
                [cell configCellWithString:_data.liangdian];
                cell.hidenLine=NO;
            } else{
                cell.title.text=@"交通出行";
                [cell configCellWithString:_data.jiaotong];
                cell.hidenLine=YES;
            }
            return cell;
        }
            
            break;
        case 3:{
            RentLookCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL4 forIndexPath:indexPath];
            cell.label.text=@"近一月新增看房记录3位";
            return cell;
        }
            
            break;
        case 4:{
//            RecommendCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL5 forIndexPath:indexPath];
//            return cell;
            
            TSFHandSuccessCell  * cell=[tableView dequeueReusableCellWithIdentifier:CELL8 forIndexPath:indexPath];
            
            if (self.successArray!=nil && self.successArray.count>0) {
                HouseModel * model=self.successArray[0];
                [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
                cell.label1.text=model.title;
                
                cell.label2.text=[NSString stringWithFormat:@"%@(第%@层)%@",model.ceng,model.zongceng,model.chaoxiang];
                
                cell.label2.textColor=DESCCOL;
                cell.label3.text=_data.xiaoquname;
                cell.label3.textColor=DESCCOL;
                
                if (model.zujin.length==0 ) {
                    cell.label4.text=@"价格待定";
                    cell.label4.textColor=ORGCOL;
                    cell.label4.font=[UIFont boldSystemFontOfSize:16];
                }  else{
                    if (model.mianji.length==0 || [model.mianji isEqualToString:@"0"]) {
                        cell.label4.text=[NSString stringWithFormat:@"%@元",model.zujin];
                        cell.label4.textColor=ORGCOL;
                        cell.label4.font=[UIFont boldSystemFontOfSize:16];
                        
                    } else{
                        NSString * price=[NSString stringWithFormat:@"%.f平米",[model.mianji floatValue]];
                        NSString * zongjia=[NSString stringWithFormat:@"%@元/月",model.zujin];
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
        case 5:{
            XMYMapViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL6 forIndexPath:indexPath];
            cell.coordinateStr=_data.jingweidu;
            return cell;
        }
            
            break;
            
        default:{
            RecommendCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL7 forIndexPath:indexPath];
            NewHouseModel * model=self.recommandArray[indexPath.row];
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.data.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
            cell.label1.text=model.data.title;
            cell.label2.text=[NSString stringWithFormat:@"%@ %@ %@",model.data.province_name,model.data.city_name,model.data.area_name];
            cell.label4.text=[NSString stringWithFormat:@"%@元/月",model.data.zujin];
            
            return cell;
        }
            break;
    }
}

//图片浏览器显示
-(void)networkImageShow:(NSUInteger)index{
    __weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeZoom index:index photoModelBlock:^NSArray *{
        
        
        NSArray *networkImages=_data.pics;
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (NSUInteger i = 0; i< networkImages.count; i++) {
            TSFPicsModel * model=_data.pics[i];
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = model.alt;
            pbModel.desc = @"";
            pbModel.image_HD_U = [NSString stringWithFormat:@"%@%@",ImageURL,model.url];
            
            //源frame
            UIImageView *imageV =(UIImageView *) weakSelf.scrollView.subviews[i%2];
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==6) {
        
        tableView.contentOffset=CGPointMake(0, 0);
        NewHouseModel * model=self.recommandArray[indexPath.row];
        IDModel * idmodel=[[IDModel alloc]init];
        idmodel.ID=model.ID;
        idmodel.catid=model.catid;
        
        _model=idmodel;
        [self loadData];
    } else if (indexPath.section==5){
        MapPositionController * VC=[[MapPositionController alloc]init];
        VC.coorstr=_data.jingweidu;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.section==4){//成交房源
        
        tableView.contentOffset=CGPointMake(0, 0);
        
//        self.bottomView.hidden=NO;//成交 隐藏底部框 不用判断是否关注 是否预约
        
        if (self.successArray!=NULL && self.successArray.count>0) {
            HouseModel * model=self.successArray[0];
            
            IDModel * idmodel=[[IDModel alloc]init];
            idmodel.ID=model.ID;
            idmodel.catid=model.catid;
            _model=idmodel;
            
            //_model.catid=model.catid;
            //_model.ID=model.ID;
            
            [self loadData];
        }
    }
}
#pragma mark-----TSFDetailFooterViewDelegate---
- (void)tableView:(UITableView *)tableView selectFooter:(NSInteger)section{
    if (section==2) {
        TSFRentFeatureVC * VC=[[TSFRentFeatureVC alloc]init];
        VC.model=_data;
        [self presentViewController:VC animated:YES completion:nil];
    } else if (section==3){
        TSFSeeRecordVC * VC=[[TSFSeeRecordVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    else if (section==4){//成交记录
        TSFSuccessRecordVC * VC=[[TSFSuccessRecordVC alloc]init];
        VC.successArray=self.successArray;
        VC.isRentHouse = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
    }
}


#pragma mark--------------SDCycleScrollViewDelegate-------------
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [self networkImageShow:index];
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    _photoLabel.text=[NSString stringWithFormat:@"%ld/%ld",index+1,self.imageArray.count];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
