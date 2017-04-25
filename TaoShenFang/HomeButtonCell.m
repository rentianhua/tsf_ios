//
//  HomeButtonCell.m
//  TaoShenFangTest
//
//  Created by YXM on 16/7/18.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "HomeButtonCell.h"
#import "OtherHeader.h"
#import "TSFButton.h"

#define ButtonImgWidth kMainScreenWidth*0.09
#define ButtonImgHeight ButtonImgWidth

@interface HomeButtonCell()
/**八个按钮图片数组*/
@property (nonatomic,strong)NSArray * imgArr;

@end
@implementation HomeButtonCell
/**图片数组懒加载*/
- (NSArray *)imgArr
{
    if (_imgArr==nil) {
        NSString * path=[[NSBundle mainBundle]pathForResource:@"imageData" ofType:@"plist"];
        _imgArr=[NSArray arrayWithContentsOfFile:path];
    }
    return _imgArr;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        NSString * buttonTitleLabel=@"购房须知";
        UIFont * buttonTitleFont=[UIFont systemFontOfSize:12];
        if (iPhone5) {
            buttonTitleFont=[UIFont systemFontOfSize:10];
        } else{
            buttonTitleFont=[UIFont systemFontOfSize:12];

        }
        
        
        NSDictionary * attributes=@{NSFontAttributeName:buttonTitleFont};
        CGSize buttonTitleLabelSize=[buttonTitleLabel sizeWithAttributes:attributes];
        
        //button的宽度，至少为imageView的宽度和label宽度之和
        CGFloat buttonWidth=ButtonImgWidth+buttonTitleLabelSize.width;
        //button的高度，至少为imageView的个高度和label高度之和
        CGFloat buttonHeight=ButtonImgHeight+buttonTitleLabelSize.height+10;
        //水平方向上的间隔
        float marginW=(kMainScreenWidth-4*buttonWidth)/(4+1);
        //垂直方向上的间隔
        float marginH=30;
        
        
        for (int i=0; i<self.imgArr.count; i++) {
            int X=i%4;
            int Y=i/4;
            NSDictionary * dict=self.imgArr[i];
            TSFButton * button=[[TSFButton alloc]initWithFrame:CGRectMake(marginW+ X*(buttonWidth+marginW ), 20+ Y*(buttonHeight+marginH), buttonWidth, buttonHeight+5)];
            [button.titleLabel setFont:buttonTitleFont];
            [button setTitleColor:RGB(2, 2, 2, 1.0) forState:UIControlStateNormal];
            [button setTitle:dict[@"text"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:dict[@"img"]]forState:UIControlStateNormal];
            button.tag=100+i;
            button.imageView.contentMode=UIViewContentModeScaleAspectFit;
            [button addTarget:self action:@selector(goNext:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            
        }      
    }
    return self;
}


- (void)goNext:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(homeButtonCellSelectBtnTag:)]) {
        [_delegate homeButtonCellSelectBtnTag:button.tag];
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
