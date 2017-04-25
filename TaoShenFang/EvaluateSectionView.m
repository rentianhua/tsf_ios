//
//  EvaluateSectionView.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/27.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "EvaluateSectionView.h"
#import "OtherHeader.h"
#import "UIView+SDAutoLayout.h"
@interface EvaluateSectionView ()

@property (nonatomic,strong)UILabel * attitudeLabel;
@property (nonatomic,strong)UIView * attitudeView;
@property (nonatomic,strong)UILabel * skillLabel;
@property (nonatomic,strong)UIView * skillView;

@end
@implementation EvaluateSectionView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        NSString * atti=@"服务态度";
        NSAttributedString * attrAtti=[[NSAttributedString alloc]initWithString:atti attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        UILabel * attitudeLabel=[UILabel new];
        attitudeLabel.attributedText=attrAtti;
        [self.contentView addSubview:attitudeLabel];
        self.attitudeLabel=attitudeLabel;
        
        UIView * attitudeView=[UIView new];
        attitudeView.backgroundColor=NavBarColor;
        [self.contentView addSubview:attitudeView];
        self.attitudeView=attitudeView;
        
        
        NSString * skill=@"专业技能";
        NSAttributedString * attrSkill=[[NSAttributedString alloc]initWithString:skill attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        UILabel * skillLabel=[UILabel new];
        skillLabel.attributedText=attrSkill;
        [self.contentView addSubview:skillLabel];
        self.skillLabel=skillLabel;
        
        UIView * skillView=[UIView new];
        skillView.backgroundColor=NavBarColor;
        [self.contentView addSubview:skillView];
        self.skillView=skillView;
        
        CGFloat margin=10;
        attitudeLabel.sd_layout
        .leftSpaceToView(self.contentView,margin)
        .topSpaceToView(self.contentView,margin)
        .widthIs(attrAtti.size.width)
        .heightIs(attrAtti.size.height);
        
        CGFloat smallMargin=3;
        attitudeView.sd_layout
        .leftSpaceToView(attitudeLabel,smallMargin)
        .topEqualToView(attitudeLabel)
        .heightRatioToView(attitudeLabel,1.0)
        .widthIs(80);
        
        skillLabel.sd_layout
        .leftSpaceToView(attitudeView,smallMargin)
        .topEqualToView(attitudeView)
        .widthIs(attrSkill.size.width)
        .heightIs(attrSkill.size.height);
        
        skillView.sd_layout
        .leftSpaceToView(skillLabel,smallMargin)
        .topEqualToView(skillLabel)
        .widthIs(80)
        .heightRatioToView(skillLabel,1.0);
        
        
        
        
        
        
    }
    return self;
}

@end
