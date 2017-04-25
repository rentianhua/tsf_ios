//
//  TSFHandDetailTitleCell.m
//  TaoShenFang
//
//  Created by YXM on 16/11/14.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFHandDetailTitleCell.h"
#import <Masonry.h>
#import <UITableViewCell+HYBMasonryAutoCellHeight.h>

@interface TSFHandDetailTitleCell ()

@property (nonatomic,strong)UILabel * titleLab;
@property(nonatomic,strong)UIView*lineView;


@end

@implementation TSFHandDetailTitleCell

-(UIView*)lineView{
    
    if(_lineView==nil) {
        
        _lineView= [[UIView alloc]init];
        
        _lineView.backgroundColor= [UIColor lightGrayColor]; //颜色可以自己调
        
        _lineView.alpha=0.3; // 透明度可以自己调
        
    }
    
    return _lineView;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        _titleLab=[[UILabel alloc]init];
        _titleLab.font=[UIFont boldSystemFontOfSize:20];
        [self.contentView addSubview:_titleLab];
        _titleLab.numberOfLines=0;
        
        __weak typeof(self)weakSelf=self;
        
        [weakSelf.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(15);
            make.height.mas_greaterThanOrEqualTo(21);
        }];
        
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        self.titleLab.preferredMaxLayoutWidth=w-30;
        self.hyb_lastViewInCell=self.titleLab;
        self.hyb_bottomOffsetToCell=15;
        
        [self.contentView addSubview:self.lineView];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //设置分割线的frame
    
    CGFloat lineX =self.textLabel.frame.origin.x;
    
    CGFloat lineH =1;
    
    CGFloat lineY =CGRectGetHeight(self.frame) - lineH;
    
    CGFloat lineW =CGRectGetWidth(self.frame) - lineX;
    
    self.lineView.frame=CGRectMake(lineX,lineY, lineW, lineH);
    
}

- (void)setHidenLine:(BOOL)hidenLine{
    
    _hidenLine= hidenLine;
    
    self.lineView.hidden= hidenLine;
    
}


- (void)configCellWithString:(NSString *)title{
    _titleLab.text=title;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
