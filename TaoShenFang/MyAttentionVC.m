//
//  MyAttentionVC.m
//  TaoShenFang
//
//  Created by YXM on 16/8/30.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "MyAttentionVC.h"
#import "OtherHeader.h"
#import <Masonry.h>
#import "ZYWHttpEngine.h"
#import "OtherHeader.h"
#import "AttentionModel.h"
#import "AttentionHandCell.h"
#import "AttentionNewCell.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "HandRoomDetailVC.h"
#import "NewRoomDetailViewController.h"
#import "IDModel.h"
#import "YJProgressHUD.h"


#define NAVBTNW 20
@interface MyAttentionVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;//表

@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * handroomData;
@property (nonatomic,strong)NSMutableArray * newroomData;

@property (nonatomic,strong)NSMutableArray * listArray;//需要展示的数据

@property (nonatomic,assign)NSInteger isSelectTag;

@property (nonatomic,strong)UISegmentedControl * segment;

@property (nonatomic,strong)UIButton * leftNavBtn;

@end

@implementation MyAttentionVC{
    BOOL didConstraints;
}
- (UIButton *)leftNavBtn{
    if (_leftNavBtn==nil) {
        _leftNavBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NAVBTNW, NAVBTNW)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftNavBtn;
}

- (NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
- (UISegmentedControl *)segment{
    if (_segment==nil) {
        _segment=[[UISegmentedControl alloc]initWithItems:@[@"二手房",@"新房"]];
        _segment.tintColor=[UIColor redColor];
        [_segment addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}
- (NSMutableArray *)listArray{
    if (_listArray==nil) {
        _listArray=[NSMutableArray array];
    }
    return _listArray;
}
- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]init];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:@"AttentionHandCell" bundle:nil] forCellReuseIdentifier:@"handcell"];
         [_tableView registerNib:[UINib nibWithNibName:@"AttentionNewCell" bundle:nil] forCellReuseIdentifier:@"newcell"];
        
        UIView * view=[[UIView alloc]initWithFrame:CGRectZero];
        _tableView.tableFooterView=view;
    }
    return _tableView;
}
- (NSMutableArray *)handroomData{
    if (_handroomData==nil) {
        _handroomData=[NSMutableArray array];
    }
    return _handroomData;
}
- (NSMutableArray *)newroomData{
    if (_newroomData==nil) {
        _newroomData=[NSMutableArray array];
    }
    return _newroomData;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
    self.navigationItem.titleView=self.segment;
    self.segment.selectedSegmentIndex=0;
    [self controlAction:self.segment];
    _isSelectTag=100;
    
    [self setUpSubviews];
    
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setUpSubviews{
   
    [self.view addSubview:self.tableView];
    [self.view setNeedsUpdateConstraints];
}
- (void)updateViewConstraints{
    [super updateViewConstraints];
    if (!didConstraints) {
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.and.right.and.bottom.mas_equalTo(0);
        }];
        didConstraints=YES;
    }

}

- (void)controlAction:(UISegmentedControl *)control{
    if (self.dataArray.count>0) {
        [self.dataArray removeAllObjects];
    }
    NSInteger x=control.selectedSegmentIndex;
    
    if (x ==0) {
       
        [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
        NSString * username=NSUSER_DEF(USERINFO)[@"username"];
        NSDictionary * param=@{@"username":username,
                               @"table":@"ershou"};
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=guanzhu",URLSTR] params:param success:^(id responseObj) {
            [YJProgressHUD hide];
            if (responseObj) {
              self.dataArray=[AttentionModel mj_objectArrayWithKeyValuesArray:responseObj];
                if (self.dataArray.count==0) {
                    [YJProgressHUD showMessage:@"无数据" inView:self.view];
                }
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
        }];
        
        _segment.selectedSegmentIndex=0;
    }
    
    if (x==1) {
        [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
        NSString * username=NSUSER_DEF(USERINFO)[@"username"];
        NSDictionary * param=@{@"username":username,
                               @"table":@"new"};
        [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=guanzhu",URLSTR] params:param success:^(id responseObj) {
            
           [YJProgressHUD hide];
            if (responseObj) {
                self.dataArray=[AttentionModel mj_objectArrayWithKeyValuesArray:responseObj];
                if (self.dataArray.count==0) {
                     [YJProgressHUD showMessage:@"无数据" inView:self.view];
                }
                
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            [YJProgressHUD hide];
            [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
        }];
        
        _segment.selectedSegmentIndex=1;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AttentionModel * model=nil;
    
    if (_segment.selectedSegmentIndex==0) {
        model=_dataArray[indexPath.row];
        AttentionHandCell * cell=[tableView dequeueReusableCellWithIdentifier:@"handcell" forIndexPath:indexPath];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.house.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
        cell.label1.text=model.house.title;
        cell.label2.text=[NSString stringWithFormat:@"%@ %@室%@厅",model.house.xiaoquname,model.house.shi,model.house.ting];
        cell.label3.text=[NSString stringWithFormat:@"%@㎡ %@ %@(共%@层)",model.house.jianzhumianji,model.house.chaoxiang,model.house.ceng,model.house.zongceng];
        
        NSString * zongjiaStr=[NSString stringWithFormat:@"%@万",model.house.zongjia];
        cell.label4.text=zongjiaStr;
        
        float price;
        if ([model.house.jianzhumianji floatValue]>0) {
          price=  [model.house.zongjia floatValue]/[model.house.jianzhumianji floatValue];
        }
        cell.label5.textColor=[UIColor darkGrayColor];
        cell.label5.font=[UIFont systemFontOfSize:12];
        cell.label5.textAlignment=NSTextAlignmentRight;
        cell.label5.text=[NSString stringWithFormat:@"%.f 元/㎡",price*10000];
        return cell;
    } else{
        model=_dataArray[indexPath.row];
        AttentionNewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"newcell" forIndexPath:indexPath];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.house.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
        cell.label1.text=model.house.title;
        cell.label4.text=[NSString stringWithFormat:@"%@㎡",model.house.mianjiarea];
        cell.label3.textColor=NavBarColor;
        cell.label3.font=[UIFont systemFontOfSize:12];
        NSString * junjiaStr=[NSString stringWithFormat:@"%@元/㎡",model.house.junjia];
        NSMutableAttributedString * junjia=[[NSMutableAttributedString alloc]initWithString:junjiaStr];
        [junjia addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:18] range:NSMakeRange(0, junjiaStr.length-3)];
        [junjia addAttribute:NSForegroundColorAttributeName value:NavBarColor range:NSMakeRange(0, junjiaStr.length)];
        [cell.label3 setAttributedText:junjia];
        cell.label2.text=[NSString stringWithFormat:@"%@",model.house.loupandizhi];
      
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    IDModel * idmodel=[[IDModel alloc]init];
    if (_segment.selectedSegmentIndex==0) {//二手房详情
        AttentionModel * model=self.dataArray[indexPath.row];
        
        HandRoomDetailVC * vc=[[HandRoomDetailVC alloc]init];
        vc.model=model.house;
        [self.navigationController pushViewController:vc animated:YES];
    } else{//新房详情
        AttentionModel * model=self.dataArray[indexPath.row];
        idmodel.catid=model.house.catid;
        idmodel.ID=model.house.ID;

        NewRoomDetailViewController * vc=[[NewRoomDetailViewController alloc]init];
        vc.idModel=idmodel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//按钮显示的内容
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"取消关注";
    
}
//这里就是点击删除执行的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    AttentionModel * model=self.dataArray[indexPath.row];
    
    NSString * userid=NSUSER_DEF(USERINFO)[@"userid"];
    NSString * username=NSUSER_DEF(USERINFO)[@"username"];
    NSDictionary * param=@{
                           @"id":model.ID,
                           @"userid":userid,
                           @"username":username
                           };
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.view];
    [ZYWHttpEngine AllPostURL:[NSString stringWithFormat:@"%@g=api&m=user&a=guanzhu_del",URLSTR] params:param success:^(id responseObj) {
        
        [YJProgressHUD hide];
        if (responseObj) {
            if ([responseObj[@"success"] isEqualToNumber:@108]) {//取消关注成功
                [YJProgressHUD showMessage:@"取消关注成功" inView:self.view];
                [self controlAction:self.segment];
            }
        }
        
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:self.view];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
