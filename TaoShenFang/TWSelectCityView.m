//
//  TWSelectCityView.m
//  TWCitySelectView
//
//  Created by TreeWriteMac on 16/6/30.
//  Copyright © 2016年 Raykin. All rights reserved.
//

#import "TWSelectCityView.h"
#import "ZYWHttpEngine.h"
#import "OtherHeader.h"
#import "AreaModel.h"
#import <MJExtension/MJExtension.h>
#import "YJProgressHUD.h"
#import "TSFAreaModel.h"

#define TWW kMainScreenWidth
#define TWH kMainScreenHeight

#define TWRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define BtnW 60
#define toolH 40
#define BJH 260

@interface TWSelectCityView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    UIView *_BJView;                //一个view，工具栏和pickview都是添加到上面，便于管理
    NSArray *_ProvinceAry;          //只装省份的数组
    NSArray *_DistrictAry;          //只装区的数组（还有县）
    UIPickerView *_pickView;        //最主要的选择器
    
    NSInteger _proIndex;            //用于记录选中哪个省的索引
    NSInteger _cityIndex;           //用于记录选中哪个市的索引
    NSInteger _districtIndex;      //用于记录选中哪个区的索引
    
    UIView * _selfBGView;
}

@property (copy, nonatomic) void (^sele)(TSFAreaModel *proviceModel,TSFAreaModel *cityModel,TSFAreaModel *disModel);

@property (nonatomic,strong)AreaModel * promodel;



@end

@implementation TWSelectCityView

- (void)setAreaArray:(NSArray *)areaArray{
    
    _areaArray=areaArray;
    
    TSFAreaModel * model1=_areaArray[0];
    _DistrictAry=model1.area;
    [_pickView selectRow:0 inComponent:0 animated:YES];
    [_pickView reloadComponent:0];
    [_pickView reloadComponent:1];
    [_pickView selectRow:0 inComponent:1 animated:YES];
    [_pickView reloadComponent:2];
}

-(instancetype)initWithTWFrame:(CGRect)rect TWselectCityTitle:(NSString *)title{
    if (self = [super initWithFrame:rect]) {
       
    
        _selfBGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _selfBGView.backgroundColor=[UIColor clearColor];
        
        __weak typeof(self)weakSelf=self;
        TSFAreaModel * model=[[TSFAreaModel alloc]init];
        model.name=@"深圳";
        model.ID=@1;
        model.pid=@(-1);
        
        _ProvinceAry=@[model];
   

        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        }];
        
        
        
        //显示pickview和按钮最底下的view
        _BJView = [[UIView alloc] initWithFrame:CGRectMake(0, TWH, TWW, BJH)];
        [self addSubview:_BJView];
        
        UIView *tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, TWW, toolH)];
        tool.backgroundColor = TWRGB(237, 236, 234);
        [_BJView addSubview:tool];
        
        /**
         按钮+中间可以显示标题的UILabel
         */
        UIButton *left = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        left.frame = CGRectMake(0, 0, BtnW, toolH);
        [left setTitle:@"取消" forState:UIControlStateNormal];
        [left addTarget:self action:@selector(leftBTN) forControlEvents:UIControlEventTouchUpInside];
        [tool addSubview:left];
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(left.frame.size.width, 0, TWW-(left.frame.size.width*2), toolH)];
        titleLB.text = title;
        titleLB.textAlignment = NSTextAlignmentCenter;
        [tool addSubview:titleLB];
        
        UIButton *right = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        right.frame = CGRectMake(TWW-BtnW ,0,BtnW, toolH);
        [right setTitle:@"确定" forState:UIControlStateNormal];
        [right addTarget:self action:@selector(rightBTN) forControlEvents:UIControlEventTouchUpInside];
        [tool addSubview:right];


        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,toolH, TWW, _BJView.frame.size.height-toolH)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor =TWRGB(237, 237, 237);
        [_BJView addSubview:_pickView];

    }
    return self;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return kMainScreenWidth/3;
}

//自定义每个pickview的label
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    
    UILabel* pickerLabel = [[UILabel alloc]init];
    pickerLabel.frame=view.bounds;
    pickerLabel.numberOfLines = 0;
    pickerLabel.textColor=[UIColor blackColor];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    [pickerLabel setFont:[UIFont boldSystemFontOfSize:12]];
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    
    return pickerLabel;
}

/**
 *  下面几个委托方法相信大家都知道，我就不一一说了😄😄😄😄😄😄
 *
 */

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        _proIndex = row;
        _cityIndex = 0;
        _districtIndex = 0;
        
        [_pickView reloadComponent:2];
    }
    if (component == 1) {
        _cityIndex = row;
        _districtIndex = 0;
        TSFAreaModel * pro=_areaArray[row];
        _DistrictAry=pro.area;
        [_pickView reloadComponent:2];
    }
    
    if (component == 2) {
        _districtIndex = row;
    }
    
    
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        TSFAreaModel * model=[_ProvinceAry objectAtIndex:row];
        return model.name;
    }else if (component == 1){
        TSFAreaModel * citymodel=[_areaArray objectAtIndex:row];
        return citymodel.name;
    }else if (component == 2){
        TSFAreaModel * dismodel=[_DistrictAry objectAtIndex:row];
        return dismodel.name;
    }
    
    return nil;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return _ProvinceAry.count;
    }else if (component == 1){
        return _areaArray.count;
    }else if (component == 2){
        return _DistrictAry.count;
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
   
    
    [UIView animateWithDuration:0.3 animations:^{
        [_selfBGView removeFromSuperview];
    } completion:^(BOOL finished) {
        
    }];
    
}

/**
 *  右边的确认按钮
 */
-(void)rightBTN{

    
    if (self.sele) {
        
        TSFAreaModel * promodel=_ProvinceAry[_proIndex];
        
        TSFAreaModel * citymodel=_areaArray[_cityIndex];
        
        TSFAreaModel * dismodel=_DistrictAry[_districtIndex];
        
        self.sele(promodel,citymodel,dismodel);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [_selfBGView removeFromSuperview];
    } completion:^(BOOL finished) {
        
    }];
}


-(void)showCityView:(void(^)(TSFAreaModel *proviceModel,TSFAreaModel *cityModel,TSFAreaModel *disModel))selectStr{
    self.sele = selectStr;
    
    
    
    [_selfBGView addSubview:self];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:_selfBGView];
    
    __weak typeof(UIView*)blockview = _BJView;
    __block int blockH = TWH;
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
