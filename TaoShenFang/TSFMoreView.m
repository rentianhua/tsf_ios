//
//  TSFMoreView.m
//  YXM下拉框
//
//  Created by YXM on 16/11/7.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFMoreView.h"
#import "TSFMoreCollectionCell.h"
#import "TSFCollectionHeadView.h"
#import "TSFCollectionFooterView.h"
#define KSCREENW [UIScreen mainScreen].bounds.size.width
#define KSCREENH [UIScreen mainScreen].bounds.size.height


@interface TSFMoreView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UIView * _BGView;
}

@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)NSArray * array;
@property (nonatomic,strong)NSArray * secArray;

@property (nonatomic,strong)NSMutableDictionary *selDic;
@end

@implementation TSFMoreView


- (UICollectionView *)collectionView{
    if (_collectionView==nil) {
        UICollectionViewFlowLayout * flowLayout=[[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KSCREENW, self.bounds.size.height) collectionViewLayout:flowLayout];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.backgroundColor=[UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"TSFMoreCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"TSFCollectionHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        //TSFCollectionFooterView.h
        [_collectionView registerNib:[UINib nibWithNibName:@"TSFCollectionFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array secArray:(NSArray *)secArray{
    if (self=[super initWithFrame:frame]) {
        _BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENW, self.bounds.size.height)];
        _BGView.backgroundColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.3];
        [self addSubview:_BGView];
        
        [_BGView addSubview:self.collectionView];
        
        _array=array;
        _secArray=secArray;
        _selDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.secArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.array[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TSFMoreCollectionCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.label.text=self.array[indexPath.section][indexPath.row];
    if([self isSelected:indexPath.section row:indexPath.row])
    {
        cell.label.layer.borderColor=[UIColor colorWithRed:35/255.0 green:172/255.0 blue:113/255.0 alpha:1.0].CGColor;
        cell.label.textColor=[UIColor colorWithRed:35/255.0 green:172/255.0 blue:113/255.0 alpha:1.0];
    }
    else
    {
        cell.label.layer.borderColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0].CGColor;
        cell.label.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    }
    return cell;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(KSCREENW*0.3, 21);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5,5,5,5);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        TSFCollectionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"  forIndexPath:indexPath];
        
        headerView.label.text=self.secArray[indexPath.section];
        reusableview = headerView;

    } else{
        
        if (indexPath.section==self.secArray.count-1) {
            TSFCollectionFooterView * footer=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
            
            [footer.cleanBtn addTarget:self action:@selector(cleanAction:) forControlEvents:UIControlEventTouchUpInside];
            [footer.okBtn addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
            reusableview=footer;
        } else{
            reusableview=nil;
        }
        
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(KSCREENH, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section==self.secArray.count-1) {
        return CGSizeMake(KSCREENH, 50);
    } else{
        return CGSizeMake(0, 0);
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSString * string=self.array[indexPath.section][indexPath.row];
    //self.moreSeleblock(indexPath.section,string);
    [self selectedItem:indexPath.section row:indexPath.row];
    [collectionView reloadData];
}

- (void)selectedItem:(NSInteger)section row:(NSInteger)row
{
    NSNumber *sec = [NSNumber numberWithInteger:section];
    NSNumber *rowNumber = [self.selDic objectForKey:sec];
    if(rowNumber && [rowNumber integerValue] == row)
    {
        [self.selDic removeObjectForKey:sec];
    }
    else
    {
        [self.selDic setObject:[NSNumber numberWithInteger:row] forKey:sec];
    }
}

- (BOOL)isSelected:(NSInteger)section row:(NSInteger)row
{
    NSNumber *sec = [NSNumber numberWithInteger:section];
    NSNumber *rowNumber = [self.selDic objectForKey:sec];
    if(rowNumber && [rowNumber integerValue] == row)
        return YES;
    return NO;
}

//多选
- (void)okAction:(UIButton *)button{
    if(self.selDic.count>0)
    {
        NSMutableDictionary *valDic = [NSMutableDictionary dictionary];
        for(NSNumber *sec in self.selDic.allKeys)
        {
            NSNumber *row = [self.selDic objectForKey:sec];
            if(row)
            {
                [valDic setObject:self.array[[sec integerValue]][[row integerValue]] forKey:sec];
            }
        }
        self.moreSeleblock(valDic);
    }
    else
    {
        self.moreSeleblock(nil);
    }
}

//清空
- (void)cleanAction:(UIButton *)button{
    [self.selDic removeAllObjects];
    [self.collectionView reloadData];
    
    self.moreSeleblock(nil);
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}



@end
