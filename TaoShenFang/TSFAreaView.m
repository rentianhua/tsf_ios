//
//  TSFAreaView.m
//  YXM下拉框
//
//  Created by YXM on 16/11/7.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFAreaView.h"
#import "OtherHeader.h"
#import "ZYWHttpEngine.h"
#import "TSFAreaModel.h"
#import <MJExtension.h>
#define TABH 300

@interface TSFAreaView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    UIView * BGView;
}

@property (nonatomic,strong)UITableView * tableView1;
@property (nonatomic,strong)UITableView * tableView2;
@property (nonatomic,strong)UITableView * tableView3;


@property (nonatomic,strong)NSArray * array1;

@property (nonatomic,copy)NSString * string;

@property (nonatomic,strong)TSFAreaModel * model2;//第二个表
@property (nonatomic,strong)TSFAreaModel * model3;//第三个表

@property (nonatomic,strong)NSArray * areaArray;
@property (nonatomic,strong)NSArray * streetArray;

@property (nonatomic,strong)NSArray * subwayArray;


@property (nonatomic,strong)NSArray * dataArray;

@end

@implementation TSFAreaView
- (NSArray *)subwayArray{
    if (_subwayArray==nil) {
        _subwayArray=[NSArray arrayWithObjects:@"1号线",@"2号线",@"3号线",@"4号线",@"5号线",@"7号线",@"9号线",@"11号线", nil];
    }
    return _subwayArray;
}
- (NSArray *)array1{
    if (_array1==nil) {
        _array1=@[@"区域",@"地铁"];
    }
    return _array1;
}

- (UITableView *)tableView1{
    if (_tableView1==nil) {
        _tableView1=[[UITableView alloc]init];
        _tableView1.delegate=self;
        _tableView1.dataSource=self;
        
    }
    return _tableView1;
}

- (UITableView *)tableView2{
    if (_tableView2==nil) {
        _tableView2=[[UITableView alloc]init];
        _tableView2.delegate=self;
        _tableView2.dataSource=self;
        
    }
    return _tableView2;
}

- (UITableView *)tableView3{
    if (_tableView3==nil) {
        _tableView3=[[UITableView alloc]init];
        _tableView3.delegate=self;
        _tableView3.dataSource=self;
        
    }
    return _tableView3;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        
        [self loadData];
        
        
        
        
        BGView=[[UIView alloc]init];
        BGView.backgroundColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.3];
        [self addSubview:BGView];
        
        
        
        [BGView addSubview:self.tableView1];
        [BGView addSubview:self.tableView2];
        [BGView addSubview:self.tableView3];
        
    }
    return self;
}

- (void)loadData{
    
    [ZYWHttpEngine AllGetURL:[NSString stringWithFormat:@"%@g=api&m=house&a=diqu_all",URLSTR] params:nil success:^(id responseObj) {
        
        if (responseObj) {
            _areaArray=[TSFAreaModel mj_objectArrayWithKeyValuesArray:responseObj];
            
            _dataArray=_areaArray;
            [self.tableView2 reloadData];
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}




- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selfW=self.bounds.size.width;
    CGFloat selfH=self.bounds.size.height;
    
    BGView.frame=CGRectMake(0, 0, selfW, selfH);
    
    self.tableView1.frame=CGRectMake(0, 0, selfW*0.3, TABH);
    self.tableView2.frame=CGRectMake(selfW*0.3, 0, selfW*0.7, TABH);
    self.tableView3.frame=CGRectMake(selfW, 0, selfW*0.3, TABH);
    
    UITapGestureRecognizer * recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    recognizer.numberOfTapsRequired=1;
    recognizer.delegate=self;
    [BGView addGestureRecognizer:recognizer];


    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.tableView1] || [touch.view isDescendantOfView:self.tableView2] || [touch.view isDescendantOfView:self.tableView3] ) {
        return NO;
    } else{
        return YES;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (tableView==_tableView1) {
        return self.array1.count;
        
    } else if (tableView==_tableView2){
        if (_dataArray==_areaArray) {
           return _areaArray.count+1;
        } else{
            return _subwayArray.count+1;
        }
        
    } else{
        return _streetArray.count+1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableView1) {
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        
        cell.textLabel.text=self.array1[indexPath.row];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        return cell;
        
    } else if (tableView==_tableView2){
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        
        if (indexPath.row==0) {
            cell.textLabel.text=@"不限";
        } else{
            
            if (_dataArray==_areaArray) {
                TSFAreaModel * model=_areaArray[indexPath.row-1];
                cell.textLabel.text=model.name;
            } else{
                cell.textLabel.text=self.subwayArray[indexPath.row-1];
            }
        }
        cell.textLabel.font=[UIFont systemFontOfSize:14];

        return cell;
    } else{
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        }
        if (indexPath.row==0) {
            cell.textLabel.text=@"不限";
        } else{
            TSFAreaModel * model=_streetArray[indexPath.row-1];
            cell.textLabel.text=model.name;
            cell.textLabel.font=[UIFont systemFontOfSize:14];
        }
       
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableView2) {
        
        if (_dataArray==_areaArray) {
            if (indexPath.row>0) {
                self.tableView2.frame=CGRectMake(self.bounds.size.width*0.3, 0, self.bounds.size.width*0.3, TABH);
                self.tableView3.frame=CGRectMake(self.bounds.size.width*0.6, 0, self.bounds.size.width*0.4, TABH);
                
                
                TSFAreaModel * model=_areaArray[indexPath.row-1];
                _streetArray=model.area;
                [self.tableView3 reloadData];
                
                _model2=model;
                
            } else{//中间的表点击0行
                TSFAreaModel * model=nil;
                _block(model,100);
            }
 
        } else{
            
            if (indexPath.row==0) {
                NSString * string=nil;
                _block(string,100);
            } else{
               NSString * string=self.subwayArray[indexPath.row-1];
                
                _block(string,300);//地铁
            }
        }
        
        
        
    } else if (tableView==_tableView1) {
        CGFloat selfW=self.bounds.size.width;
        self.tableView2.frame=CGRectMake(selfW*0.3, 0, selfW*0.7, TABH);
        self.tableView3.frame=CGRectMake(selfW, 0, selfW*0.3, TABH);
        if (indexPath.row==0) {
            _dataArray=_areaArray;
            [self.tableView2 reloadData];
        } else{
            _dataArray=self.subwayArray;
            [self.tableView2 reloadData];
        }
        
    } else{
        
        if (indexPath.row==0) {//第三个表点击0行
            _block(_model2,300);
            
        } else{
            TSFAreaModel * model=_streetArray[indexPath.row-1];
            _model3=model;
            
            _block(_model3,400);
        }
        
       
        
    }
    
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer{
    
    _block(nil,200);
}


- (void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}


@end
