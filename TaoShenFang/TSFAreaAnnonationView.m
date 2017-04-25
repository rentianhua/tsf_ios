//
//  TSFAreaAnnonationView.m
//  TaoShenFang
//
//  Created by YXM on 16/10/11.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFAreaAnnonationView.h"

@interface TSFAreaAnnonationView ()

@end

@implementation TSFAreaAnnonationView
- (instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        UIView * contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        contentView.backgroundColor=[UIColor whiteColor];
        contentView.layer.masksToBounds=YES;
        contentView.layer.cornerRadius=30;
        contentView.layer.borderColor=[UIColor grayColor].CGColor;
        contentView.layer.borderWidth=0.8;
        [self addSubview:contentView];
        self.contentView=contentView;
        
        
        contentView.userInteractionEnabled=YES;
        _label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 9, 60, 21)];
        _label1.textColor=[UIColor blackColor];
        _label1.textAlignment=NSTextAlignmentCenter;
        _label1.font=[UIFont boldSystemFontOfSize:12];
        [contentView addSubview:_label1];
        _label1.userInteractionEnabled=YES;
        _label2=[[UILabel alloc]initWithFrame:CGRectMake(0, 9+21, 60, 21)];
        _label2.textColor=[UIColor redColor];
        _label2.textAlignment=NSTextAlignmentCenter;
        _label2.font=[UIFont systemFontOfSize:12];
        [contentView addSubview:_label2];
        _label2.userInteractionEnabled=YES;
        
    }
    return  self;
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    UIView * result=[super hitTest:point withEvent:event];
    
    CGPoint labelpoint = [_contentView convertPoint:point fromView:self];
    
    if ([_contentView pointInside:labelpoint withEvent:event] ) {
        
        
        return _contentView;
    }
    
    return result;
}

@end
