//
//  TSFMultiPickerView.m
//  TaoShenFang
//
//  Created by YXM on 16/8/24.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFMultiPickerView.h"
#import "OtherHeader.h"
#import "YJProgressHUD.h"

#define PICKW kMainScreenWidth
#define PICKH kMainScreenHeight
#define BtnW 60
#define toolH 40
#define BJH 260

@interface TSFMultiPickerView ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSArray * _array;
    UIView * _BJView;
    UITableView * _tableView;
    NSInteger _selectIndex;
    NSMutableArray * _seletArray;
    
}
@property(nonatomic,strong)NSMutableArray*selectIndexPaths; //定义一个可以存被点击后的indexpath的可变数组

@property(nonatomic,strong)NSIndexPath*selectPath;  //存放被点击的哪一行的标志

@property (copy,nonatomic) void(^sele)(NSArray *selectArray);

@property (nonatomic,strong)UIView * selfBGView;

@end

@implementation TSFMultiPickerView


- (void)setHasseleArray:(NSArray *)hasseleArray{
    _hasseleArray=hasseleArray;
    
    
    for (int i=0; i<_array.count; i++) {
        
        NSString * str=_array[i];
        
        for (int j=0; j<_hasseleArray.count; j++) {
            NSString * hasStr=_hasseleArray[j];
            
            if ([str isEqualToString:hasStr]) {
                
                
                NSIndexPath * indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                
                [_selectIndexPaths addObject:indexPath];
                
            }
            
        }
        
        
    }

    
}
- (instancetype)initWithFrame:(CGRect)frame selectTitle:(NSString *)title array:(NSArray *)array;{
    if (self=[super initWithFrame:frame]) {
  
        
        _selfBGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _selfBGView.backgroundColor=[UIColor clearColor];
        
        _selectIndexPaths=[NSMutableArray array];
        
        _seletArray=[NSMutableArray array];
        
        _array=array;
        
        
        
        
        
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        }];
        
        _BJView=[[UIView alloc]initWithFrame:CGRectMake(0, PICKH, PICKW, BJH)];
        [self addSubview:_BJView];
        
        UIView * tool=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, PICKW, toolH)];
        tool.backgroundColor = RGB(237, 236, 234,1.0);
        [_BJView addSubview:tool];
        
        
        /**
         按钮+中间可以显示标题的UILabel
         */
        UIButton *left = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        left.frame = CGRectMake(0, 0, BtnW, toolH);
        [left setTitle:@"取消" forState:UIControlStateNormal];
        [left addTarget:self action:@selector(leftBTN) forControlEvents:UIControlEventTouchUpInside];
        [tool addSubview:left];
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(left.frame.size.width, 0, PICKW-(left.frame.size.width*2), toolH)];
        titleLB.text = title;
        titleLB.textAlignment = NSTextAlignmentCenter;
        [tool addSubview:titleLB];
        
        UIButton *right = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        right.frame = CGRectMake(PICKW-BtnW ,0,BtnW, toolH);
        [right setTitle:@"确定" forState:UIControlStateNormal];
        [right addTarget:self action:@selector(rightBTN) forControlEvents:UIControlEventTouchUpInside];
        [tool addSubview:right];
        
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,toolH, PICKW, _BJView.frame.size.height-toolH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(237, 237, 237,1.0);
        [_BJView addSubview:_tableView];
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    cell.textLabel.text=_array[indexPath.row];
    if([self.selectIndexPaths containsObject:indexPath])//如果这个数组中有当前所点击的下标，那就标记为打钩
        
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        
    }
    
    else
        
    {
        
        cell.accessoryType=UITableViewCellAccessoryNone;
        
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    
    if([self.selectIndexPaths containsObject:indexPath])//在NSMutableArray中用（bool）类型的containsObject判断这个对象是否存在这个数组中（判断的是内存地址）contains：包含
        
    {
        
        //存在以选中的，就执行（为真就执行）把存在的移除
        
        [self.selectIndexPaths removeObject:indexPath];//把这个cell的标记移除
        UITableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType=UITableViewCellAccessoryNone;
        
    }
    
    else//不存在这个标记，那点击后就添加到这个数组中
        
    {
     
        
        
        if (self.areaType==AreaTypeY) {
            if (self.selectIndexPaths.count>2) {
                
                [YJProgressHUD showMessage:@"最多只能选择三个区域" inView:self.superview];
                return;
                
            }
        }
       
        
        UITableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
        [self.selectIndexPaths addObject:indexPath];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        
    }
    
   
}



/**
 *  左边的取消按钮
 */
-(void)leftBTN{

    __weak typeof(self)blockself = self;
    [UIView animateWithDuration:0.3 animations:^{
      [blockself.selfBGView removeFromSuperview];
    } completion:^(BOOL finished) {
        
    }];
    
}

/**
 *  右边的确认按钮
 */
-(void)rightBTN{
    
    __weak typeof(self)blockself = self;
    
    
    for (int i=0; i<_selectIndexPaths.count; i++) {
        NSIndexPath * indexPath=_selectIndexPaths[i];
        [_seletArray addObject:_array[indexPath.row]];
    }
    
    for (NSString * quyu in _seletArray) {
        
    }
    
    if (self.sele) {//点击确定按钮 用block把选中的值传回去
        self.sele(_seletArray);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
       [blockself.selfBGView removeFromSuperview];
    } completion:^(BOOL finished) {
        
    }];
}


- (void)showView:(void(^)(NSArray *selectArray ))selectArray{
    
 
    self.sele = selectArray;
    
    [_selfBGView addSubview:self];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.selfBGView];
    
    __weak typeof(UIView*)blockview = _BJView;
    __block int blockH = PICKH;
    __block int bjH = BJH+64;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf = blockview.frame;
        bjf.origin.y = blockH-bjH;
        blockview.frame = bjf;
    }];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(_BJView.frame, point)) {
        [self leftBTN];
    }
    
}
@end
