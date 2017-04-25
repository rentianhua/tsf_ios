//
//  TSFAddOtherCollectionCell.m
//  TaoShenFang
//
//  Created by YXM on 16/11/29.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFAddOtherCollectionCell.h"
#import "OtherHeader.h"

#import <UIImageView+WebCache.h>
#import "RecommCollectionCell.h"

#import "NewHouseModel.h"
#import "HouseModel.h"
#import "IDModel.h"

@interface TSFAddOtherCollectionCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UICollectionView * collectionView;

@end


@implementation TSFAddOtherCollectionCell

- (void)setRecommArray:(NSArray *)recommArray{
    _recommArray=recommArray;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UICollectionViewFlowLayout * flowLayout=[[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 322) collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor=[UIColor whiteColor];
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"RecommCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [self.contentView addSubview:self.collectionView];
        
    }
    return self;
}


#pragma mark------UICollectionViewDelegate--------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _recommArray.count;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RecommCollectionCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NewHouseModel * model=_recommArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.data.thumb]] placeholderImage:[UIImage imageNamed:@"card_default"]];
    cell.titleLabel.text=model.data.title;
    cell.priceLabel.text=[NSString stringWithFormat:@"%@元/㎡",model.data.junjia];
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width=(kMainScreenWidth -15*3)*0.5;
    CGFloat height=width*2/3+30;
    return CGSizeMake(width, height);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NewHouseModel * model=_recommArray[indexPath.row];
    IDModel * idmodel=[[IDModel alloc]init];
    idmodel.catid=model.catid;
    idmodel.ID=model.ID;
    
    _itemBlock(idmodel);
    
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
