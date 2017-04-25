//
//  InfoDetailCell.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/23.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "InfoDetailCell.h"
#import "OtherHeader.h"
#import "UIImageView+WebCache.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+TSF.h"
#import "InformationModel.h"
@interface InfoDetailCell()

@property (nonatomic,strong)UIImageView * imgView;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * descrLabel;
@property (nonatomic,strong)UILabel * contentLabel;

@end


@implementation InfoDetailCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        
        UIImageView * imgView=[UIImageView new];
        self.imgView=imgView;
        
        UILabel * titleLabel=[UILabel new];
        titleLabel.font=[UIFont boldSystemFontOfSize:14];
        self.titleLabel=titleLabel;
        
        UILabel * descrLabel=[UILabel new];
        descrLabel.font=[UIFont systemFontOfSize:12];
        self.descrLabel=descrLabel;
        
        UILabel * contentLabel=[UILabel new];
        contentLabel.font=[UIFont systemFontOfSize:12];
        self.contentLabel=contentLabel;
        
        [self.contentView sd_addSubviews:@[imgView,titleLabel,descrLabel,contentLabel]];
        
        
        _imgView.sd_layout
        .leftSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,0)
        .topSpaceToView(self.contentView,0);
        
        
        CGFloat margin=10;
        _titleLabel.sd_layout
        .leftSpaceToView(self.contentView,margin)
        .rightSpaceToView(self.contentView,margin)
        .topSpaceToView(_imgView,margin)
        .autoHeightRatio(0);
        
        _contentLabel.sd_layout
        .leftEqualToView(_titleLabel)
        .rightEqualToView(_titleLabel)
        .topSpaceToView(_titleLabel,margin)
        .autoHeightRatio(0);
        
        _descrLabel.sd_layout
        .leftEqualToView(_contentLabel)
        .rightEqualToView(_contentLabel)
        .topSpaceToView(_contentLabel,0)
        .autoHeightRatio(0);
        
        
        
    }
    return self;
}

- (void)setModel:(InformationModel *)model
{
    _model=model;
    
    if (model.thumb.length>0) {
        _imgView.sd_layout.heightIs(200);
        [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.thumb]]];
        
    } else{
        _imgView.sd_layout.heightIs(0);
    }
    
    _titleLabel.text=model.title;
    [_contentLabel setparagraphText:model.content];
    [_descrLabel setparagraphText:model.descrip];

    [self setupAutoHeightWithBottomView:_descrLabel bottomMargin:10];
   
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
