//
//  TSFNewInfoCell.m
//  TaoShenFang
//
//  Created by YXM on 16/11/25.
//  Copyright © 2016年 RA. All rights reserved.
//

#import "TSFNewInfoCell.h"

@implementation TSFNewInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    self.label3.layer.masksToBounds=YES;
    self.label3.layer.cornerRadius=3;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef contextRef=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(contextRef, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:0.5].CGColor);
    CGContextStrokeRect(contextRef, CGRectMake(15, rect.size.height-0.5, rect.size.width-30, 0.5));
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
