//
//  TSFSegmentView.m
//  YXM下拉框
//
//  Created by YXM on 16/11/7.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFSegmentView.h"
#import "TSFBtn.h"
#import "TSFAreaView.h"
#import "TSFPriceView.h"
#import "TSFTypeView.h"
#import "TSFMoreView.h"
#import "TSFAreaModel.h"

#define KSCREENW [UIScreen mainScreen].bounds.size.width
#define KSCREENH [UIScreen mainScreen].bounds.size.height
#define BTNW KSCREENW*0.25

@interface TSFSegmentView ()
@property (nonatomic,strong)NSMutableArray * btnArray;
@property (nonatomic,strong)NSArray * viewArray;

@property (nonatomic,strong)TSFBtn * lastBtn;
@property (nonatomic,strong)TSFAreaView * view1;
@property (nonatomic,strong)TSFPriceView * view2;
@property (nonatomic,strong)TSFTypeView * view3;
@property (nonatomic,strong)TSFMoreView * view4;


@property (nonatomic,strong)NSArray * priceArray;
@property (nonatomic,strong)NSArray * typeArray;
@property (nonatomic,strong)NSArray * moreArray;
@property (nonatomic,strong)NSArray * secArray;
@end

@implementation TSFSegmentView

- (TSFAreaView *)view1{
    if (_view1==nil) {
        _view1=[[TSFAreaView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), KSCREENW, KSCREENH-CGRectGetMaxY(self.frame))];
    }
    return _view1;
}

- (TSFPriceView *)view2{
    if (_view2==nil) {
        _view2=[[TSFPriceView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), KSCREENW, KSCREENH-CGRectGetMaxY(self.frame)) array:self.priceArray];
        
    }
    return _view2;
}

- (TSFTypeView *)view3{
    if (_view3==nil) {
        _view3=[[TSFTypeView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), KSCREENW, KSCREENH-CGRectGetMaxY(self.frame)) array:self.typeArray];
        
    }
    return _view3;
}


- (TSFMoreView *)view4{
    if (_view4==nil) {
        _view4=[[TSFMoreView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), KSCREENW, KSCREENH-CGRectGetMaxY(self.frame)-64) array:self.moreArray secArray:self.secArray];
        
    }
    return _view4;
}


- (instancetype)initWithFrame:(CGRect)frame priceArr:(NSArray *)priceArray huxingArr:(NSArray *)huxingArray moreArr:(NSArray *)moreArray moreSecArr:(NSArray *)moreSecArray titleArr:(NSArray *)titleArray{
    if (self=[super initWithFrame:frame]) {
        
        _priceArray=priceArray;
        _typeArray=huxingArray;
        _moreArray=moreArray;
        _secArray=moreSecArray;
        
        _btnArray=[NSMutableArray array];
        _viewArray=[NSArray arrayWithObjects:self.view1,self.view2,self.view3,self.view4, nil];
        
        
        for (int i=0; i<4; i++) {
            CGFloat X=BTNW *i;
            TSFBtn * btn=[[TSFBtn alloc]initWithFrame:CGRectMake(X, 0, BTNW, self.bounds.size.height)];
            [btn setImage:[UIImage imageNamed:@"arrow_down_01"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"arrow_down_02"] forState:UIControlStateSelected];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self addSubview:btn];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=i;
            
            [_btnArray addObject:btn];
            
        }
        
        
    }
    return self;

}


- (void)btnAction:(TSFBtn *)btn{
    
    if (self.view1.superview) {
        [self.view1 removeFromSuperview];
    }
    if (self.view2.superview) {
        [self.view2 removeFromSuperview];
    }
    if (self.view3.superview) {
        [self.view3 removeFromSuperview];
    }
    if (self.view4.superview) {
        [self.view4 removeFromSuperview];
    }
//点击了按钮  就移除所有
    if (_lastBtn!=btn) {
        _lastBtn.selected=NO;
    }
    btn.selected=!btn.selected;
    
    if (btn.selected==YES) {
        
    } else{
        
    }
    
    NSInteger index=[_btnArray indexOfObject:btn];
    
    if (btn.selected==YES) {
        switch (index) {
            case 0:
                [self.superview addSubview:self.view1];
                break;
            case 1:
                [self.superview addSubview:self.view2];
                break;
            case 2:
                [self.superview addSubview:self.view3];
                break;
            case 3:
                [self.superview addSubview:self.view4];
                break;
                
            default:
                break;
        }
        
        
    } else{
        switch (index) {
            case 0:
                [self.view1 removeFromSuperview];
                break;
            case 1:
                [self.view2 removeFromSuperview];
                break;
            case 2:
                [self.view3 removeFromSuperview];
                break;
            case 3:
                [self.view4 removeFromSuperview];
                break;
                
            default:
                break;
        }
 
    }
   
//==================点击区域=================
   __weak typeof(self)weakSelf=self;
    _view1.block=^(id model,NSInteger index){
        
         TSFBtn * btn1=weakSelf.btnArray[0];
        
        if (model!=nil) {
            if ([model isKindOfClass:[TSFAreaModel class]]) {
                
                TSFAreaModel * mod=(TSFAreaModel *)model;
                [btn1 setTitle:mod.name forState:UIControlStateNormal];
                
                weakSelf.btnBlock(mod,index,nil,nil,-1,nil,-1,nil,-1);
                
            } else{
                NSString * str=(NSString *)model;
                 [btn1 setTitle:str forState:UIControlStateNormal];
                 weakSelf.btnBlock(nil,index,str,nil,-1,nil,-1,nil,-1);
            }
        } else{
            
            if (index==100) {
                weakSelf.btnBlock(nil,index,nil,nil,-1,nil,-1,nil,-1);
            }
            
            [btn1 setTitle:@"区域" forState:UIControlStateNormal];
        }
        
        
        [weakSelf.view1 removeFromSuperview];
        
        if (weakSelf.lastBtn==btn) {
            
            weakSelf.lastBtn.selected=NO;
        }
        
    };
    
 //==================点击价格=================
    _view2.priceBlock=^(NSString * string,NSInteger priceindex){//价格
        
        TSFBtn * btn2=weakSelf.btnArray[1];
        
        if (string!=nil) {
            [btn2 setTitle:string forState:UIControlStateNormal];
            weakSelf.btnBlock(nil,index,nil,string,priceindex,nil,-1,nil,-1);
        } else{
            if (priceindex==100) {
                 weakSelf.btnBlock(nil,index,nil,string,priceindex,nil,-1,nil,-1);
            }
            
            [btn2 setTitle:@"价格" forState:UIControlStateNormal];
        }
        
        [weakSelf.view2 removeFromSuperview];
        
        if (weakSelf.lastBtn==btn) {
            weakSelf.lastBtn.selected=NO;
        }
    };
//==================点击房型=================
    _view3.typeBlock=^(NSString * string,NSInteger huxingindex){
        TSFBtn * btn3=weakSelf.btnArray[2];
        if (string!=nil) {
           [btn3 setTitle:string forState:UIControlStateNormal];
            weakSelf.btnBlock(nil,index,nil,nil,-1,string,huxingindex,nil,-1);
        } else{
            if (huxingindex==100) {
                 weakSelf.btnBlock(nil,index,nil,nil,-1,string,huxingindex,nil,-1);
            }
             [btn3 setTitle:@"房型" forState:UIControlStateNormal];
        }
        
        [weakSelf.view3 removeFromSuperview];
        
        if (weakSelf.lastBtn==btn) {
            weakSelf.lastBtn.selected=NO;
        }

    };
 //==================点击更多=================
    _view4.moreSeleblock=^(NSDictionary *selDic){
        TSFBtn * btn4=weakSelf.btnArray[3];
        [btn4 setTitle:@"更多" forState:UIControlStateNormal];
        weakSelf.btnBlockMore(selDic);
//        if (string!=nil) {
//            
//            weakSelf.btnBlock(nil,index,nil,nil,-1,nil,-1,string,index);
//        } else{
//            if (index==-1) {//清空条件
//                weakSelf.btnBlock(nil,index,nil,nil,-1,nil,-1,nil,index);
//            }
//            
//            [btn4 setTitle:@"更多" forState:UIControlStateNormal];
//        }
        
        [weakSelf.view4 removeFromSuperview];
        
        if (weakSelf.lastBtn==btn) {
            weakSelf.lastBtn.selected=NO;
        }

    };
    
    
    _lastBtn=btn;
}


@end
