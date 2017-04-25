//
//  LouPanJIeShuoCell.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/25.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "LouPanJIeShuoCell.h"
#import "OtherHeader.h"
#import "UIView+SDAutoLayout.h"
@interface LouPanJIeShuoCell()


@property (nonatomic,strong)UILabel * biaoqian;
@property (nonatomic,strong)UILabel * title;
@property (nonatomic,strong)UILabel * content;
@property (nonatomic,strong)UILabel * time;

@end

@implementation LouPanJIeShuoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel * biaoqian=[UILabel new];
        biaoqian.backgroundColor=NavBarColor;
        biaoqian.textColor=[UIColor whiteColor];
        biaoqian.textAlignment=NSTextAlignmentCenter;
        biaoqian.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:biaoqian];
        self.biaoqian=biaoqian;
        NSString * str=@"价格";
        biaoqian.text=str;
        CGSize strSize=[str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        
        
        
        
        UILabel * title=[UILabel new];
        title.numberOfLines=2;
        title.font=[UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:title];
        self.title=title;
        
        title.text=@"东莞万瑞中心5500元/平米起，仅售商品房写字楼价格三分之一";
        
        UILabel * content=[UILabel new];
        content.numberOfLines=2;
        content.textColor=[UIColor grayColor];
        content.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:content];
        self.content=content;
        
        content.text=@"甲级门户品质，90-1400平米灵动空间，但是价格在同等商品房写字楼价格的三分之一，超高性价比";
        
        /**东莞万瑞中心5500元/平米起，仅售商品房写字楼价格三分之一
         甲级门户品质，90-1400平米灵动空间，但是价格在同等商品房写字楼价格的三分之一，超高性价比
         2016-08-12 13-08-38*/
        
        
        UILabel * time=[UILabel new];
        time.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:time];
        self.time=time;
        NSString * timeStr=@"2016-08-12 13:08:38";
        time.text=timeStr;
        CGSize timestrSize=[timeStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        
        CGFloat margin=10;
        biaoqian.sd_layout
        .leftSpaceToView(self.contentView,margin)
        .topSpaceToView(self.contentView,margin)
        .widthIs(strSize.width+15)
        .heightIs(strSize.height+5);
        
        time.sd_layout
        .topEqualToView(biaoqian)
        .rightSpaceToView(self.contentView,margin)
        .widthIs(timestrSize.width)
        .heightIs(21);
        
        title.sd_layout
        .leftEqualToView(biaoqian)
        .topSpaceToView(biaoqian,margin)
        .rightSpaceToView(self.contentView,margin)
        .heightIs(42);
        
        content.sd_layout
        .leftEqualToView(title)
        .topSpaceToView(title,margin)
        .rightEqualToView(title)
        .heightIs(42);
        
        //[self.contentView setupAutoHeightWithBottomView:content bottomMargin:margin];
        
    }
    return self;
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
