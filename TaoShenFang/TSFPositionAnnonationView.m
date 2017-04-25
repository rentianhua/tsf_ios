//
//  TSFPositionAnnonationView.m
//  TaoShenFang
//
//  Created by YXM on 16/10/21.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFPositionAnnonationView.h"

@implementation TSFPositionAnnonationView

- (instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        _imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 27)];
        _imgView.image=[UIImage imageNamed:_imgName];
        [self addSubview:_imgView];
        _imgView.userInteractionEnabled=YES;
        
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
