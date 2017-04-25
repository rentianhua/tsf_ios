//
//  TSFIssueAnnotationView.m
//  TaoShenFang
//
//  Created by YXM on 16/11/2.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFIssueAnnotationView.h"

@implementation TSFIssueAnnotationView

-(instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        
        _imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 35)];
        [self addSubview:_imgView];
        
    }
    return self;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    UIView * result=[super hitTest:point withEvent:event];
    
    CGPoint labelpoint = [_imgView convertPoint:point fromView:self];
    
    if ([_imgView pointInside:labelpoint withEvent:event] ) {
        
        
        return _imgView;
    }
    
    return result;
}

@end
