//
//  TSFOtherPickView.m
//  TaoShenFang
//
//  Created by YXM on 16/8/24.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFOtherPickView.h"
#import "OtherHeader.h"

#define PICKW kMainScreenWidth
#define PICKH kMainScreenHeight
#define BtnW 60
#define toolH 40
#define BJH 260

@interface TSFOtherPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    NSArray * _array;
    UIView * _BJView;
    UIPickerView * _pickView;
    NSInteger _selectIndex;
   
}
@property (copy,nonatomic) void(^sele)(NSString *str);

@property (nonatomic,strong)UIView * selfBGView;

@end
@implementation TSFOtherPickView


- (instancetype)initWithFrame:(CGRect)frame selectTitle:(NSString *)title array:(NSArray *)array{
    if (self=[super initWithFrame:frame]) {
        
        
        _selfBGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _selfBGView.backgroundColor=[UIColor clearColor];
        
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
        
        
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,toolH, PICKW, _BJView.frame.size.height-toolH)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = RGB(237, 237, 237,1.0);
        [_BJView addSubview:_pickView];
        
        _selectIndex=0;
        [_pickView selectRow:_selectIndex inComponent:0 animated:YES];
        

    }
    return self;
}

//自定义每个pickview的label
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = [UILabel new];
    pickerLabel.numberOfLines = 0;
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    [pickerLabel setFont:[UIFont boldSystemFontOfSize:12]];
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectIndex=row;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _array[row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _array.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
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
  
    
    if (self.sele) {
        self.sele(_array[_selectIndex]);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
      [blockself.selfBGView removeFromSuperview];
    } completion:^(BOOL finished) {
        
    }];
}



- (void)showView:(void(^)(NSString *str))selectStr{
    self.sele = selectStr;
    
    
    [_selfBGView addSubview:self];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:_selfBGView];
    
    __weak typeof(UIView*)blockview = _BJView;
    __block int blockH = PICKH;
    __block int bjH = BJH;
    
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
