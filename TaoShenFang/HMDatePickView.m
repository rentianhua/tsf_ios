//
//  HMpickViewController.m
//  CustomDatePickView
//
//  Created by WXYT-iOS2 on 16/8/13.
//  Copyright © 2016年 WXYT-iOS2. All rights reserved.
//

#import "HMDatePickView.h"
#import "OtherHeader.h"
#define PICKW kMainScreenWidth
#define PICKH kMainScreenHeight
#define BtnW 60
#define toolH 40
#define BJH 216

@interface HMDatePickView()
{
    NSString *_dateStr;
    UIView * _BJView;
    UIDatePicker * _dateView;

    
}
@property(strong, nonatomic) UIDatePicker *hmDatePicker;

@property (nonatomic,copy)void (^selectBlock)(NSString * str1);

@end

@implementation HMDatePickView


- (instancetype)initWithFrame:(CGRect)frame selectTitle:(NSString *)title {
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
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
        
        _dateView = [[UIDatePicker alloc] init ];
        _dateView.frame=CGRectMake(0,toolH, PICKW, _BJView.frame.size.height-toolH);
        _dateView.backgroundColor = RGB(237, 237, 237,1.0);
        [_BJView addSubview:_dateView];
        
        _dateView.datePickerMode = UIDatePickerModeDate;
        NSDate *currentDate = [NSDate date];
        
        //设置默认日期
        if (!self.date) {
            self.date = currentDate;
        }
        _dateView.date = self.date;
        
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        
        _dateStr = [formater stringFromDate:self.date];
        
        NSString *tempStr = [formater stringFromDate:self.date];
        NSArray *dateArray = [tempStr componentsSeparatedByString:@"-"];
        
        //设置日期选择器最大可选日期
        if (self.maxYear) {
            NSInteger maxYear = [dateArray[0] integerValue] - self.maxYear;
            NSString *maxStr = [NSString stringWithFormat:@"%ld-%@-%@",maxYear,dateArray[1],dateArray[2]];
            NSDate *maxDate = [formater dateFromString:maxStr];
            _dateView.maximumDate = maxDate;
        }
        
        //设置日期选择器最小可选日期
        if (self.minYear) {
            
            NSInteger minYear = [dateArray[0] integerValue] - self.minYear;
            NSString *minStr = [NSString stringWithFormat:@"%ld-%@-%@",minYear,dateArray[1],dateArray[2]];
            NSDate* minDate = [formater dateFromString:minStr];
            _dateView.minimumDate = minDate;
        }
        
        
        [_dateView addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventValueChanged];
        
        
    }
    return self;
}

/**
 *  左边的取消按钮
 */
-(void)leftBTN{
    __weak typeof (UIView *)blockView=_BJView;
    __weak typeof (self)blockSelf=self;
    __block int blockH =PICKH;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf=_BJView.frame;
        bjf.origin.y=blockH;
        blockView.frame=bjf;
        blockSelf.alpha=0.1;
    } completion:^(BOOL finished) {
        [blockSelf removeFromSuperview];
    }];
    
}

/**
 *  右边的确认按钮
 */
-(void)rightBTN{
    __weak typeof (UIView *)blockView=_BJView;
    __weak typeof (self)blockSelf=self;
    __block int blockH=PICKH;
    
    if (self.selectBlock) {
        self.selectBlock(_dateStr);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf=blockView.frame;
        bjf.origin.y=blockH;
        blockView.frame=bjf;
        blockSelf.alpha=0.1;
    } completion:^(BOOL finished) {
        [blockSelf removeFromSuperview];
    }];
    
    
}

- (void)showView:(void(^)(NSString *str1))selectStr{
    
    self.selectBlock=selectStr;
    
    [[[UIApplication sharedApplication] keyWindow ] addSubview:self];
    
    __weak typeof (UIView *)blockView =_BJView;
    __block int blockH=PICKH;
    __block int bjH=BJH;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjf=blockView.frame;
        bjf.origin.y=blockH-bjH;
        blockView.frame=bjf;
        
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point=[[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(_BJView.frame, point)) {
        [self leftBTN];
    }
}

#pragma mark -- 时间选择器日期改变
-(void)selectDate:(id)sender {
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    _dateStr =[outputFormatter stringFromDate:_dateView.date];
    
}





/////////////////////////////////////////////////////
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor colorWithWhite:0.227 alpha:0.5];
////        [self createPickerView];
//    }
//    return self;
//}


#pragma mark -- 选择器
- (void)configuration {
    //时间选择器
    UIView *dateBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 200, [UIScreen mainScreen].bounds.size.width, 200)];
    dateBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:dateBgView];
    
    //确定按钮
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(dateBgView.bounds.size.width - 50, 0, 40, 30);
    commitBtn.tag = 1;
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(pressentPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [dateBgView addSubview:commitBtn];
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 0, 40, 30);
    cancelBtn.tag = 1;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(pressentPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [dateBgView addSubview:cancelBtn];
    
    UIDatePicker *datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 38, [UIScreen mainScreen].bounds.size.width, 162)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSDate *currentDate = [NSDate date];
    
    if (self.fontColor) {
        [commitBtn setTitleColor:self.fontColor forState:UIControlStateNormal];
        [cancelBtn setTitleColor:self.fontColor forState:UIControlStateNormal];
    }
    
    //设置默认日期
    if (!self.date) {
        self.date = currentDate;
    }
    datePicker.date = self.date;
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    
    _dateStr = [formater stringFromDate:self.date];
    
    NSString *tempStr = [formater stringFromDate:self.date];
    NSArray *dateArray = [tempStr componentsSeparatedByString:@"-"];
    
    //设置日期选择器最大可选日期
    if (self.maxYear) {
        NSInteger maxYear = [dateArray[0] integerValue] - self.maxYear;
        NSString *maxStr = [NSString stringWithFormat:@"%ld-%@-%@",maxYear,dateArray[1],dateArray[2]];
        NSDate *maxDate = [formater dateFromString:maxStr];
        datePicker.maximumDate = maxDate;
    }
    
    //设置日期选择器最小可选日期
    if (self.minYear) {
        
        NSInteger minYear = [dateArray[0] integerValue] - self.minYear;
        NSString *minStr = [NSString stringWithFormat:@"%ld-%@-%@",minYear,dateArray[1],dateArray[2]];
        NSDate* minDate = [formater dateFromString:minStr];
        datePicker.minimumDate = minDate;
    }
    
    [dateBgView addSubview: datePicker];
    self.hmDatePicker = datePicker;
    
    [self.hmDatePicker addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark -- 时间选择器确定/取消
- (void)pressentPickerView:(UIButton *)button {
    //确定
    if (button.tag == 1) {
        //确定
        self.completeBlock(_dateStr);
    }
    [self removeFromSuperview];
}


@end
