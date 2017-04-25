//
//  HouseAlbemCell.m
//  TaoShenFangTest
//
//  Created by YXM on 16/8/15.
//  Copyright © 2016年 qkq. All rights reserved.
//

#import "HouseAlbemCell.h"
#import "UIView+SDAutoLayout.h"
#import "AlbumButton.h"

@interface HouseAlbemCell ()
@property (nonatomic,strong)NSArray * imageArray;

@end

@implementation HouseAlbemCell
- (NSArray *)imageArray
{
    if (_imageArray==nil) {
        _imageArray=[NSArray arrayWithObjects:@"image01",@"image02",@"image03",@"image05",@"image06", nil];
    }
    return _imageArray;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self.selectionStyle=UITableViewCellSelectionStyleNone;
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        UIScrollView * scrollView=[UIScrollView new];
        [self.contentView addSubview:scrollView];
        scrollView.sd_layout
        .leftSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,0)
        .topSpaceToView(self.contentView,0)
        .heightIs(160);
        
        CGFloat margin=10;
        NSArray * titleArray=@[@"效果图",@"交通图",@"样板间",@"实景图",@"小区配套"];
        for (int i=0; i<self.imageArray.count; i++) {
            AlbumButton * album=[[AlbumButton alloc]initWithFrame:CGRectMake((120 +margin)*i +margin, 20, 120, 120)];
            [album setImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
            [album setTitle:titleArray[i] forState:UIControlStateNormal];
            [album.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [album setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
            [scrollView addSubview:album];
        }
        
        scrollView.contentSize=CGSizeMake(margin*2+(120+margin)*self.imageArray.count, 160);
        
        
        
        
        
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
