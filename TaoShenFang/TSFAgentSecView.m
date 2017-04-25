//
//  TSFAgentSecView.m
//  TaoShenFang
//
//  Created by YXM on 16/11/10.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFAgentSecView.h"
#import "TSFAgentAreaView.h"
#import "TSFAgentMultiView.h"
#import "OtherHeader.h"
#import "ZYWHttpEngine.h"
#import "TSFAreaModel.h"
#import <MJExtension.h>
#import "TSFBtn.h"

#define KSCREENW [UIScreen mainScreen].bounds.size.width
#define KSCREENH [UIScreen mainScreen].bounds.size.height
#define BTNW KSCREENW/3

@interface TSFAgentSecView (){
    TSFBtn *_lastBtn;
}

@property (nonatomic,strong)TSFAgentAreaView * view1;
@property (nonatomic,strong)TSFAgentMultiView * view2;
@property (nonatomic,strong)TSFAgentAreaView * view3;

@property (nonatomic,strong)NSArray * array1;
@property (nonatomic,strong)NSArray * array2;
@property (nonatomic,strong)NSArray * array3;

@property (nonatomic,strong)NSMutableArray * btnArray;

@end

@implementation TSFAgentSecView

- (NSMutableArray *)btnArray{
    if (_btnArray==nil) {
        _btnArray=[NSMutableArray array];
    }
    return _btnArray;
}
- (NSArray *)array2{
    if (_array2==nil) {
        _array2=[NSArray arrayWithObjects:@"房东信赖",@"客户热评",@"销售达人",@"带看活跃",@"学区专家",@"海外专家", nil];
    }
    return _array2;
}
- (NSArray *)array3{
    if (_array3==nil) {
        _array3=[NSArray arrayWithObjects:@"成交量从高到低",@"好评率从高到低",@"带看量从高到低", nil];
    }
    return _array3;
}

- (TSFAgentAreaView *)view1{
    if (_view1==nil) {
        _view1=[[TSFAgentAreaView alloc]initWithFrame:CGRectMake(0, 44, KSCREENW, KSCREENH-CGRectGetMaxY(self.frame))];
    }
    return _view1;
}

- (TSFAgentMultiView *)view2{
    if (_view2==nil) {
        _view2=[[TSFAgentMultiView alloc]initWithFrame:CGRectMake(0, 44, KSCREENW, KSCREENH-CGRectGetMaxY(self.frame)) array:self.array2];
    }
    return _view2;
}

- (TSFAgentAreaView *)view3{
    if (_view3==nil) {
        _view3=[[TSFAgentAreaView alloc]initWithFrame:CGRectMake(0, 44, KSCREENW, KSCREENH-CGRectGetMaxY(self.frame)) array:self.array3];
    }
    return _view3;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        NSArray * array=[NSArray arrayWithObjects:@"区域",@"筛选",@"排序", nil];
        for ( int i=0; i<3; i++) {
            TSFBtn * button=[[TSFBtn alloc]initWithFrame:CGRectMake(0+i*BTNW, 0, BTNW, 44)];
            [button setImage:[UIImage imageNamed:@"arrow_down_01"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"arrow_down_02"] forState:UIControlStateSelected];
            [button setTitle:array[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self addSubview:button];
            [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=i;
            
            [self.btnArray addObject:button];
            
        }
        
    }
    return self;
}

- (void)btnAction:(TSFBtn *)btn{
    
    if (self.view1.superview) {
        [self.view1 removeFromSuperview];
        
    } else{
        TSFBtn * btn1=self.btnArray[0];
        btn1.selected=NO;
    }
    if (self.view2.superview) {
        [self.view2 removeFromSuperview];
        
    } else{
        TSFBtn * btn2=self.btnArray[1];
        btn2.selected=NO;
    }
    
    if (self.view3.superview) {
        [self.view3 removeFromSuperview];
        
    }else{
        TSFBtn * btn3=self.btnArray[2];
        btn3.selected=NO;
    }
    
    
    if (_lastBtn!=btn) {
        _lastBtn.selected=NO;
    }
    
    btn.selected=!btn.selected;
    
    UITableView * tableView=(UITableView *)self.superview;
    
    NSInteger index=[self.btnArray indexOfObject:btn];
    if (btn.selected==YES) {
        switch (index) {
            case 0:
                [self.superview.superview addSubview:self.view1];
                tableView.scrollEnabled=NO;
                break;
            case 1:
                [self.superview.superview addSubview:self.view2];
                tableView.scrollEnabled=NO;
                break;
            case 2:
                [self.superview.superview addSubview:self.view3];
                tableView.scrollEnabled=NO;
                break;
                
            default:
                break;
        }
    } else{
        switch (index) {
            case 0:
                [self.view1 removeFromSuperview];
                tableView.scrollEnabled=YES;
                break;
            case 1:
                [self.view2 removeFromSuperview];
                tableView.scrollEnabled=YES;
                break;
            case 2:
                [self.view3 removeFromSuperview];
                tableView.scrollEnabled=YES;
                break;
                
                
            default:
                break;
        }
        
    }
    
    __weak typeof(self)weakSelf=self;
    
    //weakSelf.secBlock(nil,nil,nil);
    
    weakSelf.view1.areaBlock=^(NSString * string){
        
        TSFBtn * btn1=weakSelf.btnArray[0];
        
        if (string==nil) {
            [btn1 setTitle:@"区域" forState:UIControlStateNormal];
        } else{
            [btn1 setTitle:string forState:UIControlStateNormal];
        }
        
        weakSelf.secBlock(1, string,nil,nil);
        [weakSelf.view1 removeFromSuperview];
        
        tableView.scrollEnabled=YES;
    };
    
    
    
    
    weakSelf.view2.multiBlock=^(NSString *string){
        
        weakSelf.secBlock(2, nil,string,nil);
        [weakSelf.view2 removeFromSuperview];
        
        tableView.scrollEnabled=YES;
    };
    
    
    weakSelf.view3.areaBlock=^(NSString * string){
        TSFBtn * btn3=weakSelf.btnArray[2];
        if (string==nil) {
            [btn3 setTitle:@"排序" forState:UIControlStateNormal];
        } else{
            [btn3 setTitle:string forState:UIControlStateNormal];
        }
        
        weakSelf.secBlock(3, nil,nil,string);
        
        [weakSelf.view3 removeFromSuperview];
        
        tableView.scrollEnabled=YES;
    };
    
    
    _lastBtn=btn;
    
}

@end
