//
//  MyCollectionCell.m
//  TaoShenFang
//
//  Created by YXM on 16/8/27.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "MyCollectionCell.h"

@implementation MyCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.layer.borderWidth=0.8;
    self.textField.layer.borderColor=[UIColor lightGrayColor].CGColor;
}

- (IBAction)deleteAction:(id)sender {
}
@end
