//
//  TSFNewAreaView.m
//  TaoShenFang
//
//  Created by YXM on 16/11/9.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFNewAreaView.h"
#import "OtherHeader.h"
#import "ZYWHttpEngine.h"
#import "TSFAreaModel.h"
#import <MJExtension.h>
//#import "MBProgressHUD+XM.h"
#import "YJProgressHUD.h"
#define KSCREENW [UIScreen mainScreen].bounds.size.width
#define KSCREENH [UIScreen mainScreen].bounds.size.height
#define TABH 300

@interface TSFNewAreaView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    UIView * BGView;
}


@property (nonatomic,strong)UITableView * tableView1;
@property (nonatomic,strong)UITableView * tableView2;

@property (nonatomic,strong)NSArray * areaArray;
@property (nonatomic,strong)NSArray * streetArray;

@property (nonatomic,strong)TSFAreaModel * model1;


@end

@implementation TSFNewAreaView

- (UITableView *)tableView1{
    if (_tableView1==nil) {
        _tableView1=[[UITableView alloc]init];
        _tableView1.delegate=self;
        _tableView1.dataSource=self;
        _tableView1.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView1;
}

- (UITableView *)tableView2{
    if (_tableView2==nil) {
        _tableView2=[[UITableView alloc]init];
        _tableView2.delegate=self;
        _tableView2.dataSource=self;
        _tableView2.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView2;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        
        
        BGView=[[UIView alloc]init];
        BGView.backgroundColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.3];
        [self addSubview:BGView];
        
        

        [BGView addSubview:self.tableView1];
        [BGView addSubview:self.tableView2];
        
        
        
        [self loadData];
        
    }
    return self;
}

- (void)loadData{
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.superview];
    
    __weak typeof(self)weakSelf=self;
    [ZYWHttpEngine AllGetURL:[NSString stringWithFormat:@"%@g=api&m=house&a=diqu_all",URLSTR] params:nil success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            
            weakSelf.areaArray=[TSFAreaModel mj_objectArrayWithKeyValuesArray:responseObj];
            [weakSelf.tableView1 reloadData];
            
        }
    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"请检查网络设置" inView:weakSelf.superview];
        
    }];
    
}



- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat selfW=self.bounds.size.width;
    CGFloat selfH=self.bounds.size.height;
    
    BGView.frame=CGRectMake(0, 0, selfW, selfH);
    UITapGestureRecognizer * recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    recognizer.numberOfTapsRequired=1;
    recognizer.delegate=self;
    [BGView addGestureRecognizer:recognizer];
    
    
    
    self.tableView1.frame=CGRectMake(0, 0, KSCREENW, TABH);
    self.tableView2.frame=CGRectMake(CGRectGetMaxX(self.tableView1.frame), 0, KSCREENW*0.6, TABH);
    
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.tableView1] || [touch.view isDescendantOfView:self.tableView2] ) {
        return NO;
    } else{
        return YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_tableView1) {
        
        if (_areaArray.count==1) {
            tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        } else{
            tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        }
        
        return _areaArray.count+1;
    } else{
        if (_streetArray.count==1) {
            tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        } else{
            tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        }
        return _streetArray.count+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableView1) {
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        
        
        if (_areaArray.count!=1) {
            if (indexPath.row==0) {
                cell.textLabel.text=@"不限";
            } else{
                TSFAreaModel * model=self.areaArray[indexPath.row-1];
                cell.textLabel.text=model.name;
            }
        }
        
        return cell;
    } else{
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        
        if (_streetArray.count!=1) {
            if (indexPath.row==0) {
                if (_streetArray.count==1) {
                    
                } else{
                    cell.textLabel.text=@"不限";
                }
                
            } else{
                TSFAreaModel * model=self.streetArray[indexPath.row-1];
                cell.textLabel.text=model.name;
            }
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak  typeof(self) weakSelf=self;
    if (tableView==_tableView1) {
        
        if (indexPath.row==0) {
            weakSelf.areaBlock(nil,100);
        } else{
        
            self.tableView1.frame=CGRectMake(0, 0, KSCREENW*0.4, TABH);
            self.tableView2.frame=CGRectMake(CGRectGetMaxX(self.tableView1.frame), 0, KSCREENW*0.6, TABH);
            
        
        TSFAreaModel * model=self.areaArray[indexPath.row-1];
        _streetArray=model.area;
        
        [self.tableView2 reloadData];
        
        _model1=model;
        }
    }
    
    
    if (tableView==_tableView2) {
        if (indexPath.row==0) {
          
            weakSelf.areaBlock(weakSelf.model1,100);
        } else{
            TSFAreaModel * model =self.streetArray[indexPath.row-1];
            weakSelf.areaBlock(model,300);
        }
    }
    
    
    
}


- (void)singleTap:(UITapGestureRecognizer *)recognizer{
    
   __weak typeof(self) weakSelf=self;
    weakSelf.areaBlock(nil,200);
}


@end
