//
//  MainSectionView.m
//  TaoShenFangTest
//
//  Created by sks on 16/6/20.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "MainSectionView.h"
#import "OtherHeader.h"

@interface MainSectionView ()


@end

@implementation MainSectionView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.layer.borderColor=RGB(229, 229, 229, 1.0).CGColor;
        self.contentView.layer.borderWidth=0.1;
        self.contentView.backgroundColor=[UIColor whiteColor];
        
        UILabel * label=[[UILabel alloc]init];
        label.textColor=RGB(3, 3, 3, 1.0);
        label.font=[UIFont systemFontOfSize:18];
        [self addSubview:label];
        self.leftLabel=label;
        
        UIButton * rightButton=[[UIButton alloc]init];
        [self addSubview:rightButton];
        [rightButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        rightButton.hidden=YES;
        self.rightButton=rightButton;
        
        UILabel * rightlabel=[[UILabel alloc]init];
        rightlabel.textColor=[UIColor lightGrayColor];
        rightlabel.font=SmallBtnTitleFont;
        rightlabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:rightlabel];
        self.rightLabel=rightlabel;
        
        /**添加单击手势*/
        UITapGestureRecognizer * singleReconizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTagFrom)];
        singleReconizer.numberOfTapsRequired=1;
        [self addGestureRecognizer:singleReconizer];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIImage * img=[UIImage imageNamed:@"more"];
    CGFloat margin=15;
    CGFloat selfW=self.frame.size.width;
    CGFloat selfH=self.frame.size.height;
    self.rightButton.frame=CGRectMake(selfW-img.size.width-margin, (selfH-img.size.height)*0.5, img.size.width, img.size.height);
    self.leftLabel.frame=CGRectMake(margin, 0, selfW-selfH-margin, selfH);
    
    
}


- (void)handleSingleTagFrom
{
    UITableView * tableView=(UITableView *)self.superview;
    if ([_delegate respondsToSelector:@selector(tableView:sectionDidSelected:)]) {
        [_delegate tableView:tableView sectionDidSelected:_section];
    }
}


@end
