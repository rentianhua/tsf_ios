//
//  TSFPriceView.m
//  YXM下拉框
//
//  Created by YXM on 16/11/7.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFPriceView.h"
#define TABH 300
#define KSCREENW [UIScreen mainScreen].bounds.size.width
#define KSCREENH [UIScreen mainScreen].bounds.size.height
#define TEXTW KSCREENW*0.25
#define TEXTH 30
#define TEXTMargin 15

@interface TSFPriceView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>{
    NSString * lowestPrice;
    NSString * highestPrice;
    UITextField * _text1;
    UITextField * _text2;
    UIView * _BGView;
}

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView * footer;
@property (nonatomic,strong)NSArray * array;


@end

@implementation TSFPriceView

- (UIView *)footer{
    if (_footer==nil) {
        _footer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENH, 80)];
        
        _text1=[[UITextField alloc]initWithFrame:CGRectMake(TEXTMargin, TEXTMargin, TEXTW, TEXTH)];
        _text1.tag=100;
        _text1.delegate=self;
        _text1.placeholder=@"最低价格";
        _text1.keyboardType=UIKeyboardTypeNumberPad;
        _text1.textAlignment=NSTextAlignmentCenter;
        _text1.font=[UIFont systemFontOfSize:14];
        _text1.backgroundColor=[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
        [_footer addSubview:_text1];
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_text1.frame)+3, TEXTMargin+TEXTH*0.5, 5, 1)];
        label.backgroundColor=[UIColor lightGrayColor];
        [_footer addSubview:label];
        _text2=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+3, TEXTMargin, TEXTW, TEXTH)];
        _text2.tag=200;
        _text2.delegate=self;
        _text2.keyboardType=UIKeyboardTypeNumberPad;
        _text2.font=[UIFont systemFontOfSize:14];
        _text2.textAlignment=NSTextAlignmentCenter;
        _text2.backgroundColor=[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
        _text2.placeholder=@"最高价格";
        [_footer addSubview:_text2];
        
        UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_text2.frame)+20, TEXTMargin, KSCREENW-TEXTW*2-40-TEXTMargin-14, TEXTH)];
        button.layer.borderColor=[UIColor colorWithRed:237/255.0 green:27/255.0 blue:36/255.0 alpha:1.0].CGColor;
        button.layer.borderWidth=1.0;
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=3;
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitleColor:[UIColor colorWithRed:237/255.0 green:27/255.0 blue:36/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_footer addSubview:button];
    
        [button addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _footer;
}

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]init];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=self.footer;
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


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.tableView.frame=CGRectMake(0, 0, self.bounds.size.width, TABH);
    
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
        _priceBlock(nil,100);//不限
    } else{
    NSString * string=self.array[indexPath.row];
        self.priceBlock(string,300);//表示其他选中
    }
    
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField.tag==100) {
        lowestPrice=textField.text;
    } else{
        highestPrice=textField.text;
    }
    return YES;
}

- (void)confirmAction:(UIButton *)button{
    
    NSString * string=[NSString stringWithFormat:@"%@-%@",_text1.text,_text2.text];
    self.priceBlock(string,300);//表示其他选中
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer{
    
    _priceBlock(nil,200);//空白处
}


- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

@end
