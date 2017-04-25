//
//  TSFNewSegmentView.m
//  TaoShenFang
//
//  Created by YXM on 16/11/9.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFNewSegmentView.h"
#import "TSFNewAreaView.h"
#import "TSFPriceView.h"
#import "TSFTypeView.h"
#import "TSFMoreView.h"
#import "TSFBtn.h"
#import "TSFAreaModel.h"

#define KSCREENW [UIScreen mainScreen].bounds.size.width
#define KSCREENH [UIScreen mainScreen].bounds.size.height
#define BTNW KSCREENW*0.25

@interface TSFNewSegmentView ()

@property (nonatomic,strong)NSMutableArray * btnArray;
@property (nonatomic,strong)TSFBtn * lastBtn;
@property (nonatomic,strong)TSFNewAreaView * view1;
@property (nonatomic,strong)TSFPriceView * view2;
@property (nonatomic,strong)TSFTypeView * view3;
@property (nonatomic,strong)TSFMoreView * view4;

@property (nonatomic,strong)NSArray * priceArray;
@property (nonatomic,strong)NSArray * typeArray;
@property (nonatomic,strong)NSArray * moreArray;
@property (nonatomic,strong)NSArray * titleArray;

@property (nonatomic,strong)NSArray * secArray;


@end


@implementation TSFNewSegmentView


- (TSFNewAreaView *)view1{
    if (_view1==nil) {
        _view1=[[TSFNewAreaView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), KSCREENW, KSCREENH-CGRectGetMaxY(self.frame)) ];
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


- (instancetype)initWithFrame:(CGRect)frame priceArr:(NSArray *)priceArray typeArr:(NSArray *)typeArray moreArr:(NSArray *)moreArray moreSecArr:(NSArray *)moreSecArray titleArr:(NSArray *)titleArray {
    if (self=[super initWithFrame:frame]) {
        
        _btnArray=[NSMutableArray array];
        
        _priceArray=priceArray;
        _typeArray=typeArray;
        _moreArray=moreArray;
        _secArray=moreSecArray;
        _titleArray=titleArray;
        
        
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
    
    if (_lastBtn!=btn) {//如果上次点了区域弹出了区域框   我再次点击区域就移除区域
        _lastBtn.selected=NO;
    }
    
    btn.selected=!btn.selected;
    
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
        
    }else{
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
    
    __weak typeof(self)weakSelf=self;
    
    
    
    _view1.areaBlock=^(TSFAreaModel * model,NSInteger index){
        TSFBtn * btn1=weakSelf.btnArray[0];
        if (index==100) {//不限
            if (model!=nil) {
                [btn1 setTitle:model.name forState:UIControlStateNormal];
            } else{
                 [btn1 setTitle:weakSelf.titleArray[0] forState:UIControlStateNormal];
            }
          
            
            weakSelf.btnBlock(model,index,nil,-1,nil,-1,nil,-1);
        } else if (index==200){
            
        }
        
        else{
            weakSelf.btnBlock(model,index,nil,-1,nil,-1,nil,-1);
            [btn1 setTitle:model.name forState:UIControlStateNormal];
        }
       
        [weakSelf.view1 removeFromSuperview];
        
        if (weakSelf.lastBtn==btn) {
            weakSelf.lastBtn.selected=NO;
        }
        
    };
    
    //==================价格======================
    _view2.priceBlock=^(NSString * string,NSInteger priceindex){
        
        TSFBtn * btn2=weakSelf.btnArray[1];
        if (string!=nil) {
            [btn2 setTitle:string forState:UIControlStateNormal];
            weakSelf.btnBlock(nil,-1,string,priceindex,nil,-1,nil,-1);
            
        } else{
            if (priceindex==100) {//不限
               weakSelf.btnBlock(nil,-1,nil,priceindex,nil,-1,nil,-1);
            }
            
            [btn2 setTitle:weakSelf.titleArray[1] forState:UIControlStateNormal];
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
            weakSelf.btnBlock(nil,-1,nil,-1,string,huxingindex,nil,-1);
 
        } else{
            if (huxingindex==100) {//不限
                weakSelf.btnBlock(nil,-1,nil,-1,nil,huxingindex,nil,-1);
            }
            
            [btn3 setTitle:weakSelf.titleArray[2] forState:UIControlStateNormal];
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
//            weakSelf.btnBlock(nil,-1,nil,-1,nil,-1,string,index);
//        } else{
//            if (index==-1) {//清空
//                weakSelf.btnBlock(nil,-1,nil,-1,nil,-1,nil,index);
//            }
//            [btn4 setTitle:weakSelf.titleArray[3] forState:UIControlStateNormal];
//        }
        
        
        [weakSelf.view4 removeFromSuperview];
        
        if (weakSelf.lastBtn==btn) {
            weakSelf.lastBtn.selected=NO;
        }

    };
    
    _lastBtn=btn;

}



@end
