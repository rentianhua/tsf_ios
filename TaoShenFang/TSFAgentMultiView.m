//
//  TSFAgentMultiView.m
//  TaoShenFang
//
//  Created by YXM on 16/11/10.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFAgentMultiView.h"
#define KSCREENW [UIScreen mainScreen].bounds.size.width
#define TABH 300

@interface TSFAgentMultiView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    UIView * _BGView;
}

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * array;

@property (nonatomic,strong)NSMutableArray * filterRecordArray;

@property (nonatomic,strong)UIView * footerView;


@property (nonatomic,strong)NSMutableArray * selectArray;

@end


@implementation TSFAgentMultiView

- (NSMutableArray *)selectArray{
    if (_selectArray==nil) {
        _selectArray=[NSMutableArray array];
    }
    return _selectArray;
}
- (UIView *)footerView{
    if (_footerView==nil) {
        
        _footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENW, 120)];
        
        UIButton * cleanBtn=[[UIButton alloc]initWithFrame:CGRectMake(30, 10, KSCREENW-60, 40)];
        [cleanBtn setTitle:@"清空条件" forState:UIControlStateNormal];
        [cleanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_footerView addSubview:cleanBtn];
        [cleanBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [cleanBtn addTarget:self action:@selector(cleanAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(cleanBtn.frame)+10, KSCREENW-60, 40)];
        button.backgroundColor=[UIColor redColor];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_footerView addSubview:button];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (NSMutableArray *)filterRecordArray{
    if (_filterRecordArray==nil) {
        _filterRecordArray=[NSMutableArray array];
    }
    return _filterRecordArray;
}
- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]init];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=self.footerView;
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array{
    if (self=[super initWithFrame:frame]) {
        
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

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame=CGRectMake(0, 0, KSCREENW, TABH);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.text=_array[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    BOOL isIndexInArray =[self.filterRecordArray containsObject:indexPath];
    if (isIndexInArray ==YES) {
        cell.textLabel.textColor=[UIColor redColor];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    } else{
        cell.textLabel.textColor=[UIColor blackColor];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL isIndexInArray =[self.filterRecordArray containsObject:indexPath];
    if (isIndexInArray==NO) {
        UITableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor=[UIColor redColor];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        
        [self.filterRecordArray addObject:indexPath];
        NSString * string=_array[indexPath.row];
        [self.selectArray addObject:string];
        
    } else{
        UITableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor=[UIColor blackColor];
        cell.accessoryType=UITableViewCellAccessoryNone;
        
        NSInteger deleteindex=[self.filterRecordArray indexOfObject:indexPath];
        [self.filterRecordArray removeObjectAtIndex:deleteindex];
        
        [self.selectArray removeObjectAtIndex:deleteindex];
    }
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
    //weakSelf.multiBlock(nil);
    
    [self removeFromSuperview];
}

//点击确定按钮
- (void)confirmAction:(UIButton *)button{
  
    
    NSString * string=[self.selectArray componentsJoinedByString:@","];
    
    
    __weak typeof(self)weakSelf=self;
    weakSelf.multiBlock(string);
    
    [self removeFromSuperview];
}

- (void)cleanAction:(UIButton *)button{
    [self.filterRecordArray removeAllObjects];
    [self.selectArray removeAllObjects];
    
    [self.tableView reloadData];
    
}

@end
