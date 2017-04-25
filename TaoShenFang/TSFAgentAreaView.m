//
//  TSFAgentAreaView.m
//  TaoShenFang
//
//  Created by YXM on 16/11/10.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFAgentAreaView.h"
#import "OtherHeader.h"
#import "ZYWHttpEngine.h"
#import "TSFAreaModel.h"
#import <MJExtension.h>
#import "YJProgressHUD.h"

#define KSCREENW [UIScreen mainScreen].bounds.size.width
#define TABH 300

@interface TSFAgentAreaView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    UIView * _BGView;
    BOOL isPaixu;
}

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * array;

@property (nonatomic,assign)NSIndexPath * lastIndexPath;

@property (nonatomic,assign)BOOL isLocationFilterChecked;


@end


@implementation TSFAgentAreaView

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]init];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array{
    if (self=[super initWithFrame:frame]) {
        
        isPaixu=YES;
        _array=array;
        
        
        _BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENW, self.bounds.size.height)];
        _BGView.backgroundColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.3];
        [self addSubview:_BGView];
        
        UITapGestureRecognizer * recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        recognizer.numberOfTapsRequired=1;
        recognizer.delegate=self;
        [_BGView addGestureRecognizer:recognizer];
        
        [_BGView addSubview:self.tableView];
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        
        
        [self loadData];
        
        _BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENW, self.bounds.size.height)];
        _BGView.backgroundColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.3];
        [self addSubview:_BGView];
        
        UITapGestureRecognizer * recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        recognizer.numberOfTapsRequired=1;
        recognizer.delegate=self;
        [_BGView addGestureRecognizer:recognizer];
        
        [_BGView addSubview:self.tableView];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame=CGRectMake(0, 0, KSCREENW, TABH);
}

- (void)loadData{
    
    __weak typeof(self)weakSelf=self;
    
    
    [YJProgressHUD showProgress:@"正在加载中" inView:self.superview];
    [ZYWHttpEngine AllGetURL:[NSString stringWithFormat:@"%@g=api&m=house&a=diqu_all",URLSTR] params:nil success:^(id responseObj) {
        [YJProgressHUD hide];
        if (responseObj) {
            weakSelf.array=[TSFAreaModel mj_objectArrayWithKeyValuesArray:responseObj];
            
            [weakSelf.tableView reloadData];
            
        }

    } failure:^(NSError *error) {
        [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络不行了" inView:weakSelf.superview];
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    if (isPaixu==YES) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"不限";
        } else{
            cell.textLabel.text=_array[indexPath.row-1];
        }
    } else{
        if (indexPath.row==0) {
            cell.textLabel.text=@"不限";
        } else{
            TSFAreaModel * model=_array[indexPath.row-1];
            cell.textLabel.text=model.name;
        }
    }
   
    
    if (_isLocationFilterChecked ==YES && _lastIndexPath==indexPath) {
        cell.textLabel.textColor=[UIColor redColor];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSInteger newRow=indexPath.row;
    NSInteger oldRow=_lastIndexPath.row;
    if (_lastIndexPath==nil) {
        UITableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor=[UIColor redColor];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        _isLocationFilterChecked=YES;

    } else if (newRow==oldRow){
        if (_isLocationFilterChecked==NO) {
            UITableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.textColor=[UIColor redColor];
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
            _isLocationFilterChecked=YES;
        } else{
            UITableViewCell * cell=[tableView cellForRowAtIndexPath:_lastIndexPath];
            cell.textLabel.textColor=[UIColor blackColor];
            cell.accessoryType=UITableViewCellAccessoryNone;
            _isLocationFilterChecked=NO;
        }
    } else if (newRow!=oldRow){
        
            UITableViewCell * newcell=[tableView cellForRowAtIndexPath:indexPath];
            newcell.textLabel.textColor=[UIColor redColor];
            newcell.accessoryType=UITableViewCellAccessoryCheckmark;
        
        UITableViewCell * oldcell=[tableView cellForRowAtIndexPath:_lastIndexPath];
        oldcell.textLabel.textColor=[UIColor blackColor];
        oldcell.accessoryType=UITableViewCellAccessoryNone;

        _isLocationFilterChecked=YES;
        
    }
    
    
    __weak typeof(self)weakSelf=self;
    
    
    if (isPaixu==YES) {
        if (indexPath.row==0) {
            weakSelf.areaBlock(@"不限");
        } else{
            NSString * string=_array[indexPath.row-1];
            weakSelf.areaBlock(string);
            
        }
    } else{
        if (indexPath.row==0) {
            weakSelf.areaBlock(@"不限");
        } else{
            NSString * string=[_array[indexPath.row-1] name];
            weakSelf.areaBlock(string);
            
        }
    }
    
    
    
    _lastIndexPath=indexPath;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.tableView]  ) {
        return NO;
    } else{
        return YES;
    }
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer{
    
    //__weak typeof(self)weakSelf=self;
    //weakSelf.areaBlock(nil);
    [self removeFromSuperview];
}



@end
