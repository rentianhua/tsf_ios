//
//  TSFPickerView.m
//  TaoShenFang
//
//  Created by YXM on 16/8/24.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFPickerView.h"
#import "OtherHeader.h"
#define PICKW kMainScreenWidth
#define PICKH kMainScreenHeight
#define BtnW 60
#define toolH 40
#define BJH 260
@interface TSFPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>{

    NSArray * _array1;
    NSArray * _array2;
    NSArray * _array3;
    UIView * _BJView;
    UIPickerView * _pickView;
    NSInteger _firstIndex;
    NSInteger _secondIndex;
    NSInteger _thridIndex;
}
@property (copy,nonatomic) void(^sele)(NSString *str1,NSString *str2,NSString *str3);

@property (nonatomic,strong)UIView * selfBGView;

@end

@implementation TSFPickerView

- (instancetype)initWithFrame:(CGRect)frame selectTitle:(NSString *)title allArray:(NSArray *)allArray{
    if (self=[super initWithFrame:frame]) {
        
        _array1=allArray[0];
        _array2=allArray[1];
        _array3=allArray[2];
        
        _selfBGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _selfBGView.backgroundColor=[UIColor clearColor];
        
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
        

        _firstIndex=0;
        _secondIndex=0;
        _thridIndex=0;
        [_pickView selectRow:_firstIndex inComponent:0 animated:YES];
        [_pickView selectRow:_secondIndex inComponent:1 animated:YES];
        [_pickView selectRow:_thridIndex inComponent:2 animated:YES];
   
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
    if (component==0) {
        _firstIndex=row;
        
    } else if (component==1){
        _secondIndex=row;
    } else{
        _thridIndex=row;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0 ) {
        return _array1[row];
    } else if (component==1){
        return _array2[row];
    } else if (component==2){
        return _array3[row];
    }
    return nil;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return _array1.count;
    }else if (component == 1){
        return _array2.count;
    }else if (component == 2){
        return _array3.count;
    }
    
    return 0;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
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
        self.sele(_array1[_firstIndex],_array2[_secondIndex],_array3[_thridIndex]);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
     [blockself.selfBGView removeFromSuperview];
    } completion:^(BOOL finished) {
        
    }];
}




- (void)showView:(void(^)(NSString *str1,NSString *str2,NSString *str3 ))selectStr{
    self.sele = selectStr;
    
    
    [_selfBGView addSubview:self];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.selfBGView];
    
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
