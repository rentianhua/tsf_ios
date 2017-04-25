//
//  TSFAddCollectionCell.m
//  TaoShenFang
//
//  Created by YXM on 16/11/29.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFAddCollectionCell.h"
#import "OtherHeader.h"
#import "NewCollectionCell.h"
#import "TSFPicsModel.h"
#import <UIImageView+WebCache.h>

@interface TSFAddCollectionCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSMutableArray * firstArray;//显示每种图片的第一张

@end


@implementation TSFAddCollectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UICollectionViewFlowLayout * flowLayout=[[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 322) collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor=[UIColor whiteColor];
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"NewCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [self.contentView addSubview:self.collectionView];
  
    }
    return self;
}

//self.albumArray1=[NSMutableArray arrayWithObjects:model.loupantupian,model.weizhitu,model.yangbantu,model.shijingtu,model.xiaoqutu, nil];
- (void)setImgArray:(NSMutableArray *)imgArray{
    _imgArray=imgArray;//楼盘相册
    _firstArray=[NSMutableArray array];
    if (_imgArray!=NULL) {
        NSArray * array1=_imgArray[0];
        NSArray * array2=_imgArray[1];
        NSArray * array3=_imgArray[2];
        NSArray * array4=_imgArray[3];
        NSArray * array5=_imgArray[4];
        
        if (array1.count!=0)
        {
            TSFPicsModel * model=array1[0];
            TSFPicsModel *xc = [[TSFPicsModel alloc] init];
            xc.url = model.url;
            xc.alt = [NSString stringWithFormat:@"效果图(%lu)", (unsigned long)array1.count];
            [_firstArray addObject:xc];
        }
        
        if (array2.count!=0)
        {
            TSFPicsModel * model=array2[0];
            TSFPicsModel *xc = [[TSFPicsModel alloc] init];
            xc.url = model.url;
            xc.alt = [NSString stringWithFormat:@"交通图(%lu)", (unsigned long)array2.count];
            [_firstArray addObject:xc];
        }
        
        if (array3.count!=0)
        {
            TSFPicsModel * model=array3[0];
            TSFPicsModel *xc = [[TSFPicsModel alloc] init];
            xc.url = model.url;
            xc.alt = [NSString stringWithFormat:@"样板间(%lu)", (unsigned long)array3.count];
            [_firstArray addObject:xc];
        }
        
        if (array4.count!=0)
        {
            TSFPicsModel * model=array4[0];
            TSFPicsModel *xc = [[TSFPicsModel alloc] init];
            xc.url = model.url;
            xc.alt = [NSString stringWithFormat:@"实景图(%lu)", (unsigned long)array4.count];
            [_firstArray addObject:xc];
        }
        
        if (array5.count!=0)
        {
            TSFPicsModel * model=array5[0];
            TSFPicsModel *xc = [[TSFPicsModel alloc] init];
            xc.url = model.url;
            xc.alt = [NSString stringWithFormat:@"小区配套(%lu)", (unsigned long)array5.count];
            [_firstArray addObject:xc];
        }
    }

    [self.collectionView reloadData];
}

#pragma mark------UICollectionViewDelegate--------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    int rows=0;
    for (NSArray * array in _imgArray) {
        if (array.count!=0) {
            rows=rows+1;
        }
    }
    return rows;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    NewCollectionCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        TSFPicsModel * model=_firstArray[indexPath.row];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.url]] placeholderImage:[UIImage imageNamed:@"card_default"]];
        cell.title.text=model.alt;

    return cell;

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kMainScreenWidth-15*4)/3, 1.31*(kMainScreenWidth-15*4)/3);
    //return CGSizeMake(100, 131);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    _selectBlock();
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
