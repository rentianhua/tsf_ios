//
//  HouseRecomCell.m
//  TaoShenFangTest
//
//  Created by YXM on 16/8/15.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "HouseRecomCell.h"
#import "OtherHeader.h"
#import "UIView+SDAutoLayout.h"
#import "AlbumButton.h"

@interface HouseRecomCell ()
@property (nonatomic,strong)UIButton * album1;
@property (nonatomic,strong)UIButton * album2;
@property (nonatomic,strong)UILabel * label1;
@property (nonatomic,strong)UILabel * label2;
@property (nonatomic,strong)UILabel * price1;
@property (nonatomic,strong)UILabel * price2;


@end

@implementation HouseRecomCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
     self.selectionStyle=UITableViewCellSelectionStyleNone;
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

       
        UIButton * album1=[UIButton new];
        [album1 setImage:[UIImage imageNamed:@"image01"] forState:UIControlStateNormal];
        [self.contentView addSubview:album1];
        self.album1=album1;
        
        UIButton * album2=[UIButton new];
        [album2 setImage:[UIImage imageNamed:@"image03"] forState:UIControlStateNormal];
        [self.contentView addSubview:album2];
        self.album2=album2;
        
        UILabel * label1=[UILabel new];
        label1.text=@"豪房天际花园";
        label1.font=[UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:label1];
        self.label1=label1;
        
        UILabel * label2=[UILabel new];
        label2.text=@"福永花园";
        label2.font=[UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:label2];
        self.label2=label2;
        
        UILabel * price1=[UILabel new];
        price1.textAlignment=NSTextAlignmentCenter;
        price1.text=@"价格待定";
        price1.backgroundColor=NavBarColor;
        price1.textColor=[UIColor whiteColor];
        price1.font=[UIFont boldSystemFontOfSize:14];
        [album1 addSubview:price1];
        self.price1=price1;
        
        UILabel * price2=[UILabel new];
        price2.text=@"价格待定";
        price2.textAlignment=NSTextAlignmentCenter;
        price2.backgroundColor=NavBarColor;
        price2.textColor=[UIColor whiteColor];
        price2.font=[UIFont boldSystemFontOfSize:14];
        [album2 addSubview:price2];
        self.price2=price2;

        _price1.sd_layout
        .rightSpaceToView(_album1,0)
        .bottomSpaceToView(_album1,0)
        .heightIs(21)
        .widthIs(80);
        
        _price2.sd_layout
        .rightSpaceToView(_album2,0)
        .bottomSpaceToView(_album2,0)
        .heightIs(21)
        .widthIs(80);
        
        
    }
    return self;
   
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat margin=10;
    
    CGFloat titleH=21;
    
    CGFloat albumW=(self.contentView.bounds.size.width-margin*3)*0.5;
    CGFloat albumH=self.contentView.bounds.size.height-margin*3-21;
    
    _album1.sd_layout
    .leftSpaceToView(self.contentView,margin)
    .topSpaceToView(self.contentView,margin)
    .heightIs(albumH)
    .widthIs(albumW);
    
    _album2.sd_layout
    .leftSpaceToView(_album1,margin)
    .topSpaceToView(self.contentView,margin)
    .heightIs(albumH)
    .widthIs(albumW);
    
    _label1.sd_layout
    .leftEqualToView(_album1)
    .topSpaceToView(_album1,margin)
    .heightIs(titleH)
    .widthRatioToView(_album1,1.0);
    
    _label2.sd_layout
    .leftEqualToView(_album2)
    .topSpaceToView(_album2,margin)
    .heightIs(titleH)
    .widthRatioToView(_album2,1.0);
    
  
    
    
    
    
}

- (void)setRecommArray:(NSArray *)recommArray{
    _recommArray=recommArray;
    
    UIScrollView * scrollView=[[UIScrollView alloc]initWithFrame:self.contentView.frame];
    [self.contentView addSubview:scrollView];
    
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
