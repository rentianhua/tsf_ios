//
//  TSFTypeView.m
//  YXM下拉框
//
//  Created by YXM on 16/11/7.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFTypeView.h"

#define TABH 300
#define KSCREENW [UIScreen mainScreen].bounds.size.width
#define KSCREENH [UIScreen mainScreen].bounds.size.height

@interface TSFTypeView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    UIView * _BGView;
}

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView * footerView;
@property (nonatomic,strong)NSArray * array;


@end

@implementation TSFTypeView

- (UIView *)footerView{
    if (_footerView==nil) {
        _footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENW, 60)];
        UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(15, 15, KSCREENW-30, 30)];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor=[UIColor colorWithRed:237/255.0 green:27/255.0 blue:36/255.0 alpha:1.0];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_footerView addSubview:button];
        [button addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _footerView;
}
- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCREENW, TABH) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array{
    if (self=[super initWithFrame:frame]) {
        
        _BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENW, self.bounds.size.height)];
        _BGView.backgroundColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.3];
        [self addSubview:_BGView];
        UITapGestureRecognizer * recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        recognizer.numberOfTapsRequired=1;
        recognizer.delegate=self;
        [_BGView addGestureRecognizer:recognizer];
        
        [_BGView addSubview:self.tableView];
        
        _array=array;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    } else{
        return YES;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text=self.array[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
       _typeBlock(nil,100);//不限
    } else{
    NSString * string=self.array[indexPath.row];
        _typeBlock(string,300);//其他选中
    }
}


- (void)confirmAction:(UIButton *)button{
    
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer{
    
    _typeBlock(nil,200);//点击空白处
}



- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}


@end
