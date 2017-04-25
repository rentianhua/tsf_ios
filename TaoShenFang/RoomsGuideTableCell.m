//
//  RoomsGuideTableCell.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/15.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "RoomsGuideTableCell.h"
#import "UIView+SDAutoLayout.h"
#import "OtherHeader.h"
#import "UIImageView+WebCache.h"
#import "InformationModel.h"
@interface RoomsGuideTableCell ()

@property (nonatomic,strong)UIImageView * imgView;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * descrLabel;
@property (nonatomic,strong)UILabel * smallLabel;

@end


@implementation RoomsGuideTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UIImageView * imageView=[UIImageView new];
        imageView.image=[UIImage imageNamed:@"test01"];
        self.imgView=imageView;
        
        UILabel * titlelabel=[UILabel new];
        titlelabel.numberOfLines=0;
        titlelabel.textColor=RGB(51, 51, 51, 1.0);
        titlelabel.font=[UIFont systemFontOfSize:16];
        self.titleLabel=titlelabel;
        
        UILabel * descrLabel=[UILabel new];
        descrLabel.numberOfLines=0;
        descrLabel.font=[UIFont systemFontOfSize:13];
        descrLabel.textColor=RGB(153, 153, 153, 1.0);
        self.descrLabel=descrLabel;
        
        UILabel * smallLabel=[UILabel new];
        smallLabel.backgroundColor=RGB(255, 239, 227, 1.0);
        smallLabel.textColor=RGB(241, 106, 11, 1.0);
        smallLabel.text=@"热点";
        smallLabel.textAlignment=NSTextAlignmentCenter;
        smallLabel.font=[UIFont systemFontOfSize:12];
        self.smallLabel=smallLabel;
        
        [self.contentView sd_addSubviews:@[imageView,titlelabel,descrLabel,smallLabel]];
        
        
 
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


- (void)setModel:(InformationModel *)model
{
    self.titleLabel.text=model.data.title;
    self.descrLabel.text=model.data.descrip;
    NSString * urlStr=[NSString stringWithFormat:@"%@%@",ImageURL,model.data.thumb];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"card_default"]];
    
    CGFloat margin=15;
    CGFloat margin1=10;
    
    _imgView.sd_layout
    .rightSpaceToView(self.contentView,margin)
    .topSpaceToView(self.contentView,margin1)
    .widthRatioToView(self.contentView,0.2)
    .heightEqualToWidth();
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView,margin)
    .topSpaceToView(self.contentView,margin1)
    .rightSpaceToView(_imgView,margin1)
    .heightIs(42);
    
    _descrLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel,5)
    .heightIs(42);
    
    _smallLabel.sd_layout
    .leftEqualToView(_descrLabel)
    .topSpaceToView(_descrLabel,5)
    .widthIs(30)
    .heightIs(15);

    
    [self setupAutoHeightWithBottomViewsArray:@[_smallLabel,_imgView] bottomMargin:margin1];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
