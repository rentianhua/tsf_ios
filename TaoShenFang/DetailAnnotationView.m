//
//  DetailAnnotationView.m
//  TaoShenFang
//
//  Created by YXM on 16/10/10.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "DetailAnnotationView.h"

@implementation DetailAnnotationView

-(instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        
        _imgView=[[UIImageView alloc]init];
        _imgView.image=[UIImage imageNamed:@"map_001"];
        [self addSubview:_imgView];
        
        UILabel *label=[[UILabel alloc] init];
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor blackColor];
        label.font=[UIFont systemFontOfSize:12];
        [_imgView addSubview:label];
        self.label=label;
    }
    return self;
}

- (void)layoutSubviews{
    
    NSAttributedString * attrStr=[[NSAttributedString alloc]initWithString:_title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    
    _imgView.frame=CGRectMake(0, 0, attrStr.size.width+20, 30);
    self.label.frame=CGRectMake(0, 4.5, attrStr.size.width+20, 21);
}


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    UIView * result=[super hitTest:point withEvent:event];
    
    CGPoint labelpoint = [_label convertPoint:point fromView:self];
    
    if ([_label pointInside:labelpoint withEvent:event] ) {
        
        
        return _label;
    }
    
    return result;
}

@end
