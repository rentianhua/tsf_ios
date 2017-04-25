//
//  HandFeatureCell.m
//  TaoShenFang
//
//  Created by YXM on 16/9/10.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "HandFeatureCell.h"
#import <Masonry.h>
#import "HouseModel.h"
#import "OtherHeader.h"
#import <UITableViewCell+HYBMasonryAutoCellHeight.h>
@interface  HandFeatureCell ()

@property(nonatomic,strong)UIView*lineView;

@end

@implementation HandFeatureCell

-(UIView*)lineView{
    
    if(_lineView==nil) {
        
        _lineView= [[UIView alloc]init];
        
        _lineView.backgroundColor= [UIColor lightGrayColor]; //颜色可以自己调
        
        _lineView.alpha=0.3; // 透明度可以自己调
        
    }
    
    return _lineView;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
     self.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        self.title=[UILabel new];
        [self.contentView addSubview:self.title];
        self.title.font=[UIFont systemFontOfSize:15];
        _title.textColor=DESCCOL;
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(21);
            make.right.mas_equalTo(-15);
        }];
        
        self.content=[UILabel new];
        self.content.numberOfLines=0;
        self.content.textColor=TITLECOL;
        [self.contentView addSubview:self.content];
        self.content.font=[UIFont systemFontOfSize:16];
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.equalTo(self.title.mas_bottom).offset(10);
            make.height.mas_greaterThanOrEqualTo(40);
            make.right.mas_equalTo(-15);
            
        }];
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        self.content.preferredMaxLayoutWidth=w-30;
        self.hyb_lastViewInCell=self.content;
        self.hyb_bottomOffsetToCell=10;
        
        
        [self.contentView addSubview:self.lineView];

    }
    return self;
}

- (void)configCellWithString:(NSString *)string{
    if(string == nil || string.length == 0){
        self.content.textAlignment=NSTextAlignmentLeft;
        self.content.text=@"暂无数据";
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    [self.content setAttributedText:attributedString];
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






@end
