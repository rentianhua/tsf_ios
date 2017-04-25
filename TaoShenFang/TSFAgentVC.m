//
//  TSFAgentVC.m
//  TaoShenFang
//
//  Created by YXM on 16/11/3.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFAgentVC.h"
#import "OtherHeader.h"
#import <UIImageView+WebCache.h>
#import "TSFAgentDetailCell.h"//头像
#import "TSFAgentGradeCell.h"//历史成交
#import "TSFAgentAgeCell.h"//从业年限
#import "TSFAgentCommentCell.h"//评论cell
#import "TSFAgentSuccessCell.h"//成交房源
#import "TSFAgentModel.h"
#import "TSFAgentBaseModel.h"
#import "TSFCommentModel.h"
#import "ZYWHttpEngine.h"
#import <MJExtension.h>
#import "MainSectionView.h"
#import "HouseModel.h"
#import "TSFSeeMoreView.h"
#import "TSFNodataView.h"
#import "IDModel.h"
#import "HandRoomDetailVC.h"
#import "LoginViewController.h"
#import "TSFMessageDetailVC.h"

#import "YJProgressHUD.h"

#import "TSFCommentVC.h"//评论界面
#import "TSFSuccessListVC.h"//成交房源
#import "TSFCommentListVC.h"

#define CELL00 @"cell00"//经纪人资料
#define CELL01 @"cell01"//从业年限
#define CELL02 @"cell02"//历史成交
#define CELL1 @"cell1"//评论
#define CELL2 @"cell2"//成交房源
#define CELL3 @"cell3"//二手房源


#define NAVBTNW 20

@interface TSFAgentVC ()<UITableViewDelegate,UITableViewDataSource,TSFSeeMoreViewDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIButton * leftNavBtn;
@property (nonatomic,strong)TSFAgentModel * model;

@property (nonatomic,strong)NSArray * successArray;
@property (nonatomic,strong)NSArray * handArray;
@property (nonatomic,strong)NSArray * commentArray;

@end

@implementation TSFAgentVC
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
- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:@"TSFAgentDetailCell" bundle:nil] forCellReuseIdentifier:CELL00];
         [_tableView registerNib:[UINib nibWithNibName:@"TSFAgentAgeCell" bundle:nil] forCellReuseIdentifier:CELL01];
         [_tableView registerNib:[UINib nibWithNibName:@"TSFAgentGradeCell" bundle:nil] forCellReuseIdentifier:CELL02];
         [_tableView registerNib:[UINib nibWithNibName:@"TSFAgentCommentCell" bundle:nil] forCellReuseIdentifier:CELL1];
         [_tableView registerNib:[UINib nibWithNibName:@"TSFAgentSuccessCell" bundle:nil] forCellReuseIdentifier:CELL2];
         [_tableView registerNib:[UINib nibWithNibName:@"TSFAgentSuccessCell" bundle:nil] forCellReuseIdentifier:CELL3];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadCommentData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"淘深房经纪人店铺";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    [self.view addSubview:self.tableView];
    
    [self loadData];

}

- (void)loadSuccessData{
    

    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    __weak typeof(self)weakSelf=self;
    NSDictionary * param=@{@"username":_model.base.username,
                           @"table":@"ershou",
                           @"userid":NSUSER_DEF(USERINFO)[@"userid"]==nil?@"":NSUSER_DEF(USERINFO)[@"userid"]};
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=chengjiao",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
        weakSelf.successArray=[HouseModel mj_objectArrayWithKeyValuesArray:responseObj];
            [weakSelf.tableView reloadData];
            
        }
       
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
    }];
}

- (void)loadHandData{
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    NSDictionary * param=@{@"username":_model.base.username,
                           @"userid":_model.userid,
                           @"table":@"ershou"};
    __weak typeof(self)weakSelf=self;
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=house_list",URLSTR] params:param success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
           weakSelf.handArray=[HouseModel mj_objectArrayWithKeyValuesArray:responseObj];
            
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
    }];
}

- (void)loadCommentData{
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];

    __weak typeof(self)weakSelf=self;
    [ZYWHttpEngine AllGetURL:[NSString stringWithFormat:@"%@g=Api&m=user&a=jjr_comment&id=%@",URLSTR,_userid] params:nil success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            weakSelf.commentArray=[TSFCommentModel mj_objectArrayWithKeyValuesArray:responseObj];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.view];

    }];
}


- (void)setUserid:(NSNumber *)userid{
    _userid=userid;
}

- (void)loadData{
    
    NSString * urlStr=[NSString stringWithFormat:@"%@g=Api&m=user&a=jjrshow&id=%@",URLSTR,_userid];
    
    __weak typeof(self)weakSelf=self;
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    [ZYWHttpEngine AllGetURL:urlStr params:nil success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            
            _model=[TSFAgentModel mj_objectWithKeyValues:responseObj];
           
            [weakSelf loadSuccessData];
            [weakSelf loadHandData];
            
            [weakSelf.tableView reloadData];
        }

    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:{
            if (_commentArray.count<2) {
                return _commentArray.count;
            } else{
                return 2;
            }
        }
            break;
        case 2:{//成交房源
            if (_successArray.count<3) {
                return _successArray.count;
            } else{
                return 3;
            }
        }
            break;
        default:{//二手房
            if (_handArray.count<3) {
                return _handArray.count;
            } else{
                return 3;
            }
        }
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:{
                    TSFAgentDetailCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL00 forIndexPath:indexPath ];
                    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:_model.base.userpic] placeholderImage:[UIImage imageNamed:@"img_no_agent"]];
                    NSString * dengji=nil;
                    if ([_model.dengji isEqual:@1]) {
                        dengji=@"普通经纪人";
                    } else if ([_model.dengji isEqual:@2]){
                        dengji=@"优秀经纪人";
                    }
                    else if ([_model.dengji isEqual:@2]){
                        dengji=@"高级经纪人";
                    } else{
                        dengji=@"资深经纪人";
                    }
                    
                    NSString * str1=[NSString stringWithFormat:@"%@ %@",_model.realname,dengji];
                    NSRange range=[str1 rangeOfString:dengji];
                    NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:str1];
                    [attrStr setAttributes:@{NSForegroundColorAttributeName:RGB(237, 27, 36, 1.0),NSFontAttributeName:[UIFont systemFontOfSize:14]} range:range];
                    
                    [cell.label1 setAttributedText:attrStr];
                    cell.label2.text=[NSString stringWithFormat:@"主营板块:%@",_model.mainareaids];
                    cell.label3.text= [NSString stringWithFormat:@"%@",_model.base.vtel];
                    cell.biaoqian=_model.biaoqian;
                    
                    [cell.phoneBtn addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell.messageBtn addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    return cell;
                }
                    break;
                case 1:{
                    TSFAgentAgeCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL01 forIndexPath:indexPath];
                    
                    NSString  *str1=nil;
                    NSString *nianxian=nil;
                    if(_model.worktime.length<=0)
                    {
                        str1 = @"从业年限:";
                    }
                    else
                    {
                        str1 = [NSString stringWithFormat:@"从业年限:%@年",_model.worktime];
                        nianxian = [NSString stringWithFormat:@"%@年",_model.worktime];
                    }
                    NSMutableAttributedString * attrStr1=[[NSMutableAttributedString alloc]initWithString:str1];
                    if(nianxian)
                    {
                        NSRange range1=[str1 rangeOfString:nianxian];
                        [attrStr1 setAttributes:@{NSForegroundColorAttributeName:RGB(153, 153, 153, 1.0)} range:range1];
                    }
                    [cell.label1 setAttributedText:attrStr1];
                    
                    NSString  * str2=[NSString stringWithFormat:@"主营板块:%@",_model.mainareaids];
                    NSString * mainarea=[NSString stringWithFormat:@"%@",_model.mainareaids];
                    NSMutableAttributedString * attrStr2=[[NSMutableAttributedString alloc]initWithString:str2];
                     NSRange range2=[str2 rangeOfString:mainarea];
                     [attrStr2 setAttributes:@{NSForegroundColorAttributeName:RGB(153, 153, 153, 1.0)} range:range2];
                    [cell.label2 setAttributedText:attrStr2];
                    
                    NSString  * str3=nil;
                    NSString * coname=nil;
                    if ([_model.leixing isEqualToString:@"个人"]) {
                        str3=[NSString stringWithFormat:@"所属公司:%@",_model.leixing];
                        coname=[NSString stringWithFormat:@"%@",_model.leixing];
                    } else{
                        str3=[NSString stringWithFormat:@"所属公司:%@",_model.coname];
                        coname=[NSString stringWithFormat:@"%@",_model.coname];
                    }
                    NSMutableAttributedString * attrStr3=[[NSMutableAttributedString alloc]initWithString:str3];
                     NSRange range3=[str3 rangeOfString:coname];
                   [attrStr3 setAttributes:@{NSForegroundColorAttributeName:RGB(153, 153, 153, 1.0)} range:range3];
                    [cell.label3 setAttributedText:attrStr3];
                    
                    return cell;
                }
                    
                    break;
                    
                default:{
                    TSFAgentGradeCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL02 forIndexPath:indexPath];
                    //wangyutao
                    cell.label1.text = [NSString stringWithFormat:@"%@", _model.chengjiao_count];
                    cell.label2.text = [NSString stringWithFormat:@"%@", _model.weituo_count];
                    cell.label3.text = [NSString stringWithFormat:@"%@", _model.daikan_count];
                    return cell;
                }
                    break;
            }
            break;
        case 1:{
            TSFAgentCommentCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL1 forIndexPath:indexPath];
            TSFCommentModel * model=_commentArray[indexPath.row];
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.userpic] placeholderImage:[UIImage imageNamed:@"card_default"]];
            
            NSString * username=[model.author stringByReplacingCharactersInRange:NSMakeRange(3, model.author.length-3) withString:@"***"];
            cell.label1.text=username;
            cell.label2.text=model.content;
            cell.label3.text=model.date;
            return cell;
        }
            
            break;
        case 2:{
            TSFAgentSuccessCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL2 forIndexPath:indexPath];
        
            HouseModel * model=_successArray[indexPath.row];
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
            cell.label1.text=model.title;
            cell.label2.text=[NSString stringWithFormat:@"%@/%@/%@层",model.chaoxiang,model.ceng,model.zongceng];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY-MM-dd"];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.inputtime integerValue]];
            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            cell.label3.text=[NSString stringWithFormat:@"签约时间:%@",confromTimespStr];
            
            NSString * danjia=nil;
            if ([model.jianzhumianji isEqualToString:@"0"] || model.jianzhumianji==nil  || [model.zongjia isEqualToString:@"0"] || model.zongjia==nil ) {
                danjia=@"价格待定";
            } else{
                danjia=[NSString stringWithFormat:@"%.f", 10000* [model.zongjia floatValue]/[model.jianzhumianji floatValue]];
            }
            
            
            NSString * price=[NSString stringWithFormat:@"%@元/平",danjia];
            NSString * zongjia=[NSString stringWithFormat:@"%@万",model.zongjia];
            NSString * string=[NSString stringWithFormat:@"%@ %@",price,zongjia];
            
            NSRange range1=[string rangeOfString:zongjia];
            NSRange range2=[string rangeOfString:danjia];
            
            NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:string];
            [attrStr setAttributes:@{NSForegroundColorAttributeName:RGB(237, 27, 36, 1.0),NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:range1];
            [attrStr setAttributes:@{NSForegroundColorAttributeName:RGB(51, 51, 51, 1.0),NSFontAttributeName:[UIFont systemFontOfSize:12]} range:range2];
            [cell.label4 setAttributedText:attrStr];
                
            
            return cell;
        }
            
            break;
        case 3:{
            TSFAgentSuccessCell * cell=[tableView dequeueReusableCellWithIdentifier:CELL3 forIndexPath:indexPath];
            HouseModel * model=_handArray[indexPath.row];
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
            cell.label1.text=model.title;
            cell.label2.text=[NSString stringWithFormat:@"%@/%@/%@层",model.chaoxiang,model.ceng,model.zongceng];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY-MM-dd"];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.inputtime integerValue]];
            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            cell.label3.text=[NSString stringWithFormat:@"发布时间:%@",confromTimespStr];
            
            NSString * danjia=nil;
            if ([model.jianzhumianji isEqualToString:@"0"] || model.jianzhumianji==nil  || [model.zongjia isEqualToString:@"0"] || model.zongjia==nil ) {
                danjia=@"价格待定";
            } else{
                danjia=[NSString stringWithFormat:@"%.f", 10000* [model.zongjia floatValue]/[model.jianzhumianji floatValue]];
            }
            
            
            NSString * price=[NSString stringWithFormat:@"%@元/平",danjia];
            NSString * zongjia=[NSString stringWithFormat:@"%@万",model.zongjia];
            NSString * string=[NSString stringWithFormat:@"%@ %@",price,zongjia];
            
            NSRange range1=[string rangeOfString:zongjia];
            NSRange range2=[string rangeOfString:danjia];
            
            NSMutableAttributedString * attrStr=[[NSMutableAttributedString alloc]initWithString:string];
            [attrStr setAttributes:@{NSForegroundColorAttributeName:RGB(237, 27, 36, 1.0),NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:range1];
            [attrStr setAttributes:@{NSForegroundColorAttributeName:RGB(51, 51, 51, 1.0),NSFontAttributeName:[UIFont systemFontOfSize:12]} range:range2];
            [cell.label4 setAttributedText:attrStr];
            return cell;
        }
            
            break;
            
        default:
            return nil;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return nil;
    } else{
        MainSectionView * secView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"sec"];
        if (!secView) {
            secView=[[MainSectionView alloc]initWithReuseIdentifier:@"sec"];
        }
        switch (section) {
            case 1:
                secView.leftLabel.text=@"Ta的评价";
                secView.rightButton.hidden=NO;
                [secView.rightButton setImage:[UIImage imageNamed:@"jjr_comment"] forState:UIControlStateNormal];
                [secView.rightButton setTitle:@"写评价" forState:UIControlStateNormal];
                [secView.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [secView.rightButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2:
                secView.leftLabel.text=@"成交房源";
                secView.rightButton.hidden=YES;
                break;
            case 3:
                secView.leftLabel.text=@"二手房源";
                secView.rightButton.hidden=YES;
                break;
                
            default:
                break;
        }
        return secView;
    }
    
}

- (void)commentAction:(UIButton *)button{
    
    if ( NSUSER_DEF(USERINFO)==nil) {
        LoginViewController * VC=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:VC];
        [self presentViewController:nav animated:YES completion:nil];
    } else{
        TSFCommentVC * VC=[[TSFCommentVC alloc]init];
        VC.ID=_model.userid;
        [self.navigationController pushViewController:VC animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 0.0001;
            break;
            
        default:
            return 50;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //TSFNodataView.h
    switch (section) {
        case 1:{
            if (_commentArray.count==0) {
                TSFNodataView * footer=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"nodata"];
                if (!footer) {
                    footer=[[TSFNodataView alloc]initWithReuseIdentifier:@"nodata"];
                }
                return footer;
            } else{
                TSFSeeMoreView * footerView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"foot"];
                if (!footerView) {
                    footerView=[[TSFSeeMoreView alloc]initWithReuseIdentifier:@"foot"];
                }
                footerView.section=section;
                footerView.delegate=self;
                return footerView;
            }
        }
            break;
        case 2:{//成交房源
            if (_successArray.count==0) {
                TSFNodataView * footer=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"nodata"];
                if (!footer) {
                    footer=[[TSFNodataView alloc]initWithReuseIdentifier:@"nodata"];
                }
                return footer;
            } else{
                TSFSeeMoreView * footerView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"foot"];
                if (!footerView) {
                    footerView=[[TSFSeeMoreView alloc]initWithReuseIdentifier:@"foot"];
                }
                footerView.section=section;
                footerView.delegate=self;
                return footerView;
            }
        }
            
            break;
        case 3:{
            if (_handArray.count==0) {
                TSFNodataView * footer=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"nodata"];
                if (!footer) {
                    footer=[[TSFNodataView alloc]initWithReuseIdentifier:@"nodata"];
                }
                return footer;
            } else{
                TSFSeeMoreView * footerView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"foot"];
                if (!footerView) {
                    footerView=[[TSFSeeMoreView alloc]initWithReuseIdentifier:@"foot"];
                }
                footerView.section=section;
                footerView.delegate=self;
                return footerView;
            }

        }
            
            break;
            
        default:
            return nil;
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 10;
            break;
            
        default:
            return 60;
            break;
    }
    
}

#pragma ------TSFSeeMoreViewDelegate------//查看更多
- (void)tableView:(UITableView *)tableView selectFooter:(NSInteger)section{
    switch (section) {
        case 1:{
            TSFCommentListVC * VC=[[TSFCommentListVC alloc]init];
            VC.userid=_model.userid;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 2:{
            TSFSuccessListVC * VC=[[TSFSuccessListVC alloc]init];
            VC.model=_model;
            VC.isHand=NO;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 3:{
            TSFSuccessListVC * VC=[[TSFSuccessListVC alloc]init];
            VC.model=_model;
            VC.isHand=YES;
            [self.navigationController pushViewController:VC animated:YES];

        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 2:{
            HouseModel * model=_successArray[indexPath.row];
            HandRoomDetailVC * VC=[[HandRoomDetailVC alloc]init];
            VC.model=model;
            [self.navigationController pushViewController:VC animated:YES];
        }
            
            break;
        case 3:{
            HouseModel * model=_handArray[indexPath.row];
            HandRoomDetailVC * VC=[[HandRoomDetailVC alloc]init];
            VC.model=model;
            [self.navigationController pushViewController:VC animated:YES];

        }
            
            break;
            
        default:
            break;
    }
}

- (void)phoneAction:(UIButton *)phoneBtn{

    NSMutableString * str=[[NSMutableString alloc]initWithFormat:@"tel:%@",_model.base.ctel];
    UIWebView * callWebView=[[UIWebView alloc]init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebView];
    
}

- (void)messageAction:(UIButton *)button{
    
    if (NSUSER_DEF(USERINFO)==nil) {
        LoginViewController * VC=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:VC];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    NSNumber * userid=[NSNumber numberWithInteger:[NSUSER_DEF(USERINFO)[@"userid"] integerValue]];
    if ([_model.userid isEqualToNumber:userid]) {
        [YJProgressHUD showMessage:@"亲，不能给自己留言" inView:self.view];
        return;
    }
    
    TSFMessageDetailVC * VC=[[TSFMessageDetailVC alloc]init];
    VC.towho=[NSString stringWithFormat:@"%@",_model.userid];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
