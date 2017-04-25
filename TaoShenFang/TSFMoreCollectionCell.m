//
//  TSFMoreCollectionCell.m
//  YXM下拉框
//
//  Created by YXM on 16/11/8.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFMoreCollectionCell.h"

@implementation TSFMoreCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.label.layer.borderWidth=0.8;
    self.label.layer.borderColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0].CGColor;
    
    self.label.layer.masksToBounds=YES;
    self.label.layer.cornerRadius=3;
    
    self.label.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
}

@end
