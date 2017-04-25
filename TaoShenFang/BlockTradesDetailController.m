//
//  BlockTradesDetailController.m
//  TaoShenFangTest
//
//  Created by YXM on 16/8/15.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "BlockTradesDetailController.h"
#import "OtherHeader.h"
//=====================
#import "Order.h"
#import "GRpay.h"
//==========================
#import "PhotoBroswerVC.h"//图片浏览器
#import "YJProgressHUD.h"
#import "ZYWHttpEngine.h"
#import <MJExtension.h>

#import "MapForRoomViewController.h"
#import "MessageViewController.h"
#import "MapPositionController.h"
#import "LoginViewController.h"

#import "HouseModel.h"
#import "TSFTradesModel.h"
#import "TSFPayModel.h"
#import "AreaModel.h"
#import "IDModel.h"
#import "ReturnInfoModel.h"

#import "MainSectionView.h"
#import "SDCycleScrollView.h"
#import "TSFContractView.h"

#import "XMYMapViewCell.h"// 地图
#import "TSFBlockTitleCell.h"
#import "TSFTradeDetailCell.h"

#import "TFHpple.h"
#import <UIImageView+WebCache.h>

#define CELL0 @"cell0"
#define CELL1 @"cell1"
#define CELL2 @"cell2"
#define CELL3 @"cell3"
#define CELL4 @"cell4"

#define IMGWIDTH kMainScreenWidth
#define IMGHEIGHT IMGWIDTH*0.6
#define NAVBTNW 20
#define HTMLIMGH kMainScreenWidth*0.6
@interface BlockTradesDetailController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,MainSectionViewDelegate>{
    BOOL _isOffline;
    BOOL _hasPay;
}

@property (nonatomic,strong)UIView * navView;
@property (nonatomic,copy)NSString * province_name;
@property (nonatomic,copy)NSString * city_name;
@property (nonatomic,copy)NSString * area_name;

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)SDCycleScrollView * scrollView;
/**图片数组*/
@property (nonatomic,strong)NSMutableArray * imgArr;
/**滑动视图右下角标签*/
@property (nonatomic,strong)UILabel * label;
@property (nonatomic,strong)NSArray * secTitleArr;
@property (nonatomic,strong)HouseModel * detailmodel;

//导航条上的按钮
@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)UIButton * rightNavBtn;
@property (nonatomic,strong)UIImageView * barImgView;

@property (nonatomic,strong)TSFContractView * contractView;


@property (nonatomic,strong)UIButton * confirmBrn;

@property (nonatomic,assign)float height1;
@property (nonatomic,assign)float height2;
@property (nonatomic,assign)float height3;

@property (nonatomic,strong)NSArray * htmlStrArray;
@property (nonatomic,strong)NSArray * htmlimgArray;

@end

@implementation BlockTradesDetailController

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
        [_rightNavBtn setImage:[UIImage imageNamed:@"ic_map_newtitlebar_new"] forState:UIControlStateNormal];
        [_rightNavBtn addTarget:self action:@selector(toMapVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNavBtn;
}


- (NSMutableArray *)imgArr{
    if (_imgArr==nil) {
        _imgArr=[NSMutableArray array];
    }
    return _imgArr;
}
/*滑动视图右下角标签*/
- (UILabel *)label
{
    if (_label==nil) {
        _label=[[UILabel alloc]init];
        _label.backgroundColor=[UIColor blackColor];
        _label.textAlignment=NSTextAlignmentCenter;
        _label.textColor=[UIColor whiteColor];
    }
    
    return _label;
}

- (void)setIDmodel:(IDModel *)IDmodel{
    _IDmodel=IDmodel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn];
   
    [self loadData];
    self.title=@"大宗交易详情";
    _secTitleArr=@[@"基本信息",@"详细介绍",@"认证信息",@"位置与周边"];
    _isOffline=NO;
    
    
    [self initWithTableView];
    [self initWithScrollView];
    
    
    if (NSUSER_DEF(USERINFO)==nil) {//进入大宗交易详情  没有登录 显示勾地按钮
        
    } else{
        [self isFukuan];
    }
    _hasPay=NO;

}


- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)toMapVC{
    MapForRoomViewController * VC=[[MapForRoomViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)back:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)toMessage:(UIButton *)button{
    MessageViewController * vc=[[MessageViewController alloc]init];
    vc.navigationController.navigationBarHidden=NO;
    vc.type = MessageTypeBack;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initWithScrollView{
    //滑动视图
    SDCycleScrollView * scrollView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -IMGHEIGHT, kMainScreenWidth, IMGHEIGHT) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    scrollView.autoScroll=NO;
    scrollView.showPageControl=NO;
    //数字标签
    self.label.frame=CGRectMake(kMainScreenWidth-70, IMGHEIGHT-40, 60, 30);
    [scrollView addSubview:self.label];
    [self.tableView addSubview:scrollView];
    _scrollView=scrollView;
 
}
#pragma mark--------------SDCycleScrollViewDelegate-------------
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [self networkImageShow:index];
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.label.text=[NSString stringWithFormat:@"%ld/%ld",index+1,self.imgArr.count];
}

//图片浏览器显示
-(void)networkImageShow:(NSUInteger)index{
    __weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeZoom index:index photoModelBlock:^NSArray *{
        
        
        NSArray *networkImages=weakSelf.imgArr;
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (NSUInteger i = 0; i< networkImages.count; i++) {
            NSString * picname=networkImages[i];
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = @"";
            pbModel.image_HD_U = [NSString stringWithFormat:@"%@",picname];
            
            //源frame
            UIImageView *imageV =(UIImageView *) weakSelf.scrollView.subviews[i%2];
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
    
}


- (void)initWithTableView{
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth,kMainScreenHeight-64) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.contentInset=UIEdgeInsetsMake(IMGHEIGHT, 0, 0, 0);
    self.tableView=tableView;
    
    [tableView registerNib:[UINib nibWithNibName:@"TSFBlockTitleCell" bundle:nil] forCellReuseIdentifier:CELL0];
    [tableView registerNib:[UINib nibWithNibName:@"TSFTradeDetailCell" bundle:nil] forCellReuseIdentifier:CELL1];
    
    [tableView registerClass:[XMYMapViewCell class] forCellReuseIdentifier:CELL4];
    

}
//勾地须知
- (void)goudiAction:(UIButton *)button{
    
    
    if (NSUSER_DEF(USERINFO)==nil) {
        
        LoginViewController * loginVC=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        
    } else{
        _contractView=[[TSFContractView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];

        __weak typeof(self)weakSelf=self;
        if (_detailmodel.fubiao.xuzhi.length!=0) {
            NSString * xuzhi=[weakSelf htmlP:_detailmodel.fubiao.xuzhi];
            _contractView.contractstring=xuzhi;
        }
        
        [UIView animateWithDuration:1.0 animations:^{
            
            [weakSelf.view addSubview:weakSelf.contractView];
            
        }];
        
        //确认提交订单
        weakSelf.contractView.confirmblock=^{//提交订单
            
            NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
            TSFPayModel * model=[[TSFPayModel alloc]init];
            model.house_id=weakSelf.detailmodel.ID;
            model.userid=[NSNumber numberWithInteger:[userid integerValue]];
            model.title=weakSelf.detailmodel.title;
            model.jine=[weakSelf.detailmodel.goudijine floatValue];
            
            NSDictionary * param=[model mj_keyValues];
            
            __weak typeof(self)weakSelf=self;
            [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
            [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=house&a=goudi_add",URLSTR] params:param success:^(id responseObj) {
                [YJProgressHUD hide];
                if (responseObj) {
                    
                    [weakSelf.contractView removeFromSuperview];
                    ReturnInfoModel * model=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                    if (model.result==nil) {
                        [YJProgressHUD showMessage:model.info inView:self.view];
                        return ;
                    } else{
                        
                        Product * p=[[Product alloc]init];
                        p.subject=model.result.title;
                        p.price=model.result.jine;
                        p.orderId=model.result.order_no;
                        
                        
                        NSNotificationCenter * center=[NSNotificationCenter defaultCenter];
                        [center addObserver:self selector:@selector(payAction:) name:@"pay" object:nil];
                        
                        
                        //==================我在这里调了支付宝去支付============
                        [GRpay payWithProduct:p resultBlock:^(NSString *rsultString) {
                            
                            
                            
                            
                            
                            
                        }];
                    }
                }
            } failure:^(NSError *error) {
                [YJProgressHUD hide];
                [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
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
        
        [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
        
        __weak typeof(self)weakSelf=self;
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=Api&m=Api&a=app_return_url",URLSTR] params:param success:^(id responseObj) {
            [YJProgressHUD hide];
            
            if (responseObj) {
                ReturnInfoModel * info=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
                [YJProgressHUD showMessage:info.info inView:weakSelf.view];
                
                [weakSelf isFukuan];
                
            }
       
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
        }];
        
        
    } else if (status==8000){//订单正在处理中
        
    } else if (status==4000){//订单支付失败
        
    } else if (status==6001){//订单取消
        
    } else if (status==6002){//网络链接出错
        
    }
    
}

- (void)loadData{
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    NSString * url=[NSString stringWithFormat:@"%@g=api&m=house&a=api_shows",URLSTR];
    NSDictionary * params=@{
                            @"catid":_IDmodel.catid,
                            @"id":_IDmodel.ID
                            };
    __weak typeof(self)weakSelf=self;
    
    [ZYWHttpEngine AllPostURL:url params:params success:^(id responseObj) {
        [YJProgressHUD hide];
        weakSelf.tableView.hidden=NO;
        if (responseObj) {
            HouseModel * model=[HouseModel mj_objectWithKeyValues:responseObj];
            weakSelf.detailmodel=model;
            
            [weakSelf.imgArr addObject:[NSString stringWithFormat:@"%@%@",ImageURL,_detailmodel.thumb]];
            
            [weakSelf.tableView reloadData];
            
            weakSelf.scrollView.imageURLStringsGroup=weakSelf.imgArr;
            
             weakSelf.label.text=[NSString stringWithFormat:@"1/%lu",(unsigned long)weakSelf.imgArr.count];
            
            _htmlStrArray=[NSArray arrayWithObjects:model.fubiao.content,model.fubiao.renzheng, nil];
            
            NSString * content=nil;
            if (model.fubiao.content.length!=0) {
                  content=[weakSelf htmlP:model.fubiao.content];
            }
            NSString * renzheng=nil;
            if (model.fubiao.renzheng.length!=0) {
                renzheng=[weakSelf htmlP:model.fubiao.renzheng];
            }
           
            NSArray * contArray=[weakSelf htmlImg:model.fubiao.content];
            NSArray * renArray=[weakSelf htmlImg:model.fubiao.renzheng];
            
            _htmlStrArray=[NSArray arrayWithObjects:content,renzheng, nil];
            _htmlimgArray=[NSArray arrayWithObjects:contArray,renArray, nil];
            
            [weakSelf.tableView reloadData];
            
        }
    
        
    } failure:^(NSError *error) {
       [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
        weakSelf.tableView.hidden=YES;
    }];
  
}

- (NSString *)htmlP:(NSString * )string{
    
    //详情的解析
    NSMutableArray * arraycontent=[NSMutableArray array];
    NSData * contentData=[string dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple * hpple=[[TFHpple alloc]initWithHTMLData:contentData];
    NSArray * elements=[hpple searchWithXPathQuery:@"//p"];
    for (TFHppleElement * element in elements) {
        if ([element content]!=nil && [element content].length!=0) {
            [arraycontent addObject:[NSString stringWithFormat:@"%@\n",[element content]]];
        }
    }

   return  [arraycontent componentsJoinedByString:@""];
    
}

- (NSMutableArray *)htmlImg:(NSString *)string{
    
    NSData * contentData=[string dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple * hpple=[[TFHpple alloc]initWithHTMLData:contentData];
    
    NSArray * elementsimg=[hpple searchWithXPathQuery:@"//img"];
    
    
    NSMutableArray * imgArray=[NSMutableArray array];
    
    for (TFHppleElement * element in elementsimg) {
        
        if ([element content]!=nil) {
            
            [imgArray addObject:[element objectForKey:@"src"]];
            
        }
    }

    return imgArray;
    
    
}


- (void)isFukuan{
    
    NSDictionary * param=@{@"house_id":_IDmodel.ID,
                           @"userid":NSUSER_DEF(USERINFO)[@"userid"]};
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    __weak typeof(self)weakSelf=self;
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=house&a=has_goudi",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            ReturnInfoModel * info=[ReturnInfoModel mj_objectWithKeyValues:responseObj];
            if ([info.success isEqual:@181]) {
                _hasPay=YES;
                
                [weakSelf.tableView reloadData];
            }
        }
        
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];
    }];
    
}


- (void)reloadData:(UITapGestureRecognizer *)sender{
    [self loadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_detailmodel==nil ) {
        tableView.hidden=YES;
    } else{
        tableView.hidden=NO;
    }
    if (_hasPay==NO) {
        return 3;
    } else{
        return 5;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==0) {
        return 140;
    }  else if (indexPath.section==1){
        return 194;
    } else if (indexPath.section==2){
        if (_detailmodel.fubiao.content.length==0) {
            return 10;
        } else{
            return _height1;
        }
        
    }  else if (indexPath.section==3){
        if (_detailmodel.fubiao.renzheng.length==0) {
            return 10;
        } else{
            return _height2;
        }

    }  else{
        return 200;
    }
   
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==0 ) {
        return 0.0001;
    } else{
    return 50;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return nil;
    }  else{
    MainSectionView * secView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"sec"];
    if (!secView) {
        secView=[[MainSectionView alloc]initWithReuseIdentifier:@"sec"];
    }
    secView.delegate=self;
    secView.section=section;
    secView.leftLabel.text=_secTitleArr[section-1];
    return secView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==0) {
        
        TSFBlockTitleCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL0 forIndexPath:indexPath];
        cell.label1.text=_detailmodel.title;
        if ([_detailmodel.hasgd isEqualToString:@"1"]) {//需要勾地
            NSString * goudi=[NSString stringWithFormat:@"勾地需付款%@元",self.detailmodel.goudijine];
            NSMutableAttributedString * goudiAttr=[[NSMutableAttributedString alloc]initWithString:goudi];
            NSRange range=[goudi rangeOfString:_detailmodel.goudijine.length==0 ? @"":_detailmodel.goudijine];
            [goudiAttr setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:ORGCOL} range:range];
            
            [cell.label2 setAttributedText:goudiAttr];
            [cell.gouBtn addTarget:self action:@selector(goudiAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.gouBtn.hidden=NO;
            if (NSUSER_DEF(USERINFO)==nil ) {
                cell.gouBtn.hidden=NO;
            } else{
                if (_hasPay==YES) {
                    cell.gouBtn.hidden=YES;
                } else{
                    cell.gouBtn.hidden=NO;
                }
            }
            
            
           
        } else{//不需要勾地
            NSString * goudi=@"勾地需付款0元";
            NSMutableAttributedString * goudiAttr=[[NSMutableAttributedString alloc]initWithString:goudi];
            NSRange range=[goudi rangeOfString:@"0"];
            [goudiAttr setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:ORGCOL} range:range];
            
            [cell.label2 setAttributedText:goudiAttr];
            cell.gouBtn.hidden=YES;
        }

        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_detailmodel.updatetime integerValue]];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        cell.label3.text=[NSString stringWithFormat:@"更新时间：%@",confromTimespStr];
        cell.label4.text=[NSString stringWithFormat:@"房源编号：%@",_detailmodel.bianhao];
       
        return cell;
    } else if (indexPath.section==1){
        TSFTradeDetailCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL1 forIndexPath:indexPath];
        NSString * string=[NSString stringWithFormat:@"所在地区：%@ %@",_detailmodel.cityname,_detailmodel.areaname];
        [cell.label1 setAttributedText:[self string:string len:5]];
        NSString * yusuan=[NSString stringWithFormat:@"预算金额：%@万",_detailmodel.zongjia];
        [cell.label3 setAttributedText:[self string:yusuan len:5]];
        
        NSString * address=[NSString stringWithFormat:@"土地属性：%@",_detailmodel.tudishuxing];
        [cell.label2 setAttributedText:[self string:address len:5]];

        NSString * hezuo=[NSString stringWithFormat:@"合作方式：%@",_detailmodel.hezuofangshi];
        [cell.label4 setAttributedText:[self string:hezuo len:5]];
        
        NSString * nianxian=nil;
        if ([_detailmodel.shiyongnianxian isEqualToString:@"999"]) {
           nianxian=[NSString stringWithFormat:@"使用年限(年)：不限"];
        } else{
           nianxian=[NSString stringWithFormat:@"使用年限(年)：%@",_detailmodel.shiyongnianxian];
        }
       
        [cell.label5 setAttributedText:[self string:nianxian len:8]];
        
        NSString * wuye=[NSString stringWithFormat:@"物业类型：%@",_detailmodel.wuyetype];
        [cell.label6 setAttributedText:[self string:wuye len:5]];
        
        NSString * mianji=[NSString stringWithFormat:@"建筑面积(㎡)：%@",_detailmodel.zhandimianji];
        [cell.label7 setAttributedText:[self string:mianji len:8]];
        
        NSString * lianxi=[NSString stringWithFormat:@"联系人：%@",_detailmodel.contactname];
        [cell.label8 setAttributedText:[self string:lianxi len:4]];
        
        address=[NSString stringWithFormat:@"位置：%@",_detailmodel.address];
        [cell.label9 setAttributedText:[self string:address len:3]];
        
        return cell;
    } else if (indexPath.section==2 ){
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL2];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL2];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            CGRect rect=CGRectMake(0, 0, 0, 0);
            if (_htmlStrArray.count>0) {//如果详细介绍有值
                NSString * str=_htmlStrArray[0];
                
                rect=[str boundingRectWithSize:CGSizeMake(kMainScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
                
                UILabel * lab=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, kMainScreenWidth-30, rect.size.height)];
                lab.tag=100;
                lab.numberOfLines=0;
                lab.font=[UIFont systemFontOfSize:14];
                lab.textColor=DESCCOL;
                [cell.contentView addSubview:lab];
                lab.text=_htmlStrArray[0];
            }
            NSArray * imgArr=[NSArray array];
            if (_htmlimgArray.count>0) {
                imgArr=_htmlimgArray[0];
                
                for (int i=0; i<imgArr.count; i++) {
                    
                    UIImageView * imgView=[[UIImageView alloc]init];
                    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,imgArr[i]]] placeholderImage:[UIImage imageNamed:@"card_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                        if(image.size.height>0)
                        {
                            imgView.frame=CGRectMake((kMainScreenWidth-HTMLIMGH*image.size.width/image.size.height)*0.5,rect.size.height+10  + i*(HTMLIMGH+10), HTMLIMGH*image.size.width/image.size.height, HTMLIMGH);
                        }
                        else
                        {
                            NSLog(@"image.size.height size is 0");
                        }
                    }];
                    imgView.backgroundColor=[UIColor redColor];
                    [cell.contentView addSubview:imgView];
                }
            }
           
            
            _height1=rect.size.height+20+imgArr.count*(HTMLIMGH+10);
            
        }
      
        return cell;
    } else if ( indexPath.section==3){
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL3];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL3];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            CGRect rect=CGRectMake(0, 0, 0, 0);
            if (_htmlStrArray.count>1) {//如果认证信息有值
                NSString * str=_htmlStrArray[1];
                rect=[str boundingRectWithSize:CGSizeMake(kMainScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
                
                UILabel * lab=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, kMainScreenWidth-30, rect.size.height)];
                lab.tag=200;
                lab.numberOfLines=0;
                lab.font=[UIFont systemFontOfSize:14];
                lab.textColor=DESCCOL;
                [cell.contentView addSubview:lab];
                lab.text=_htmlStrArray[1];
            }
            
            NSArray * imgArr=[NSArray array];
            if (_htmlimgArray.count>1) {
                imgArr=_htmlimgArray[1];
                for (int i=0; i<imgArr.count; i++) {
                    
                    UIImageView * imgView=[[UIImageView alloc]init];
                    
                    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,imgArr[i]]] placeholderImage:[UIImage imageNamed:@"card_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                        imgView.frame=CGRectMake((kMainScreenWidth-HTMLIMGH*image.size.width/image.size.height)*0.5,rect.size.height+10  + i*(HTMLIMGH+10), HTMLIMGH*image.size.width/image.size.height, HTMLIMGH);
                        
                    }];
                    
                    imgView.backgroundColor=[UIColor redColor];
                    [cell.contentView addSubview:imgView];
                }
            }
            
            _height2=rect.size.height+20+imgArr.count*(HTMLIMGH+10);
            
        }
       
        return cell;
    }
    
    
    
    else{
        XMYMapViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL4 forIndexPath:indexPath];
        cell.coordinateStr=_detailmodel.jingweidu;
        return cell;
    }


}

- (NSAttributedString *)string:(NSString *)string len:(NSInteger)len{

    NSMutableAttributedString * attr=[[NSMutableAttributedString alloc]initWithString:string];
    [attr addAttribute:NSForegroundColorAttributeName value:DESCCOL range:NSMakeRange(0, len)];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string.length)];
    return attr;
}


#pragma mark---MainSectionViewDelegate----
- (void)tableView:(UITableView *)tableView sectionDidSelected:(NSInteger)section{
    if (section==4) {
        MapPositionController * VC=[[MapPositionController alloc]init];
        VC.coorstr=_detailmodel.jingweidu;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==4) {
        MapPositionController * VC=[[MapPositionController alloc]init];
        VC.coorstr=_detailmodel.jingweidu;
        [self.navigationController pushViewController:VC animated:YES];
    }
}
@end
